//
//  GameScene.swift
//  RoosterRun
//
//  Created by Zixiang Zhu on 1/24/17.
//  Copyright © 2017 zixiangzhu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var fireworks : SKSpriteNode?
    private var spinnyNode : SKShapeNode?
    
    private var fireworks_init_xpos : CGFloat?
    
    private var fireworksList : Array<SKSpriteNode> = Array()
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.fireworks = self.childNode(withName: "fireworks") as? SKSpriteNode
        
        //get initial firworks position
        self.fireworks_init_xpos = self.fireworks?.position.x
        
        //initialize fireworksList
        if let n = self.fireworks?.copy() as! SKSpriteNode? {
            self.addChild(n)
            self.fireworksList.append(n)
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        let screen_zero : CGFloat = -376.0 //change this to a variable
        let screen_max_lower : CGFloat = 200.0
        let screen_max_upper: CGFloat = 203.0
        
        print(fireworksList.count)
        
        for (i, fireworks) in fireworksList.enumerated() {
            let xpos = fireworks.position.x
            let ypos = fireworks.position.y
            
            if(xpos <= screen_zero) {
                fireworksList.remove(at: i)
            } else {
                if (i == fireworksList.count - 1 //last object
                    && xpos >= screen_max_lower
                    && xpos < screen_max_upper) {
                    if let n = self.fireworks?.copy() as! SKSpriteNode? {
                        self.addChild(n)
                        fireworksList.append(n)
                    }
                }
                
                fireworks.position = CGPoint(x: xpos - 3, y: ypos)
            }
        }
        
        
    }
}
