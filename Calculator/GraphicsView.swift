//
//  GraphicsView.swift
//  Calculator
//
//  Created by Yang Mao on 14.11.16.
//  Copyright © 2016 Yang Mao. All rights reserved.
//

import UIKit

class GraphicsView: UIView {

    /*   var scale : CGFloat = 0.90
    let axisCenter = CGPoint{
            return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    var axisRadius = CGFloat{
        return CGFloat(min(bounds.size.width,bounds.size.height))
    }
    var lengthOfaxisX = CGFloat{
        return bounds.size.width
    }
    var lengthOfaxisY = CGFloat{
        return bounds.size.height
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    private struct Ratios{
        static let ExampleToAxisX = 1
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius:CGFoalt) ->  UIBezierPath{
        
    }
    
 */
    override func draw(_ rect: CGRect) {
        let axisRadius = min(bounds.size.width, bounds.size.height)/2
        let axisCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let skull = UIBezierPath(arcCenter: axisCenter, radius: axisRadius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: false)
        skull.lineWidth = 5
        UIColor.blue.set()
        skull.stroke()
        
        
      
    }
 
 
}
