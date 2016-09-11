//
//  BattleScene.swift
//  PokemonGo
//
//  Created by Juan Gabriel Gomila Salas on 11/9/16.
//  Copyright © 2016 Juan Gabriel Gomila Salas. All rights reserved.
//

import SpriteKit
import UIKit

class BattleScene: SKScene, SKPhysicsContactDelegate {
    
    var pokemon : Pokemon!
    var pokemonSprite : SKNode!
    var pokeballSprite : SKNode!
    
    let kPokemonSize : CGSize = CGSize(width: 50, height: 50)
    let kPokemonName : String = "pokemon"
    let kPokeballName : String = "pokeball"
    
    let pokemonDistance = 150.0
    let pokemonPixelsPerSecond = 75.0
    
    
    let kPokemonCategory : UInt32 = 0x1 << 0
    let kPokeballCategory : UInt32 = 0x1 << 1
    let kSceneEdgeCategory : UInt32 = 0x1 << 2
    
    var velocity : CGPoint = CGPoint.zero
    var touchPoint : CGPoint = CGPoint()
    var canThrowPokeball = false
    
    var pokemonCaught = false
    
    var startCount = true
    var maxTime = 30
    var myTime = 30
    var printTime = SKLabelNode(fontNamed: "arial")
    
    
    override func didMove(to view: SKView) {

        let bgImage = SKSpriteNode(imageNamed: "background")
        bgImage.size = self.size
        bgImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        bgImage.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bgImage.zPosition = -1
        self.addChild(bgImage)
        
        self.printTime.position = CGPoint(x: self.size.width/2.0, y: self.size.height*0.9)
        self.addChild(self.printTime)
        
        self.showMessageWith(imageNamed: "battle")

        
        
        self.perform(#selector(setupPokemon), with: nil, afterDelay: 1.0)
        self.perform(#selector(setupPokeball), with: nil, afterDelay: 1.0)
        
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody!.categoryBitMask = kSceneEdgeCategory
        self.physicsWorld.contactDelegate = self
        
    }
    
    
    func createPokemon() -> SKNode {
        let pokemonSprite = SKSpriteNode(imageNamed: self.pokemon.imageFileName!)
        pokemonSprite.size = kPokemonSize
        pokemonSprite.name = kPokemonName
        return pokemonSprite
    }
    
    
    func setupPokemon() {
        self.pokemonSprite = self.createPokemon()
        self.pokemonSprite.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        self.pokemonSprite.physicsBody = SKPhysicsBody(rectangleOf: kPokemonSize)
        self.pokemonSprite.physicsBody!.isDynamic = false
        self.pokemonSprite.physicsBody!.affectedByGravity = false
        self.pokemonSprite.physicsBody!.mass = 1.0

        self.pokemonSprite.physicsBody!.categoryBitMask = kPokemonCategory
        self.pokemonSprite.physicsBody!.contactTestBitMask = kPokeballCategory
        self.pokemonSprite.physicsBody!.collisionBitMask = kSceneEdgeCategory
        
        
        
        let moveRight = SKAction.moveBy(x: CGFloat(self.pokemonDistance), y: 0, duration: self.pokemonDistance/self.pokemonPixelsPerSecond)
        let sequence = SKAction.sequence([moveRight, moveRight.reversed(), moveRight.reversed(), moveRight])
        self.pokemonSprite.run(SKAction.repeatForever(sequence))
        
        self.addChild(self.pokemonSprite)
        
    }
    
    
    func createPokeball() -> SKNode {
        let pokeballSprite = SKSpriteNode(imageNamed: "pokeball")
        pokeballSprite.size = kPokemonSize
        pokeballSprite.name = kPokeballName
        return pokeballSprite
    }
    
    func setupPokeball() {
        self.pokeballSprite = createPokeball()
        self.pokeballSprite.position = CGPoint(x: self.size.width/2, y: 50)
        
        self.pokeballSprite.physicsBody = SKPhysicsBody(circleOfRadius: self.pokeballSprite.frame.size.width/2.0)
        self.pokeballSprite.physicsBody!.isDynamic = true
        self.pokeballSprite.physicsBody!.affectedByGravity = true
        self.pokeballSprite.physicsBody!.mass = 0.1
        
        self.pokeballSprite.physicsBody!.categoryBitMask = kPokeballCategory
        self.pokeballSprite.physicsBody!.contactTestBitMask = kPokemonCategory
        self.pokeballSprite.physicsBody!.collisionBitMask = kSceneEdgeCategory | kPokemonCategory
        
        
        
        self.addChild(self.pokeballSprite)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        if self.pokeballSprite.frame.contains(location!) {
            self.canThrowPokeball = true
            self.touchPoint = location!
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        self.touchPoint = location!
        if canThrowPokeball {
            self.throwPokeball()
        }
    }
    
    
    func throwPokeball() {
        self.canThrowPokeball = false
        
        let dt: CGFloat = 1.0/20.0
        let distance = CGVector(dx: self.touchPoint.x - self.pokeballSprite.position.x, dy: self.touchPoint.y - self.pokeballSprite.position.y)
        let velocity = CGVector(dx: distance.dx / dt, dy: distance.dy / dt)
        self.pokeballSprite.physicsBody!.velocity = velocity
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case kPokemonCategory|kPokeballCategory:
            print("capturado!")
            self.pokemonCaught = true
            endGame()
        default:
            return
        }
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if self.startCount {
            self.maxTime = Int(currentTime) + self.maxTime
            self.startCount = false
        }
        self.myTime = self.maxTime - Int(currentTime)
        self.printTime.text = "\(self.myTime)"
        if self.myTime <= 0 {
            endGame()
        }
        
    }
    
    
    
    
    func endGame() {
        
        self.pokemonSprite.removeFromParent()
        self.pokeballSprite.removeFromParent()
        
        if self.pokemonCaught {
            print("Pokemon Capturado")
            
            self.pokemon.timesCaught += 1
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.showMessageWith(imageNamed: "gotcha")

        } else {
            print("Me he quedado sin tiempo")
            self.showMessageWith(imageNamed: "footprints")
        }
        
        self.perform(#selector(endBattle), with: nil, afterDelay: 1.0)
    }
    
    func showMessageWith(imageNamed: String){
        let message = SKSpriteNode(imageNamed: imageNamed)
        message.size = CGSize(width: 150, height: 150)
        message.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(message)
        
        message.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.removeFromParent()]))

    }
    
    
    func endBattle(){
        NotificationCenter.default.post(name: NSNotification.Name("closeBattle"), object: nil)
    }
    
}
