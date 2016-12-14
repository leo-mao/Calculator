
//  GraphicsView.swift
//  Calculator
//
//  Created by Yang Mao on 14.11.16.
//  Copyright © 2016 Yang Mao. All rights reserved.
//

import UIKit

protocol DataSource {
    func calculateValueOfY(x: CGFloat) -> CGFloat?
}

@IBDesignable

class GraphicsView: UIView {
    @IBInspectable
    var scale : CGFloat = 0.90 { didSet{ setNeedsDisplay() }   }
    @IBInspectable
    var lineWidth : CGFloat = 0.5 { didSet{ setNeedsDisplay() }   }// to set lineWith here
    @IBInspectable
    var axisColor : UIColor = UIColor.blue  { didSet{ setNeedsDisplay() }   }
    @IBInspectable
    var pointPerUnit = 100 { didSet{ setNeedsDisplay() }   }
    @IBInspectable
    var maxValueForRadius = 25 { didSet{ setNeedsDisplay() }   }
    
    @IBInspectable
    var color = UIColor.black {didSet{ setNeedsDisplay()} }
    
    private var axisCenter : CGPoint!{ didSet{ setNeedsDisplay() }   }//这样就使axisCenter变成optinal了,一定要加did set不然不会自动重绘
    
    func changeScale(recognizer: UIPinchGestureRecognizer){
        switch recognizer.state {
        case .changed,.ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    func pan(recognizer: UIPanGestureRecognizer){
        switch recognizer.state {
        case .changed,.ended:
            let translation = recognizer.translation(in: self)
            axisCenter.x += translation.x
            axisCenter.y += translation.y
        default:
            break
        }
        recognizer.setTranslation(CGPoint.zero, in: self)
    }
    func doubleTap(recognizer: UITapGestureRecognizer){
        if recognizer.state == .ended {
            axisCenter = recognizer.location(in: self)
        }
    }
    
    
    var GraphicsCenter : CGPoint {
            return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    
    var GraphicsRadius : CGFloat {// eqauls viewRadius
        return CGFloat(min(bounds.size.width, bounds.size.height)) / 2 * scale
    }
    
    
    
    private struct Ratios{
        static let GraphicsRadiusToAxisXRadius : CGFloat = 1.0
        static let GraphicsRadiusToAxisYRadius : CGFloat = 0.5
        static let GraphicsRadiusToArrowLineOffset : CGFloat = 50.0 // how large should the axis arrow should look like
        static let GraphicsRadiusToLengthOfScales : CGFloat = 75.0 // how the length of the scale bars

    }
    
    private enum Axis {
        case X
        case Y
    }
    private enum ArrowLine{
        case slash
        case backSlash
    }
    
    private func pathForAxis(axis : Axis) {
        var start, end : CGPoint
        switch axis{
        case .X: start = CGPoint(x : getAxisCenter().x - getAxisRadius(axis: axis), y : getAxisCenter().y )
                 end = CGPoint(x: getAxisCenter().x + getAxisRadius(axis: axis), y : getAxisCenter().y )

        case .Y: start = CGPoint(x : getAxisCenter().x , y: getAxisCenter().y - getAxisRadius(axis: axis))
                 end = CGPoint(x: getAxisCenter().x , y : getAxisCenter().y + getAxisRadius(axis: axis))

        }
        
        drawPath(start: start, end: end)
    }
 
    private func pathForArrowLine(arrowLine : ArrowLine, axis: Axis) {
        var start, end: CGPoint
        switch axis{
        case .X:
            end = CGPoint(x: getAxisCenter().x + getAxisRadius(axis: axis) ,
                          y: getAxisCenter().y);
            switch arrowLine{
            case .backSlash :
                start = CGPoint(x: getAxisCenter().x + getAxisRadius(axis: axis) - getAxisRadius(axis: axis) / Ratios.GraphicsRadiusToArrowLineOffset ,
                            y: getAxisCenter().y - getAxisRadius(axis: axis) / Ratios.GraphicsRadiusToArrowLineOffset);
            case .slash :
                start = CGPoint(x: getAxisCenter().x + getAxisRadius(axis: axis) - getAxisRadius(axis: axis) / Ratios.GraphicsRadiusToArrowLineOffset ,
                            y: getAxisCenter().y + getAxisRadius(axis: axis) / Ratios.GraphicsRadiusToArrowLineOffset);
            }
        case .Y:
            end = CGPoint(x: getAxisCenter().x ,
                          y: getAxisCenter().y - getAxisRadius(axis: axis));
            switch arrowLine{
            case .backSlash :
                start = CGPoint(x: getAxisCenter().x +  getAxisRadius(axis: axis) / Ratios.GraphicsRadiusToArrowLineOffset ,
                                y: getAxisCenter().y - getAxisRadius(axis: axis) + getAxisRadius(axis: axis) / Ratios.GraphicsRadiusToArrowLineOffset);
            case .slash :
                start = CGPoint(x: getAxisCenter().x - getAxisRadius(axis: axis) / Ratios.GraphicsRadiusToArrowLineOffset ,
                                y: getAxisCenter().y - getAxisRadius(axis: axis) + getAxisRadius(axis: axis) / Ratios.GraphicsRadiusToArrowLineOffset);
            }
        }
        return drawPath(start: start, end: end)
    }
    private func pathForScale(axis: Axis){
        var start, end: CGPoint
        switch axis{
        case .X : for i in -4...4 {
            start = CGPoint(x: getAxisRadius(axis: axis) / 5 * CGFloat(i) + getAxisCenter().x, y: getAxisCenter().y - getAxisRadius(axis: axis) / Ratios.GraphicsRadiusToLengthOfScales)
            end = CGPoint(x: getAxisRadius(axis: axis) / 5 * CGFloat(i) + getAxisCenter().x, y: getAxisCenter().y + getAxisRadius(axis: axis) / Ratios.GraphicsRadiusToLengthOfScales)
            drawPath(start: start, end: end)
            }
        case .Y : for i in -8...8 {
            start = CGPoint(x: getAxisCenter().x - getAxisRadius(axis: axis) / Ratios.GraphicsRadiusToLengthOfScales, y: getAxisRadius(axis: axis) / 10 * CGFloat(i) + getAxisCenter().y)
            end = CGPoint(x: getAxisCenter().x + getAxisRadius(axis: axis) / Ratios.GraphicsRadiusToLengthOfScales, y: getAxisRadius(axis: axis) / 10 * CGFloat(i) + getAxisCenter().y)
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
    
    
    private func getAxisCenter() -> CGPoint{
        
        return axisCenter
    }
    
    private func getAxisRadius(axis : Axis) -> CGFloat{
        var axisRadius = GraphicsRadius
        switch axis{
        case .X : axisRadius /= Ratios.GraphicsRadiusToAxisXRadius
        case .Y : axisRadius /= Ratios.GraphicsRadiusToAxisYRadius
        }
        return axisRadius
    }
    

    var dataSource : DataSource?
    
    private func drawFuncGraphics()-> UIBezierPath{ //画图什么的还是要直接在view里面完成，controller好像不行
        let path = UIBezierPath()
        let data = dataSource
        var firstPoint = true
        var lastY :CGFloat = 0
        for i in -maxValueForRadius...maxValueForRadius-1{
            for j in 0...pointPerUnit-1{
                let currentX = Double(i) + Double(j) / Double(pointPerUnit)
                
                if let currentY = data?.calculateValueOfY(x: CGFloat(currentX)) {
                    
                    let currentPoint = CGPoint(
                        x: getAxisCenter().x +
                        CGFloat(currentX / Double(maxValueForRadius) *
                        Double (GraphicsRadius)),
                        y: getAxisCenter().y - currentY /
                        CGFloat( Double(maxValueForRadius)) *
                        CGFloat(GraphicsRadius))
                    
                    if (!currentY.isNormal) {
                        continue
                    } else
                    if ((lastY) * (currentY) < 0)
                    {
                        path.move(to: CGPoint(x:getAxisCenter().x +
                            CGFloat(currentX / Double(maxValueForRadius) *
                                Double (GraphicsRadius)),y:getAxisCenter().y - currentY /
                                    CGFloat( Double(maxValueForRadius)) *
                                    CGFloat(GraphicsRadius)))
                    }
                    lastY = currentY
                    if (firstPoint) {
                    path.move(to: currentPoint)
                }
                    else {
                        path.addLine(to: currentPoint)
                    }
                firstPoint = false
            }
            
            }
        }
    
        return path//不能一个点一个点的画，必须要画线断否则会画不出切记切记
    }
    
    override func draw(_ rect: CGRect) {
        axisCenter = axisCenter ?? GraphicsCenter //这里必须要Optional
        
       drawAxis()// 也要更新，用几个参数来重画一下
       drawFuncGraphics().stroke()
        
    }
 
 
}
