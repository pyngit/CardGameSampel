//
//  ViewController.swift
//  CardGameSampel
//
//  Created by pyn on 2016/04/19.
//  Copyright © 2016年 pyngit. All rights reserved.
//

import UIKit;
import SpriteKit;

class ViewController: UIViewController {
    var scene:GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = self.view as! SKView

        scene = GameScene(size: skView.bounds.size);
        
        skView.showsFPS = true
        skView.showsNodeCount = true
            
        scene.size = self.view.frame.size
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
            
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .ResizeFill
            
        skView.presentScene(scene)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
     カードを引く
    */
    @IBAction func drawCard(button:UIButton){
        scene.drawCard();
    }
    /**
     カードを場に出す
    */
    @IBAction func playCard(button:UIButton){
        scene.playCard();
    }
    /**
     カードを削除する。
    */
    @IBAction func deleteCard(button:UIButton){
        scene.deleteCard();
    }

}

