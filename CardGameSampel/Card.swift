//
//  Card.swift
//  CardGameSampel
//
//  Created by pyn on 2016/04/20.
//  Copyright © 2016年 pyngit. All rights reserved.
//

import Foundation
import SpriteKit

enum CardName: Int {
    case
    A = 0,
    B = 1,
    C = 2,
    D = 3,
    E = 4,
    F = 5
}

class Card : SKSpriteNode {
    let frontTexture :SKTexture
    let backTexture :SKTexture
    //表向き
    var faceUp = true
    var selectCard:Bool = false;
    //手札にある
    var handCard:Bool = true;
    //手札にある時の位置
    var handCardPosition:CGFloat = 0;

    /**
     ランダムで生成
    */
    convenience init(){
        //他のinitを呼ぶ変わりに初期化はしないでもいい
        self.init(cardNamed:CardName(rawValue: Int(arc4random_uniform(6)))!);
    }
    init(cardNamed: CardName) {
        
        // initialize properties
        backTexture = SKTexture(imageNamed: "CardBack")
        
        switch cardNamed {
        case .A:
            frontTexture = SKTexture(imageNamed: "CardA")
        case .B:
            frontTexture = SKTexture(imageNamed: "CardB")
        case .C:
            frontTexture = SKTexture(imageNamed: "CardC")
        case .D:
            frontTexture = SKTexture(imageNamed: "CardD")
        case .E:
            frontTexture = SKTexture(imageNamed: "CardE")
        case .F:
            frontTexture = SKTexture(imageNamed: "CardF")
        default:
            frontTexture = SKTexture(imageNamed: "CardBack")
        }
        
        // call designated initializer on super
        super.init(texture: frontTexture, color: UIColor.whiteColor(), size: frontTexture.size())
        
        
        // set properties defined in super
        userInteractionEnabled = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            if(handCard){
                if(!selectCard){
                    let scaleUp = SKAction.scaleTo(1.2, duration: 0.2)
                    runAction(scaleUp);
                    selectCard = true;
                }else{
                    let scaleDown = SKAction.scaleTo(1.0, duration: 0.2)
                    runAction(scaleDown);
                    selectCard = false;
                }
            }else{
                if touch.tapCount > 1 {
                    //裏がえす
                    flip()
                }
                //レイヤーの一番上に
                zPosition = 15
                let liftUp = SKAction.scaleTo(1.2, duration: 0.2)
                runAction(liftUp)
                
                let wiggleIn = SKAction.scaleXTo(1.0, duration: 0.2)
                let wiggleOut = SKAction.scaleXTo(1.2, duration: 0.2)
                let wiggle = SKAction.sequence([wiggleIn, wiggleOut])
                let wiggleRepeat = SKAction.repeatActionForever(wiggle)
                
                // again, since this is the touched sprite
                // run the action on self (implied)
                runAction(wiggleRepeat, withKey: "wiggle")
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(!handCard){
            for touch in touches {
                //シーン状のタッチされたポジションを取得する。
                let location = touch.locationInNode(scene!)
                position = location
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            if(!handCard){
                zPosition = 0
                let dropDown = SKAction.scaleTo(1.0, duration: 0.2)
                runAction(dropDown)
                removeActionForKey("wiggle")
            }
        }
    }
    
    //MARK: Card Actions
    func flip() {
        let firstHalfFlip = SKAction.scaleXTo(0.0, duration: 0.4)
        let secondHalfFlip = SKAction.scaleXTo(1.0, duration: 0.4)
        
        setScale(1.0)
        
        if faceUp {
            runAction(firstHalfFlip) {
                self.texture = self.backTexture
                self.faceUp = false
                self.runAction(secondHalfFlip)
            }
        } else {
            runAction(firstHalfFlip) {
                self.texture = self.frontTexture
                self.faceUp = true
                self.runAction(secondHalfFlip)
            }
        }
    }
    


}