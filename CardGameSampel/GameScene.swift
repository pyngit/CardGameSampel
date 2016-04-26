//
//  GameScene.swift
//  CardGameSampel
//
//  Created by pyn on 2016/04/19.
//  Copyright © 2016年 pyngit. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    static let HAND_CARD_ROTATION:Double = 10.0 * M_PI / 180.0;
    static let HAND_CARD_COUNT_MAX:Int = 10;
    var handCardBasePosition:CGPoint = CGPoint(x:0,y:0);

    //手札カード
    var handCard:Array<Card> = [];
    //場のカード
    var fieldCard:Array<Card> = [];
    
    
    override func didMoveToView(view: SKView) {
        print("SKScene size: \(self.size)) scale:\(self.xScale)")
        //画面下中央を扇の中心とする
        handCardBasePosition = CGPoint(x:CGRectGetMidX(self.frame),y:0);

        
        //画面中央
        let labelNode:SKSpriteNode = createItemNode("\(CGRectGetMidX(self.frame)):\(CGRectGetMidY(self.frame))");
        labelNode.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame));
        self.addChild(labelNode);
        
        drawCard();
        drawCard();
    }
    /**
     タッチ開始
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    /**
     タッチ移動
     */
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    /**
     タッチ終了
     */
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    /**
     サイズ変更時によばれる
     */
    override func didChangeSize(oldSize:CGSize){
        print("didChangeSize oldSize:\(oldSize)");
    }
    /**
     毎フレーム更新時
     */
    override func update(currentTime: CFTimeInterval) {
    }
    /**
     手札にカードを加える
    */
    func drawCard(){
        //上限を超えてなければ追加
        if(GameScene.HAND_CARD_COUNT_MAX > handCard.count){
            let card = Card();
            card.handCard = true;
            handCard.append(card);
            addChild(card);
        }
        setHandCard();
    }
    /**
     カードを場に出す。
    */
    func playCard(){
        var i = 0;
        while(i<handCard.count){
            let card = handCard[i];
            if(card.selectCard){
                //場に出す
                setField(card);
                //手札から削除する。
                handCard.removeAtIndex(i);
                i=0;
            }else{
                i++;
            }
        }
        setHandCard();
    }
    /**
     
    */
    func deleteCard(){
//        print("deleteCard count:\(fieldCard.count)");
        //原点に移動する。
        let deletePoint = SKAction.moveTo(CGPoint.zero, duration: 0.3);
        let fieldCardCount:Int = fieldCard.count;
        for(var i=0;i<fieldCardCount;i++){
            let card:Card = fieldCard.removeFirst();
            card.runAction(deletePoint, completion: {
                //移動が完了したら自分自身を削除する。
                card.removeFromParent();
            })
        }
    }
    private func getHandCardPosition(radian:Double) -> CGPoint{
        let xPoint = handCardBasePosition.x - CGFloat(150 * sin(radian));
        let yPoint = handCardBasePosition.y + CGFloat(150 * cos(radian) - 0);
        let point:CGPoint = CGPoint(x:xPoint,y:yPoint);
        return point
    }
    /**
     手札をセットする。
    */
    private func setHandCard(){
        //手札の数
        let handCardCount:Int = handCard.count;
        //カードの角度
        var cardRotation:Double = 0;
        
        //手札のポジション決定
        for(var i=0;i<handCardCount;i++){
            //手札が奇数で真ん中は角度をつけない
            if(handCardCount % 2 == 1 && i == handCardCount/2){
                cardRotation = 0;
            }else if(i < handCardCount/2){
                //前半
                cardRotation = GameScene.HAND_CARD_ROTATION * Double(Int(handCardCount/2) - i);
                
            }else{
                //後半
                cardRotation = GameScene.HAND_CARD_ROTATION *
                    Double(Int((handCardCount-1)/2) - i);
            }
            //            print("count:\(handCardCount) i:\(i) cardRotation:\(cardRotation)");
            handCard[i].position = getHandCardPosition(cardRotation);
            handCard[i].handCardPosition = CGFloat(i);
            handCard[i].zPosition = CGFloat(i);
            handCard[i].zRotation = CGFloat(cardRotation);
        }

    }
    /**
     場に配置する。
    */
    private func setField(card:Card){
        card.position = CGPoint(x:CGRectGetMidX(self.frame) + CGFloat(fieldCard.count * 10),y:CGRectGetMidY(self.frame));
        card.handCard = false;
        card.setScale(1.0);
        card.zRotation = CGFloat(0.0);
        fieldCard.append(card);

    }
    /**
     背景付きのテキストラベルを生成する。
     */
    private func createItemNode(text:String) -> SKSpriteNode{
        let labelNode:SKLabelNode = SKLabelNode(fontNamed:"Chalkduster");
        labelNode.text = text;
        labelNode.fontSize = 15;
        labelNode.horizontalAlignmentMode = .Center;
        labelNode.verticalAlignmentMode = .Center;
        
        let spriteNode:SKSpriteNode = SKSpriteNode();
        spriteNode.size = CGSize(width: labelNode.frame.width+3,height: labelNode.frame.height+3);
        spriteNode.color = UIColor.greenColor();
        
        spriteNode.addChild(labelNode);
        return spriteNode;
    }
}