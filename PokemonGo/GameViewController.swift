//
//  GameViewController.swift
//  PokemonGo
//
//  Created by Juan Gabriel Gomila Salas on 4/9/16.
//  Copyright © 2016 Juan Gabriel Gomila Salas. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var pokemon : Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let scene = MyScene(size:CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view = SKView()
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        scene.pokemon = pokemon
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeBattle), name: NSNotification.Name(rawValue: "closeBattle"), object: nil)

       
        
    }
    
    func closeBattle() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
