//
//  MainMenu.swift
//  SpriteKitIntro
//
//  Created by LDC on 12/8/15.
//  Copyright © 2015 LDC. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let game:GameScene = GameScene(fileNamed: "GameScene")!
        game.scaleMode = .AspectFill
        let transition:SKTransition = SKTransition.crossFadeWithDuration(1.0)
        self.view?.presentScene(game, transition: transition)
        
    }
    
    
}
