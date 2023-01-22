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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConstraints()
        setConstraintsAdd()
        setConstraintsRoute()
        setConstraintsReset()
         
        addAdressButton.addTarget(self, action: #selector(addAdressButtonTapped), for: .touchUpInside)
        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
    }
    
    
    @objc func addAdressButtonTapped() {
        alertAddAdress(title: "Add adress", placeholder: "Add adress:") { (text) in print(text)
        }
//        alertError(title: "Warning", message: "Server disconnect!")
    }
    
    @objc func routeButtonTapped() {
        print("TapRoute")
    }

    @objc func resetButtonTapped() {
        print("TapReset")
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
        routeButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 30),
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
        resetButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -30),
        resetButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -100 ),
        resetButton.heightAnchor.constraint(equalToConstant: 80),
        resetButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
        
}




