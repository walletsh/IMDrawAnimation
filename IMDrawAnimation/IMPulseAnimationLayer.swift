//
//  IMPulseAnimationLayer.swift
//  IMDrawAnimation
//
//  Created by imwallet on 16/12/13.
//  Copyright © 2016年 imWallet. All rights reserved.
//

import UIKit
import Foundation

class IMPulseAnimationLayer: CAReplicatorLayer {
    
    var containerLayer: CALayer!
    var animationGroup: CAAnimationGroup!
    
    var animationDuration: TimeInterval = 3.0{
        didSet{
            self.instanceDelay = (animationDuration + pulseInterval) / pulseCount
        }
    }
    
    var pulseInterval: TimeInterval = 1.0{
        didSet{
            if pulseInterval == TimeInterval(MAXFLOAT) {
                containerLayer.removeAnimation(forKey: "pulse")
            }
        }
    }
    
    var pulseCount: TimeInterval = 1.0{
        didSet{
            self.instanceCount = Int(pulseCount)
            self.instanceDelay = (animationDuration + pulseInterval) / pulseCount
        }
    }
    
    var startInterval: TimeInterval = 1{
        didSet{
            self.instanceDelay = startInterval
        }
    }
    
    var scaleValue: CGFloat = 0.0
    
    var isTimingFunction: Bool = true
    
    var radius: CGFloat = 60 {
        didSet{
            containerLayer.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
            containerLayer.cornerRadius = radius
        }
    }
    
    override var frame: CGRect{
        didSet{
            containerLayer.frame = frame
        }
    }
    
    override var backgroundColor: CGColor? {
        didSet{
            containerLayer.backgroundColor = backgroundColor
        }
    }
    
    override var repeatCount: Float{
        didSet{
            animationGroup.repeatCount = repeatCount
        }
    }
    
    override init() {
        super.init()
        
        initializeLayer()
        initializeDefault()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension IMPulseAnimationLayer{
    
    fileprivate func initializeLayer() {
        
        containerLayer = CALayer()
        containerLayer.contentsScale = UIScreen.main.scale
        containerLayer.opacity = 0
        self.addSublayer(containerLayer)
        
        animationGroup = CAAnimationGroup()
    }
    
    fileprivate func initializeDefault() {
        radius = 60
        pulseCount = 5
        self.repeatCount = HUGE
        self.backgroundColor = UIColor.orange.cgColor
    }
}

extension IMPulseAnimationLayer{

    func startPulseAnimation() {
        
        animationGroup.duration = animationDuration + pulseInterval
        animationGroup.repeatCount = repeatCount
        
        if isTimingFunction {
            let defaultFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
            animationGroup.timingFunction = defaultFunction
        }
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = scaleValue
        scaleAnimation.toValue = 1.0
        scaleAnimation.duration = animationDuration
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        let colorAlpha = backgroundColor!.alpha
        opacityAnimation.values = [colorAlpha, colorAlpha * 0.5, 0]
        opacityAnimation.keyTimes = [0, 0.5, 1]
        
        animationGroup.isRemovedOnCompletion = true
        animationGroup.fillMode = kCAFillModeForwards
        animationGroup.animations = [scaleAnimation , opacityAnimation]
        containerLayer.add(animationGroup, forKey: "pulse")
    }
    
    func stopPusleAnimation() {

        containerLayer.removeAnimation(forKey: "pulse")
        
    }
}








