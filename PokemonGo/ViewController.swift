//
//  ViewController.swift
//  PokemonGo
//
//  Created by Juan Gabriel Gomila Salas on 31/8/16.
//  Copyright © 2016 Juan Gabriel Gomila Salas. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    
    var manager = CLLocationManager()
    
    var updateCount = 0
    
    let mapDistance : CLLocationDistance = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager.delegate = self
        
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            print("Estamos listos para salir a cazar Pokemons")
            self.mapView.showsUserLocation = true
            self.manager.startUpdatingLocation()
        } else {
            self.manager.requestWhenInUseAuthorization()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: Core Location Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if updateCount < 4 {
            if let coordinate = self.manager.location?.coordinate {
                let region = MKCoordinateRegionMakeWithDistance(coordinate, mapDistance, mapDistance)
                self.mapView.setRegion(region, animated: true)
                updateCount += 1
            }
        } else {
            self.manager.stopUpdatingLocation()
        }
        
    }
    
    @IBAction func updateUserLocation(_ sender: UIButton) {
        if let coordinate = self.manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, mapDistance, mapDistance)
            self.mapView.setRegion(region, animated: true)
        }
    }

}

