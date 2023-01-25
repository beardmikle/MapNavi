//
//  ViewController.swift
//  MapNavi
//
//  Created by beardmikle on 19.01.2023.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    let mapView : MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let addAdressButton = UIButton ()
    
    let routeButton = UIButton ()

    let resetButton = UIButton ()
    
    
    var  annotaionsArray = [MKPointAnnotation]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        setConstraints()
        setConstraintsAdd()
        setConstraintsRoute()
        setConstraintsReset()
         
        addAdressButton.addTarget(self, action: #selector(addAdressButtonTapped), for: .touchUpInside)
        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
    }
    
    
    @objc func addAdressButtonTapped() {
        alertAddAdress(title: "Add adress", placeholder: "Add adress:") { [self] (text) in
            setupPlacemark(adressPlace:text)
        }
    }
    
    @objc func routeButtonTapped() {
        for index in 0...annotaionsArray.count - 2  {
            createDirectionReguest(startCoordinate: annotaionsArray[index].coordinate, destinationCoordinate: annotaionsArray[index + 1].coordinate)
        }
        
        mapView.showAnnotations(annotaionsArray, animated: true)
        
    }

    @objc func resetButtonTapped() {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        annotaionsArray = [MKPointAnnotation]()
        routeButton.isHidden = true
        resetButton.isHidden = true
        
    }
    
    private func setupPlacemark(adressPlace: String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(adressPlace) { [self] (placemarks , error) in
            
            if let error = error {
                print(error)
                alertError(title: "Warning", message: "Server disconnect! Try again!")
                return
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            
            let annotation = MKPointAnnotation()
            annotation.title = "\(adressPlace)"
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
        
        
            annotaionsArray.append(annotation)
            
            if annotaionsArray.count > 2 {
                routeButton.isHidden = false
                resetButton.isHidden = false
            }
            
            mapView.showAnnotations(annotaionsArray, animated: true )
            
        }
    }
    
    private func createDirectionReguest(startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        
        let startLocation = MKPlacemark(coordinate: startCoordinate)
        let destinationLocation = MKPlacemark(coordinate: destinationCoordinate)
        
        let reguest = MKDirections.Request()
        reguest.source = MKMapItem(placemark: startLocation)
        reguest.destination = MKMapItem(placemark: destinationLocation)
        reguest.transportType = .walking
        reguest.requestsAlternateRoutes = true
        
        let direction = MKDirections(request: reguest)
        
        direction.calculate { (responce, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let responce = responce else {
                self.alertError(title: "Warning", message: "The route is not available!")
                return
            }
            
            var minRoute = responce.routes[0]
            for route in responce.routes{
                minRoute = (route.distance < minRoute.distance) ? route: minRoute
            }
            
            self.mapView.addOverlay(minRoute.polyline)
            
        }
        
    }
    
    
    
}
extension  ViewController:MKMapViewDelegate {
     
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        return renderer
    }
    
    
}

extension ViewController {
    
    func setConstraints() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),

        ])
    }
    

    func setConstraintsAdd() {
    mapView.addSubview(addAdressButton)
        addAdressButton.setImage(UIImage(named: "addAdress"), for: .normal)
        addAdressButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        addAdressButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 50),
        addAdressButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20 ),
        addAdressButton.heightAnchor.constraint(equalToConstant: 80),
        addAdressButton.widthAnchor.constraint(equalToConstant: 80)

        ])
    }
        
    func setConstraintsRoute() {
    mapView.addSubview(routeButton)
        routeButton.setImage(UIImage(named: "route"), for: .normal)
        routeButton.translatesAutoresizingMaskIntoConstraints = false
        routeButton.isHidden =  true
        NSLayoutConstraint.activate([
        routeButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -30),
        routeButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -100 ),
        routeButton.heightAnchor.constraint(equalToConstant: 80),
        routeButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }

    func setConstraintsReset() {
    mapView.addSubview(resetButton)
        resetButton.setImage(UIImage(named: "reset"), for: .normal)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.isHidden =  true
        NSLayoutConstraint.activate([
        resetButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 30),
        resetButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -100 ),
        resetButton.heightAnchor.constraint(equalToConstant: 80),
        resetButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
        
}




