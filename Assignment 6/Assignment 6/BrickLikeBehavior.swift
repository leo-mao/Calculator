//
//  BrickLikeBehavior.swift
//  Assignment 6
//
//  Created by Yang Mao on 11.12.16.
//  Copyright © 2016 Yang Mao. All rights reserved.
//

import UIKit

class BrickLikeBehavior: UIDynamicBehavior {
    private let collider: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        return collider
    }()
    private let itemBehavior: UIDynamicItemBehavior = {
        let dib = UIDynamicItemBehavior()
        dib.allowsRotation = false
        dib.elasticity = 0
        return dib
    }()
//    private let b
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
