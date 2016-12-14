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

        }
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameView.animating = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
