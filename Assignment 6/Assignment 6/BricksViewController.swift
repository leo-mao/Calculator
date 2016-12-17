//
//  BricksViewController.swift
//  Assignment 6
//
//  Created by Yang Mao on 11.12.16.
//  Copyright © 2016 Yang Mao. All rights reserved.
//

import UIKit

class BricksViewController: UIViewController {
    @IBOutlet weak var gameView: BricksView! {
        didSet{
            
            //gameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addBrick(recognizer:))))
            gameView.addGestureRecognizer(UIPanGestureRecognizer(target: gameView, action: #selector(BricksView.grabPanel(recognizer:))))
        }
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameView.animating = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startGame()
    }
    func startGame(){
        let number = 16
        for sequence in 0...number-1{
            gameView.addBrick(sequence: sequence)
        }
        gameView.addPanel()
        gameView.addBall()
        
    }

}
