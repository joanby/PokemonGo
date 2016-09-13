//
//  ViewController.swift
//  PokemonGo
//
//  Created by Juan Gabriel Gomila Salas on 31/8/16.
//  Copyright © 2016 Juan Gabriel Gomila Salas. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    var manager = CLLocationManager()
    
    var updateCount = 0
    
    let mapDistance : CLLocationDistance = 300
    
    let captureDistance : CLLocationDistance = 150
    
    var pokemonSpawnTimer : TimeInterval = 30
    
    var pokemons : [Pokemon] = []
    
    var totalFrequency = 0
    
    var hasStartedTheMap = false
    
    var hasMovedToAnotherView = false
    
    var timer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager.delegate = self
        
       
        self.pokemons = getAllThePokemons()
        
        for p in self.pokemons {
            totalFrequency += Int(p.frequency)
        }
        
        
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {

            setupMap()
            
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            setupMap()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer.invalidate()
        self.hasMovedToAnotherView = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.hasMovedToAnotherView {
            self.startTimer()
        }
    }
    
    
    
    func setupMap() {
        
        if !self.hasStartedTheMap {
        
            self.hasStartedTheMap = true
            
            self.mapView.delegate = self
            self.mapView.showsUserLocation = true
            self.manager.startUpdatingLocation()
            
            self.startTimer()
        }
    }
    
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: pokemonSpawnTimer, repeats: true, block: { (timer) in
            
            if let coordinate = self.manager.location?.coordinate {
                
                let randomNumber = Int(arc4random_uniform(UInt32(self.totalFrequency)))
                
                var pokemonFrequenciesAcum = 0
                
                var pokemon : Pokemon = self.pokemons[0]
                for p in self.pokemons {
                    pokemon = p
                    pokemonFrequenciesAcum += Int(p.frequency)
                    if pokemonFrequenciesAcum >= randomNumber {
                        break
                    }
                }
                
                
                let annotation = PokemonAnnotation(coordinate: coordinate, pokemon: pokemon)
                annotation.coordinate.latitude += (Double(arc4random_uniform(1000)) - 500.0)/400000.0
                annotation.coordinate.longitude += (Double(arc4random_uniform(1000)) - 500.0)/400000.0
                self.mapView.addAnnotation(annotation)
            }
            
        })
    }
    
    
    // MARK: Map View Delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            annotationView.image = #imageLiteral(resourceName: "player")
        }else {
            
            let pokemon = (annotation as! PokemonAnnotation).pokemon
            
            annotationView.image = UIImage(named: pokemon.imageFileName!)
        }
        
        var newFrame = annotationView.frame
        newFrame.size.height = 40
        newFrame.size.width = 40
        annotationView.frame = newFrame
        
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        if view.annotation! is MKUserLocation {
            return
        }
        
        
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, captureDistance, captureDistance)
        self.mapView.setRegion(region, animated: false)
    
        if let coordinate = self.manager.location?.coordinate {
            if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coordinate)) {
                print("Podemos capturar el Pokemon")
                let vc = BattleViewController()
                vc.pokemon = (view.annotation! as! PokemonAnnotation).pokemon
                self.mapView.removeAnnotation(view.annotation!)
                self.present(vc, animated: true, completion: nil)
                
            } else {
                print("Demasiado lejos para cazar ese Pokemon")
                let pokemon = (view.annotation! as! PokemonAnnotation).pokemon
                let alertController = UIAlertController(title: "Estás demasiado lejos!", message: "Acercate a ese \(pokemon.name!) para poder capturarlo", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        
    }
    
    @IBAction func updateUserLocation(_ sender: UIButton) {
        if let coordinate = self.manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, mapDistance, mapDistance)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

