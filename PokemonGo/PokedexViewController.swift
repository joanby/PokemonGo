//
//  PokedexViewController.swift
//  PokemonGo
//
//  Created by Juan Gabriel Gomila Salas on 1/9/16.
//  Copyright © 2016 Juan Gabriel Gomila Salas. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var caughtPokemons : [Pokemon] = []
    var uncaughtPokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.caughtPokemons = getAllCaughtPokemons()
        self.uncaughtPokemons = getAllUncaughtPokemons()
        
        print("CAPTURADOS: \(self.caughtPokemons.count)")
        print("NO CAPTURADOS: \(self.uncaughtPokemons.count)")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Capturados"
        }else {
            return "No capturados"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.caughtPokemons.count
        } else {
            return self.uncaughtPokemons.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as! PokemonTableViewCell
        
        var pokemon : Pokemon
        if indexPath.section == 0 {
            pokemon = self.caughtPokemons[indexPath.row]
            cell.pokemonTimesCaughtLabel.text = "Veces capturado: \(pokemon.timesCaught)"
        } else {
            pokemon = self.uncaughtPokemons[indexPath.row]
            cell.pokemonTimesCaughtLabel.text = ""
        }
                
        cell.pokemonNameLabel?.text = pokemon.name
        cell.pokemonImageView?.image = UIImage(named: pokemon.imageFileName!)
        
        return cell
    }
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backToMapPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }


}
