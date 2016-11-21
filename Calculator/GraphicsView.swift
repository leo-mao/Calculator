
//  GraphicsView.swift
//  Calculator
//
//  Created by Yang Mao on 14.11.16.
//  Copyright © 2016 Yang Mao. All rights reserved.
//

import UIKit

@IBDesignable

class GraphicsView: UIView {
    @IBInspectable
    var scale : CGFloat = 0.90 { didSet{ setNeedsDisplay() }   }
    @IBInspectable
    var lineWidth : CGFloat = 0.5 { didSet{ setNeedsDisplay() }   }// to set lineWith here
    @IBInspectable
    var axisColor : UIColor = UIColor.blue  { didSet{ setNeedsDisplay() }   }
    @IBInspectable
    var pointPerRadius = 100 { didSet{ setNeedsDisplay() }   }
    @IBInspectable
    var maxValueForRadius = 25 { didSet{ setNeedsDisplay() }   }
    
    func changeScale(recognizer: UIPinchGestureRecognizer){
        switch recognizer.state {
        case .changed,.ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    
    
    var GraphicsCenter : CGPoint {
            return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    var GraphicsRadius : CGFloat {// eqauls viewRadius
        return CGFloat(min(bounds.size.width, bounds.size.height)) / 2 * scale
    }
    
    
    
    private struct Ratios{
        static let AxisRadiusToAxisXRadius : CGFloat = 1.0
        static let AxisRadiusToAxisYRadius : CGFloat = 1.0
        static let AxisRadiusToArrowLineOffset : CGFloat = 50.0 // how large should the axis arrow should look like
        static let AxisRadiusToLengthOfScales : CGFloat = 75.0 // how the length of the scale bars
    }
    
    private enum Axis {
        case X
        case Y
    }
    private enum ArrowLine{
        case slash
        case backSlash
    }
    /*private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) ->  UIBezierPath{
        let path = UIBezierPath(arcCenter: midPoint ,
                                radius: radius,
                                startAngle: 0.0,
                                endAngle: CGFloat(2*M_PI),
                                clockwise: false)
        path.lineWidth = 5
        return path
    }*/
    
    private func pathForAxis(axis : Axis) {
        var start, end : CGPoint
        switch axis{
        case .X: start = CGPoint(x : getAxisCenter(axis: axis).x - getAxisRadius(axis: axis), y : getAxisCenter(axis: axis).y )
                 end = CGPoint(x: getAxisCenter(axis: axis).x + getAxisRadius(axis: axis), y : getAxisCenter(axis: axis).y )

        case .Y: start = CGPoint(x : getAxisCenter(axis: axis).x , y: getAxisCenter(axis: axis).y - getAxisRadius(axis: axis))
                 end = CGPoint(x: getAxisCenter(axis: axis).x , y : getAxisCenter(axis: axis).y + getAxisRadius(axis: axis))

        }
        
        drawPath(start: start, end: end)
    }
 
    private func pathForArrowLine(arrowLine : ArrowLine, axis: Axis) {
        var start, end: CGPoint
        switch axis{
        case .X:
            end = CGPoint(x: getAxisCenter(axis: axis).x + getAxisRadius(axis: axis) ,
                          y: getAxisCenter(axis: axis).y);
            switch arrowLine{
            case .backSlash :
                start = CGPoint(x: getAxisCenter(axis: axis).x + getAxisRadius(axis: axis) - getAxisRadius(axis: axis) / Ratios.AxisRadiusToArrowLineOffset ,
                            y: getAxisCenter(axis: axis).y - getAxisRadius(axis: axis) / Ratios.AxisRadiusToArrowLineOffset);
            case .slash :
                start = CGPoint(x: getAxisCenter(axis: axis).x + getAxisRadius(axis: axis) - getAxisRadius(axis: axis) / Ratios.AxisRadiusToArrowLineOffset ,
                            y: getAxisCenter(axis: axis).y + getAxisRadius(axis: axis) / Ratios.AxisRadiusToArrowLineOffset);
            }
        case .Y:
            end = CGPoint(x: getAxisCenter(axis: axis).x ,
                          y: getAxisCenter(axis: axis).y - getAxisRadius(axis: axis));
            switch arrowLine{
            case .backSlash :
                start = CGPoint(x: getAxisCenter(axis: axis).x +  getAxisRadius(axis: axis) / Ratios.AxisRadiusToArrowLineOffset ,
                                y: getAxisCenter(axis: axis).y - getAxisRadius(axis: axis) + getAxisRadius(axis: axis) / Ratios.AxisRadiusToArrowLineOffset);
            case .slash :
                start = CGPoint(x: getAxisCenter(axis: axis).x - getAxisRadius(axis: axis) / Ratios.AxisRadiusToArrowLineOffset ,
                                y: getAxisCenter(axis: axis).y - getAxisRadius(axis: axis) + getAxisRadius(axis: axis) / Ratios.AxisRadiusToArrowLineOffset);
            }
        }
        return drawPath(start: start, end: end)
    }
    private func pathForScale(axis: Axis){
        var start, end: CGPoint
        switch axis{
        case .X : for i in -4...4 {
            start = CGPoint(x: getAxisRadius(axis: axis) / 5 * CGFloat(i) + getAxisCenter(axis: axis).x, y: getAxisCenter(axis: axis).y - getAxisRadius(axis: axis) / Ratios.AxisRadiusToLengthOfScales)
            end = CGPoint(x: getAxisRadius(axis: axis) / 5 * CGFloat(i) + getAxisCenter(axis: axis).x, y: getAxisCenter(axis: axis).y + getAxisRadius(axis: axis) / Ratios.AxisRadiusToLengthOfScales)
            drawPath(start: start, end: end)
            }
        case .Y : for i in -4...4 {
            start = CGPoint(x: getAxisCenter(axis: axis).x - getAxisRadius(axis: axis) / Ratios.AxisRadiusToLengthOfScales, y: getAxisRadius(axis: axis) / 5 * CGFloat(i) + getAxisCenter(axis: axis).y)
            end = CGPoint(x: getAxisCenter(axis: axis).x + getAxisRadius(axis: axis) / Ratios.AxisRadiusToLengthOfScales, y: getAxisRadius(axis: axis) / 5 * CGFloat(i) + getAxisCenter(axis: axis).y)
            drawPath(start: start, end: end)
            }
        }
    }
    
    func drawPath(start: CGPoint, end: CGPoint){
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        path.lineWidth = lineWidth
        path.stroke()
        setNeedsDisplay()
    }
    private func drawAxis(){
        axisColor.set()
        pathForAxis(axis: .X)
        pathForAxis(axis: .Y)
        pathForArrowLine(arrowLine: .backSlash, axis: .X)
        pathForArrowLine(arrowLine: .slash, axis: .X)
        pathForArrowLine(arrowLine: .backSlash, axis: .Y)
        pathForArrowLine(arrowLine: .slash, axis: .Y)
        pathForScale(axis: .X)
        pathForScale(axis: .Y)
        
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
    
//    private func pathForCircle(axis : Axis) -> UIBezierPath{
//        let axisRadius = getAxisRadius(axis: axis)
//        let axisCenter = getAxisCenter(axis: axis) // why do I need a label 'axis:' here???
//        return pathForCircleCenteredAtPoint(midPoint: axisCenter, withRadius: axisRadius)
//    }
// 
    
    
    override func draw(_ rect: CGRect) {
        
        //let axesDrawer: AxesDrawer = AxesDrawer();
        //axesDrawer.drawAxesInRect(bounds: bounds, origin: GraphicsCenter, pointsPerUnit: 10)
        
        drawAxis()
        //drawFunc()
//        pathForCircle(axis: .X).stroke()
        
//        let arrowXRech = CGRect(x: getAxisCenter(axis: Axis.X).x - getAxisRadius(axis: Axis.X), y: getAxisCenter(axis: Axis.X).y, width: getAxisRadius(axis: Axis.X) * 2, height: 1)// x,y here mean the beginning point
//        let arrowYRech = CGRect(x: getAxisCenter(axis: .Y).x - 4, y: getAxisCenter(axis: .Y).y - getAxisRadius(axis: .Y), width: 4 * 2, height: 8)// x,y here mean the beginning point
//        UIBezierPath(rect: arrowYRech).stroke()
        
        
    }
 
 
}
