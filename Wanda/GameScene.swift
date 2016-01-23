//
//  GameScene.swift
//  Wanda
//
//  Created by Luke on 1/19/16.
//  Copyright (c) 2016 Luke. All rights reserved.
//

import SpriteKit

let wallMask:UInt32 = 0x1 << 0
let fishMask:UInt32 = 0x1 << 1
let tankMask:UInt32 = 0x1 << 2

//let squareMask:UInt32 = 0x1 << 3

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var touchLocation:CGPoint!
    
    var fish:SKSpriteNode!
    var tank:SKSpriteNode!
    var jumpAllowed:Bool = false
    
    var followCam:SKCameraNode!
    var nodeForCameraToFollow:SKNode!
    
    var labelTxt: SKLabelNode!
    var btnRight: SKSpriteNode!
    var btnLeft: SKSpriteNode!
    var btnJump: SKSpriteNode!
    
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        createUi()
    }
    
    func createUi(){
        
        followCam = self.childNodeWithName("camera") as! SKCameraNode
        
        //move right
        btnRight = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: 150, height: 100))
        btnRight.position = CGPointMake(followCam.frame.maxX, -175)
        btnRight.zPosition = 10
        followCam.addChild(btnRight)
        
        //move left
        btnLeft = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: 150, height: 100))
        btnLeft.position = CGPointMake(-530, -175)
        btnLeft.zPosition = 10
        followCam.addChild(btnLeft)
        
        //jump
        btnJump = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width: 300, height: 100))
        btnJump.position = CGPointMake(0, -175)
        btnJump.zPosition = 10
        followCam.addChild(btnJump)
        
        //Time label
        labelTxt = SKLabelNode()
        labelTxt.position = CGPointMake(0,followCam.frame.maxY + 20)
        followCam.addChild(labelTxt)
        
        setFish()
        setTanks()

    }
    
    func setFish(){
        
        fish = self.childNodeWithName("fish") as! SKSpriteNode
        fish.physicsBody?.collisionBitMask = wallMask | tankMask
        //fish.physicsBody?.contactTestBitMask = fish.physicsBody!.collisionBitMask | squareMask
        fish.physicsBody?.pinned = false
        fish.physicsBody?.dynamic = true
        fish.physicsBody?.affectedByGravity = true
        fish.physicsBody?.allowsRotation = false
        fish.physicsBody?.categoryBitMask = fishMask
        //fish.physicsBody?.collisionBitMask = fishMask
        fish.zPosition = 1
        
        nodeForCameraToFollow = fish
    
    }
    func setTanks(){
        
        tank = self.childNodeWithName("tank") as! SKSpriteNode
        tank.texture = SKTexture(imageNamed: "tank")
        
        let tank1 = self.childNodeWithName("tank2") as! SKSpriteNode
        tank1.texture = SKTexture(imageNamed: "tank")
        let tank2 = self.childNodeWithName("tank3") as! SKSpriteNode
        tank2.texture = SKTexture(imageNamed: "tank")
        
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchLocation = touches.first!.locationInNode(followCam)
        
            
            if btnRight.frame.contains(touchLocation) {
                
                //print("Right")
                fish.physicsBody?.applyImpulse(CGVector(dx: 30, dy: 0))
                fish.texture = SKTexture(imageNamed: "Fish1R")
            }
            if btnLeft.frame.contains(touchLocation) {
        
                //print("Left")
                fish.physicsBody?.applyImpulse(CGVector(dx: -30, dy: 0))
                fish.texture = SKTexture(imageNamed: "Fish1L")
            }
            else if btnJump.frame.contains(touchLocation)  && jumpAllowed == true{
                
                print("Jump")
                fish.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 140))
            }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchLocation = touches.first!.locationInNode(self)
        //drag
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        followCam.runAction(SKAction.scaleTo(1.5, duration: 0.5))

    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        jumpAllowed = true
        
        let fish = (contact.bodyA.categoryBitMask == fishMask) ? contact.bodyA : contact.bodyB
        let other = (fish == contact.bodyA) ? contact.bodyB : contact.bodyA
        
        if other.categoryBitMask == tankMask {
            //other.node?.removeFromParent()
           // print("hit tank")
            //move fish slower
        }
        else if other.categoryBitMask == wallMask {
            //print("hit wall!")
            
        }
        /*else if other.categoryBitMask == squareMask {
            print("hit square!")
            //use for targets/bad guys
        }*/

    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
        //jumpAllowed = false
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        labelTxt.text = String(currentTime)
        
        if nodeForCameraToFollow != nil{
            
            //followCam.position = nodeForCameraToFollow.position
            followCam.position.x = nodeForCameraToFollow.position.x
            followCam.position.y = nodeForCameraToFollow.position.y / 2
        }
    }

}