//
//  IMWaterPulseView.swift
//  IMDrawAnimation
//
//  Created by imwallet on 16/12/13.
//  Copyright © 2016年 imWallet. All rights reserved.
//

import UIKit

class IMWaterPulseView: UIView {

    override func draw(_ rect: CGRect) {
        
        let rabius = rect.size.width * 0.5
        let centerPoint = CGPoint(x: rect.size.width * 0.5, y: rect.size.height * 0.5)
        
        let startAngle = 0
        let endAngle = CGFloat.pi * 2
        
        let path = UIBezierPath(arcCenter: centerPoint, radius: rabius, startAngle: CGFloat(startAngle), endAngle: endAngle, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.orange.cgColor
        self.layer.addSublayer(shapeLayer)
        
    }
}

