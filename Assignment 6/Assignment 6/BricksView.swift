//
//  BricksView.swift
//  Assignment 6
//
//  Created by Yang Mao on 11.12.16.
//  Copyright © 2016 Yang Mao. All rights reserved.
//

import UIKit

class BricksView: UIView {
    
    let brickBehavior = BrickLikeBehavior()
    
    private lazy var animator : UIDynamicAnimator = UIDynamicAnimator(referenceView: self)
    

    
    var animating : Bool = false{
        didSet{
            if animating {
                animator.addBehavior(brickBehavior)
            } else {
                animator.removeBehavior(brickBehavior)
            }
        }
    }
    
    var attachment:UIAttachmentBehavior?{
        willSet{
            if attachment != nil{
                animator.removeBehavior(attachment!)
            }
    }
        didSet{
            if attachment != nil{
                animator.addBehavior(attachment!)
            }
        }
    }
    
    private let bricksPerRow  = 4
    
    private let groove :CGFloat = 4
    
    var brickSize : CGSize {
        get{
        let size = bounds.size.width / CGFloat(bricksPerRow) - groove
        return CGSize(width:  size , height: size / 2  )
        }
    }
    
    func addBrick(sequence: Int){
        var frame = CGRect(origin: CGPoint.zero, size: brickSize)
        frame.origin.x = groove / 2  + CGFloat(sequence % bricksPerRow) * (brickSize.width + groove)
        frame.origin.y = CGFloat(sequence / bricksPerRow) * (brickSize.height + groove) + brickSize.height
        let brick = UIView(frame: frame)
        brick.backgroundColor = UIColor.blue
        addSubview(brick)
        brickBehavior.addItem(item: brick)
//        brickBehavior.addIte
    }
    private var radius : CGFloat {
        get{
        return (bounds.size.width / CGFloat(bricksPerRow) - groove) / 2
        }
    }
    
    private var ballSize : CGSize{
        get{
            
            return CGSize(width: radius, height: radius)
        }
    }
    
    func addBall(){
        var frame = CGRect(origin: CGPoint.zero, size: ballSize)
        frame.origin.x = CGFloat(Double(bounds.maxX) - Double(radius)) / 2
        frame.origin.y = CGFloat(Double(bounds.maxY) -  Double(radius)) - groove * 2
        let oval = UIBezierPath(ovalIn: frame)
        let ovalColor = UIColor.brown
        
        ovalColor.set()
        
        oval.fill()
        oval.stroke()
        
    }
    private var thickness : CGFloat{
        get{
            return 2 * groove
        }
    }
    private var widthForBoard:CGFloat{
        get{
            return brickSize.width
        }
    }
    private var boardSize :CGSize{
        get{
            return CGSize(width: widthForBoard, height: thickness)
        }
    }
    func addBoard(){
        var frame = CGRect(origin: CGPoint.zero, size: boardSize)
        frame.origin.x = CGFloat(Double(bounds.maxX) - Double(widthForBoard)) / 2
        frame.origin.y = CGFloat(Double(bounds.maxY) -  Double(radius))
        let board = UIView(frame:frame)
        board.backgroundColor = UIColor.cyan
        addSubview(board)
        
    }
    
    override func draw(_ rect: CGRect) {
        let number = 16
        for sequence in 0...number-1{
        addBrick(sequence: sequence)
        addBoard()
        addBall()
        }
    }

}
