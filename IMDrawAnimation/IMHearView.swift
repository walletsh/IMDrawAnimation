//
//  IMHearView.swift
//  IMDrawAnimation
//
//  Created by imwallet on 17/1/3.
//  Copyright © 2017年 imWallet. All rights reserved.
//

import UIKit

class IMHearView: UIView {

    var strokeColor: UIColor?
    var fillColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        strokeColor = UIColor.red
        fillColor = UIColor.randomColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        fillColor?.setFill()
        strokeColor?.setStroke()
        
        let drawPadding: CGFloat = 4.0//边距
        // 画心形的弧度，floor()函数  向下取整
        let radius = floor((rect.size.width - drawPadding * 2.0) / 4.0)
        
        let heartPath = UIBezierPath()
        
        // 画心形起点，心形最底部
        let tipLocation = CGPoint(x: floor(rect.size.width / 2.0), y: floor(rect.size.height - drawPadding))
        heartPath.move(to: tipLocation)
        
        let topLeftCurveStart = CGPoint(x: drawPadding, y: floor(rect.size.height / 2.4))
        print("topLeftCurveStart x is \(topLeftCurveStart.x) y is \(topLeftCurveStart.y)")
        let controPoint = CGPoint(x: topLeftCurveStart.x, y: topLeftCurveStart.y + radius)
        
        // 画心形左下部曲线
        heartPath.addQuadCurve(to: topLeftCurveStart, controlPoint: controPoint)
        
        // 画左上半部心形
        heartPath.addArc(withCenter: CGPoint(x: topLeftCurveStart.x + radius, y: topLeftCurveStart.y), radius: radius, startAngle: CGFloat.pi, endAngle: 0, clockwise: true)
        
        let topRightCurveStart = CGPoint(x: topLeftCurveStart.x + radius * 2, y: topLeftCurveStart.y)
        
        //画右上本部心形
        heartPath.addArc(withCenter: CGPoint(x: topRightCurveStart.x + radius, y: topRightCurveStart.y), radius: radius, startAngle: CGFloat.pi, endAngle: 0, clockwise: true)

        let topRightCurveEnd = CGPoint(x: topLeftCurveStart.x + 4 * radius, y: topRightCurveStart.y)

        // 画心形右下曲线
        heartPath.addQuadCurve(to: tipLocation, controlPoint: CGPoint(x: topRightCurveEnd.x, y: topRightCurveEnd.y + radius))
        
        heartPath.fill()
        
        heartPath.lineWidth = 1.0
        heartPath.lineCapStyle = .square
        heartPath.lineJoinStyle = .bevel
        heartPath.stroke()
    }

}

extension IMHearView{
    func startAnimation(_ view: UIView) {
        // 动画总时长
        let totalDuration: TimeInterval = 20
        
        let heartW = self.bounds.size.width
        let heartH = self.bounds.size.height
        
        let heartCenterX = self.center.x
        
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.alpha = 0
        
        // 刚出现时缩放
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: { 
            self.transform = CGAffineTransform.identity
            self.alpha = 0.6
        }, completion: nil)
        
        
        let i = CGFloat(arc4random_uniform(2))
        let rotationDirection = 1 - (2 * i)// 1或-1 view漂移方向
        let rotationFraction = CGFloat(arc4random_uniform(10))
        
        // 刚出现时旋转
        UIView.animate(withDuration: totalDuration) {
            self.transform = CGAffineTransform(rotationAngle: rotationDirection * CGFloat.pi / (16 + rotationFraction * 0.2))
        }
        
        // 漂移路径
        let heartTravelPath = UIBezierPath()
        heartTravelPath.move(to: self.center)
        
        let endPoint = CGPoint(x: heartCenterX + rotationDirection * CGFloat(arc4random_uniform(2 * UInt32(heartW))), y: heartH / 6.0 + CGFloat(arc4random_uniform(UInt32(heartH / 4))))
        
        let xDelta = heartW / 2 + CGFloat(arc4random_uniform(UInt32(heartW * 2))) * rotationDirection
        let yDelta = max(endPoint.y, max(CGFloat(arc4random_uniform(UInt32(heartW * 8))), heartW))
        let controlPoint1 = CGPoint(x: heartCenterX + xDelta, y: heartH - yDelta)
        let controlPoint2 = CGPoint(x: heartCenterX - 2 * xDelta, y: yDelta)
        
        heartTravelPath.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = heartTravelPath.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = totalDuration + TimeInterval(endPoint.y / heartH)
        self.layer.add(animation, forKey: "positionOnPath")
        
        UIView.animate(withDuration: totalDuration, animations: { 
            self.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
}

