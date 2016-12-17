//
//  BallLikeBehavior.swift
//  Assignment 6
//
//  Created by Yang Mao on 17.12.16.
//  Copyright © 2016 Yang Mao. All rights reserved.
//

import UIKit

class PanelLikeBehavior: UIDynamicBehavior {
    private let collider: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        return collider
    }()
    private let itemBehavior: UIDynamicItemBehavior = {
        let dib = UIDynamicItemBehavior()
        dib.allowsRotation = false
        dib.elasticity = 1
        return dib
    }()
//    func addBarrier(path:UIBezierPath, named name:String){
        //collider.removeBoundary(withIdentifier: name as NSCopying)
//        collider.addBoundary(withIdentifier: name as NSCopying, for: path)
//    }
    override init(){
        super.init()
        addChildBehavior(collider)
        addChildBehavior(itemBehavior)
    }
    func addItem(item: UIDynamicItem){
        collider.addItem(item)
    }
    func removeItem(item: UIDynamicItem){
        collider.removeItem(item)
    }

}
