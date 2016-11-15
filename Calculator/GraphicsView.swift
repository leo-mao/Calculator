
//  GraphicsView.swift
//  Calculator
//
//  Created by Yang Mao on 14.11.16.
//  Copyright © 2016 Yang Mao. All rights reserved.
//

import UIKit

class GraphicsView: UIView {

    var scale : CGFloat = 0.90
    
    var GraphicsCenter : CGPoint {
            return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    var GraphicsRadius : CGFloat {
        return CGFloat(min(bounds.size.width, bounds.size.height)) / 2
    }
//    var lengthOfaxisX : CGFloat {
//        return bounds.size.width
//    }
//    var lengthOfaxisY : CGFloat {
//        return bounds.size.height
//    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    private struct Ratios{
        static let AxisRadiusToAxisXRadius : CGFloat = 1.0
        static let AxisRadiusToAxisYRadius : CGFloat = 1.0
        
    }
    
    private enum Axis {
        case X
        case Y
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) ->  UIBezierPath{
        let path = UIBezierPath(arcCenter: midPoint ,
                                radius: radius,
                                startAngle: 0.0,
                                endAngle: CGFloat(2*M_PI),
                                clockwise: false)
        path.lineWidth = 5
        return path
    }
    
    private func pathForAxis(axis : Axis) -> UIBezierPath{
        var xOfAxis,yOfAxis,widthOfAxis,heightOfAxis : CGFloat
        switch axis{
        case .X: xOfAxis = getAxisCenter(axis: .X).x - getAxisRadius(axis: Axis.X);
        yOfAxis = getAxisCenter(axis: .X).y;
        widthOfAxis = getAxisRadius(axis: .X) * 2;
        heightOfAxis = 0.5
        case .Y: xOfAxis = getAxisCenter(axis: .Y).x;
        yOfAxis = getAxisCenter(axis: .Y).y - getAxisRadius(axis: .Y);
        widthOfAxis = 0.5;
        heightOfAxis = getAxisRadius(axis: .Y) * 2
        }
        let axisRech = CGRect(x: xOfAxis, y: yOfAxis, width: widthOfAxis, height: heightOfAxis)// x,y here mean the beginning point
        
        let path = UIBezierPath(rect: axisRech)
        path.lineWidth = 0.5
        return path
    }
 
    private func getAxisCenter(axis : Axis) -> CGPoint{
        let axisCenter = GraphicsCenter // TODO offset for axises to GraphicsCenter
        return axisCenter
    }
    
    private func getAxisRadius(axis : Axis) -> CGFloat{
        var axisRadius = GraphicsRadius
        switch axis{
        case .X : axisRadius /= Ratios.AxisRadiusToAxisXRadius
        case .Y : axisRadius /= Ratios.AxisRadiusToAxisYRadius
        }
        return axisRadius
    }
    
    private func pathForCircle(axis : Axis) -> UIBezierPath{
        let axisRadius = getAxisRadius(axis: axis)
        let axisCenter = getAxisCenter(axis: axis) // why do I need a label 'axis:' here???
        return pathForCircleCenteredAtPoint(midPoint: axisCenter, withRadius: axisRadius)
    }
 
    override func draw(_ rect: CGRect) {
        UIColor.blue.set()
//        pathForCircleCenteredAtPoint(midPoint: axisCenter, withRadius: axisRadius).stroke()//general painting method
//        pathForCircle(axis: .X).stroke()
        
        
//        let arrowXRech = CGRect(x: getAxisCenter(axis: Axis.X).x - getAxisRadius(axis: Axis.X), y: getAxisCenter(axis: Axis.X).y, width: getAxisRadius(axis: Axis.X) * 2, height: 1)// x,y here mean the beginning point
        let arrowYRech = CGRect(x: getAxisCenter(axis: .Y).x - 4, y: getAxisCenter(axis: .Y).y - getAxisRadius(axis: .Y), width: 4 * 2, height: 8)// x,y here mean the beginning point
        UIBezierPath(rect: arrowYRech).stroke()
        pathForAxis(axis: .X).stroke()
        pathForAxis(axis: .Y).stroke()
    }
 
 
}
