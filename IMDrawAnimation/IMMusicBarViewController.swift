//
//  IMMusicBarViewController.swift
//  IMDrawAnimation
//
//  Created by imwallet on 16/12/13.
//  Copyright © 2016年 imWallet. All rights reserved.
//

import UIKit

class IMMusicBarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        title = "音乐"
        
        startAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension IMMusicBarViewController{
    
    fileprivate func startAnimation() {
        let layer = CAReplicatorLayer()
        layer.frame = CGRect(x: 0, y: 200, width: screenW, height: 300)
        layer.backgroundColor = UIColor.yellow.cgColor
        view.layer.addSublayer(layer)
        
        let barLayer = CALayer()
        barLayer.backgroundColor = UIColor.red.cgColor
        barLayer.bounds = CGRect(x: 0, y: 0, width: 30, height: 100)
        barLayer.position = CGPoint(x: 30, y: 200)
        barLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
        layer.addSublayer(barLayer)
        
        let animation = CABasicAnimation()
        animation.keyPath = "transform.scale.y"
        animation.duration = 0.6
        animation.toValue = 0.1
        animation.autoreverses = true
        animation.repeatCount = MAXFLOAT
        barLayer.add(animation, forKey: "transform.scale.y")
        
        layer.instanceColor = UIColor.purple.cgColor
        layer.instanceCount = NSInteger(screenW / 40)
        layer.instanceDelay = 0.3
        layer.instanceTransform = CATransform3DMakeTranslation(40, 0, 0)
    }
}
