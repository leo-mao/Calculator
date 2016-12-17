//
//  BallView.swift
//  Assignment 6
//
//  Created by Yang Mao on 17.12.16.
//  Copyright © 2016 Yang Mao. All rights reserved.
//

import UIKit

class BallView: UIView {
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType{
        return UIDynamicItemCollisionBoundsType.ellipse
    }
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        UIColor.brown.set()
        path.fill()
    }
    override init(frame: CGRect){
        super.init(frame:frame)
        backgroundColor = UIColor.white
    }
    // requried init? must be provided by subview
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
