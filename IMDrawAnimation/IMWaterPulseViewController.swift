//
//  IMWaterPulseViewController.swift
//  IMDrawAnimation
//
//  Created by imwallet on 16/12/13.
//  Copyright © 2016年 imWallet. All rights reserved.
//

import UIKit

class IMWaterPulseViewController: UIViewController {
    
    var timer: Timer?
    var startBtn: UIButton!
    var startBtnTwo: UIButton!
    var pulseLayer: IMPulseAnimationLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        title = "水波纹"
        setupUI()
        setupUITwo()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension IMWaterPulseViewController{
    
    fileprivate func setupUI() {
        
        startBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 40))
        startBtn.center = CGPoint(x: screenW * 0.5, y: screenH * 0.5 * 0.5)
        startBtn.backgroundColor = UIColor.purple
        startBtn.setTitle("Start", for: .normal)
        startBtn.setTitle("Stop", for: .selected)
        startBtn.setTitleColor(UIColor.white, for: .normal)
        startBtn.addTarget(self, action: #selector(clickAnimation(_:)), for: .touchUpInside)
        view.addSubview(startBtn)
    }
    
    @objc fileprivate func clickAnimation(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            timer = Timer(timeInterval: 0.5, target: self, selector: #selector(waterAnimation(_:)), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .commonModes)
        }else{
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc fileprivate func waterAnimation(_ timer: Timer) {
        let waterView = IMWaterPulseView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        waterView.center = startBtn.center
        waterView.backgroundColor = UIColor.clear

        view.insertSubview(waterView, belowSubview: startBtn)
        
        UIView.animate(withDuration: 2, animations: {
            waterView.transform = waterView.transform.scaledBy(x: 2.5, y: 2.5)
            waterView.alpha = 0
        }) { (finished) in
            waterView.removeFromSuperview()
        }
    }
    
}

extension IMWaterPulseViewController{
    
    fileprivate func setupUITwo() {
        
        startBtnTwo = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 40))
        startBtnTwo.center = CGPoint(x: screenW * 0.5, y: screenH * 0.75)
        startBtnTwo.backgroundColor = UIColor.purple
        startBtnTwo.setTitle("Start", for: .normal)
        startBtnTwo.setTitle("Stop", for: .selected)
        startBtnTwo.setTitleColor(UIColor.white, for: .normal)
        startBtnTwo.addTarget(self, action: #selector(startClickAnimation(_:)), for: .touchUpInside)
        view.addSubview(startBtnTwo)
        
        pulseLayer = IMPulseAnimationLayer()
        pulseLayer.position = startBtnTwo.center
        pulseLayer.radius = 150
        pulseLayer.pulseCount = 10
        pulseLayer.animationDuration = 4
        view.layer.insertSublayer(pulseLayer, below: startBtnTwo.layer)
    }
    
    @objc fileprivate func startClickAnimation(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            pulseLayer.startPulseAnimation()
        }else{
            pulseLayer.stopPusleAnimation()
        }
    }
}


