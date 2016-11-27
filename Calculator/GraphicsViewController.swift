//
//  GraphicsViewController.swift
//  Calculator
//
//  Created by Yang Mao on 14.11.16.
//  Copyright © 2016 Yang Mao. All rights reserved.
//

import UIKit

class GraphicsViewController: UIViewController, DataSource {


    
    private let brain = CalculatorBrain() //妈哒， 扫清路障。 原因是 题目被我理解的复杂化，没那么难。私有brain是可以有的，因为直接创建一个brain 类就好了，然后只要把那个计算机中形成的program通过segue传过来就好了，操你们妈不早说
    
    
    @IBOutlet weak var graphicsView: GraphicsView!{
        
        didSet{
            graphicsView.dataSource = self // 用接口 不然graphicsView 无法从ViewContoller获得信息
            
            graphicsView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphicsView, action: #selector(graphicsView.changeScale(recognizer:)))) // an underbar here doesn't work
            
            graphicsView.addGestureRecognizer(UIPanGestureRecognizer(target: graphicsView, action:
                #selector(graphicsView.pan(recognizer:))))
            
            let recognizer = UITapGestureRecognizer(target: graphicsView, action:
                #selector(graphicsView.doubleTap(recognizer:)))
            
            recognizer.numberOfTapsRequired = 2
            
            graphicsView.addGestureRecognizer(recognizer)
            
            updateUI()
        }
        
    }

    
    func calculateValueOfY(x: CGFloat)->CGFloat?{
        brain.variableValues["M"] = Double(x)
        brain.updateByInternalProgram()
        return CGFloat(brain.result)
    }
    
    
    var program: AnyObject?{//加个问号就能解决初始化为nil的问题了,告诉编译器这是可有可无的
        didSet{
            brain.program = program!
        }
        
    }
    private func updateUI(){
        graphicsView?.setNeedsDisplay()
    }

}
