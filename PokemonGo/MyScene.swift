//
//  MyScene.swift
//  PokemonGo
//
//  Created by Juan Gabriel Gomila Salas on 4/9/16.
//  Copyright © 2016 Juan Gabriel Gomila Salas. All rights reserved.
//

import UIKit
import SpriteKit

class MyScene: SKScene, SKPhysicsContactDelegate {
    
    var pokemon : Pokemon!
    var pokemonSprite: SKNode!
    var pokeballSprite: SKNode!
    
    let kPokemonSize: CGSize = CGSize(width: 30, height: 30)
    let kPokemonName: String = "pokemon"
    let kPokeballName: String = "pokeball"

    var pokemonPixelsPerSecond : CGFloat = 500.0
    var velocity = CGPoint.zero
    
    let kPokemonCategory: UInt32 = 0x1 << 0
    let kPokeballCategory: UInt32 = 0x1 << 1
    let kSceneEdgeCategory: UInt32 = 0x1 << 2
    
    var startCount = true
    var maxTime = 30
    var myTime = 30
    var printTime = SKLabelNode(fontNamed: "arial")
    
    var pokemonCaught = false

    //Configuración de la escena
    override func didMove(to view: SKView) {
        let bgImage = SKSpriteNode(imageNamed:"background" )
        bgImage.size = self.size
        bgImage.position = CGPoint(x:self.size.width/2, y: self.size.height/2)
        bgImage.anchorPoint = CGPoint(x:0.5, y:0.5)
        bgImage.zPosition = -1
        self.addChild(bgImage)
        
        self.printTime.position = CGPoint(x:self.size.width * 0.5, y:self.size.height * 0.9)
        self.addChild(self.printTime)
        
        let message = SKSpriteNode(imageNamed: "battle")
        message.size = CGSize(width: 150, height: 150)
        message.position = CGPoint(x: self.size.width/2, y: self.size.width/2)
        addChild(message)
        
        message.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.removeFromParent()]))
        
        self.perform(#selector(setupPokemon), with: nil, afterDelay: 1.0)
        self.perform(#selector(setupPokeball), with: nil, afterDelay: 1.0)

        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.contactDelegate = self
    }
    
    func createPokemon() -> SKNode{
        let pokemonSprite = SKSpriteNode(imageNamed: pokemon.imageFileName!)
        pokemonSprite.size = CGSize(width: 50, height: 50)
        pokemonSprite.name = kPokemonName
        return pokemonSprite
    }
    
    func setupPokemon(){
        pokemonSprite = createPokemon()
        pokemonSprite.position = CGPoint(x: (self.size.width)/2, y: (self.size.height)/2)
        
        pokemonSprite.physicsBody = SKPhysicsBody(rectangleOf: kPokemonSize)
        pokemonSprite.physicsBody!.isDynamic = false
        pokemonSprite.physicsBody!.affectedByGravity = false
        pokemonSprite.physicsBody!.mass = 1.0
        
        pokemonSprite.physicsBody!.categoryBitMask = kPokemonCategory
        pokemonSprite.physicsBody!.contactTestBitMask = kPokeballCategory
        pokemonSprite.physicsBody!.collisionBitMask = kSceneEdgeCategory
 
        
        let moveLeft = SKAction.moveBy(x: 150, y: 0, duration: 3)
        
        let sequence = SKAction.sequence([moveLeft, moveLeft.reversed(), moveLeft.reversed(), moveLeft])
        
        pokemonSprite.run(SKAction.repeatForever(sequence), withKey:  "moving")
        
        addChild(pokemonSprite)
    }
    
    func createPokeball() -> SKNode{
        let pokeballSprite = SKSpriteNode(imageNamed: "pokeball")
        pokeballSprite.size = CGSize(width: 50, height: 50)
        pokeballSprite.name = kPokeballName
        return pokeballSprite
    }
    
    func setupPokeball(){
        pokeballSprite = createPokeball()
        pokeballSprite.position = CGPoint(x: self.size.width/2, y: 50)
        pokeballSprite.physicsBody = SKPhysicsBody(rectangleOf: pokeballSprite.frame.size)

         pokeballSprite.physicsBody!.isDynamic = true
         pokeballSprite.physicsBody!.affectedByGravity = true
         pokeballSprite.physicsBody!.mass = 0.1
         
         pokeballSprite.physicsBody!.categoryBitMask = kPokeballCategory
         pokeballSprite.physicsBody!.contactTestBitMask = kPokemonCategory
         pokeballSprite.physicsBody!.collisionBitMask = kSceneEdgeCategory | kPokemonCategory
        
        
        addChild(pokeballSprite)
    }

    var touchPoint: CGPoint = CGPoint()
    var canThrowPokeball = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        if pokeballSprite.frame.contains(location!) {
            touchPoint = location!
            canThrowPokeball = true
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        touchPoint = location!
        if canThrowPokeball {
            throwPokeball()
        }

    }
    
    func throwPokeball(){
        canThrowPokeball = false
        
        let dt:CGFloat = 1.0/120.0
        let distance = CGVector(dx: touchPoint.x-pokeballSprite.position.x, dy: touchPoint.y-pokeballSprite.position.y)
        let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
        pokeballSprite.physicsBody!.velocity=velocity

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch(contactMask) {
            
        case kPokeballCategory | kPokemonCategory:
            print("contact made")
            pokemonCaught = true
            endGame()
        default:
            return
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if self.startCount == true {
            self.maxTime = Int(currentTime)+self.maxTime
            self.startCount = false
        }
        self.myTime = self.maxTime - Int(currentTime)
        self.printTime.text = ("\(self.myTime)")//put your label in update so it shows each second.
        if self.myTime <= 0 {
            endGame()
        }
    }
    
    
    func endGame(){
        
        pokemonSprite.removeFromParent()
        pokeballSprite.removeFromParent()
        
        if pokemonCaught {
            print("catched")
            let message = SKSpriteNode(imageNamed: "gotcha")
            message.position = CGPoint(x: self.size.width/2, y: self.size.width/2)
            message.size = CGSize(width: 150, height: 150)
            addChild(message)
            
        } else {
            print("buuuuh!!")
            let message = SKSpriteNode(imageNamed: "footprints")
            message.position = CGPoint(x: self.size.width/2, y: self.size.width/2)
            message.size = CGSize(width: 150, height: 150)
            addChild(message)
        }
        self.perform(#selector(endBattle), with: nil, afterDelay: 1.0)
    }
    
    func endBattle() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeBattle"),object:nil)
    }

    
}
