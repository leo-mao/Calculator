//
//  GraphicsViewController.swift
//  Calculator
//
//  Created by Yang Mao on 14.11.16.
//  Copyright © 2016 Yang Mao. All rights reserved.
//

import UIKit

class GraphicsViewController: UIViewController {

    var program: AnyObject?{//加个问号就能解决初始化为nil的问题了,告诉编译器这是可有可无的
        didSet{
            brain.program = program!
        }
    
    }
    
    private let brain = CalculatorBrain() //妈哒， 扫清路障。 原因是 题目被我理解的复杂化，没那么难。私有brain是可以有的，因为直接创建一个brain 类就好了，然后只要把那个program通过segue传过来就好了，操你们妈不早说
    
    
    @IBOutlet weak var graphicsView: GraphicsView!{
        
        didSet{
            graphicsView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphicsView, action: #selector(graphicsView.changeScale(recognizer:)))) // an underbar here doesn't work
            updateUI()
        }
    }

    
    private func calculateValueOfY(x: Double)->CGFloat{
        brain.variableValues["M"] = x
        brain.updateByInternalProgram()
        return CGFloat(brain.result)
    }
    private func convertCoordinateSystem(x:CGFloat, y:CGFloat)->CGPoint{
        
        
        return CGPoint(x:x,y:y)
    
    }
    private func drawFunc(){
        var lastPoint : CGPoint? = nil
        var hasLastPoint = false
        for i in -25...25{
            for j in 0...100{
                let currentX = Double(i) + Double(j)/100.0
                let currentPoint = convertCoordinateSystem(x: CGFloat(currentX), y: calculateValueOfY(x: currentX))
                if (hasLastPoint) {
                    graphicsView.drawPath(start: lastPoint!, end: currentPoint).stroke()
                }
                lastPoint = currentPoint
                hasLastPoint = true
            }
            hasLastPoint = false
        }
        
    }
    private func updateUI(){
        
    }

}
