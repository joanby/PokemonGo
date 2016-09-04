//
//  PokemonAnnotation.swift
//  PokemonGo
//
//  Created by Juan Gabriel Gomila Salas on 4/9/16.
//  Copyright © 2016 Juan Gabriel Gomila Salas. All rights reserved.
//

import UIKit
import MapKit

class PokemonAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    
    init(coordinate: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordinate
        self.pokemon = pokemon
    }
    
}
