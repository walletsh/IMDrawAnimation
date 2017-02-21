//
//  IMHeardAnimationViewController.swift
//  IMDrawAnimation
//
//  Created by imwallet on 17/1/3.
//  Copyright © 2017年 imWallet. All rights reserved.
//

import UIKit

let heartWH = 60

class IMHeardAnimationViewController: UIViewController {
    
    fileprivate var timer: Timer?
        
    fileprivate lazy var emitterLayer: CAEmitterLayer = {
        let emitter = CAEmitterLayer()
        // 发射位置
        emitter.emitterPosition = CGPoint(x: screenW * 0.25, y: screenH * 0.9)
        // 发射源的尺寸大小
        emitter.emitterSize = CGSize(width: 20, height: 20)
        // 发射模式
        emitter.emitterMode = kCAEmitterLayerPoints
        // 发射源的形状
        emitter.emitterShape = kCAEmitterLayerPoint
        // 渲染模式
        emitter.renderMode = kCAEmitterLayerUnordered
        // 三维模式
//        emitter.preservesDepth = true
//        // 粒子产生系数
//        emitter.birthRate = 1.0
//        // 决定粒子形状的深度
//        emitter.emitterDepth = 1.0
//        // 粒子的生命周期
//        emitter.lifetime = 1.0
//        // 粒子的缩放大小
//        emitter.scale = 1.0
//        // 用于初始化随机数产生的种子
//        emitter.speed = 1.0
//        // 自旋转速度
//        emitter.spin = 1.0
//        // 粒子速度
//        emitter.velocity = 1.0
        
        var cells = Array<CAEmitterCell>()
        for i in 0..<10 {
            let cell = CAEmitterCell()
            cell.birthRate = 1.0 // 粒子的创建速率，默认为1/s
            cell.lifetime = Float(arc4random_uniform(4)) + 1.0 // 粒子存活时间
            cell.lifetimeRange = 1.5 // 粒子的生存时间容差
//            cell.color = UIColor.randomColor().cgColor
            
            let image = UIImage(named: "good\(i)_30x30_")
            cell.contents = image?.cgImage // 粒子显示的内容
            
            cell.velocity = CGFloat(arc4random_uniform(100)) + 20.0 // 粒子的运动速度
            cell.velocityRange = 80 // 粒子速度的容差
            cell.emissionLongitude = CGFloat.pi + CGFloat.pi * 0.5 // 粒子在xy平面的发射角度
            cell.emissionRange = CGFloat.pi * 0.5 / 6.0 // 粒子发射角度的容差
            cell.scale = 0.3 // 缩放比例
            cells.append(cell)
        }
        emitter.emitterCells = cells
        
        return emitter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.lightGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        view.addGestureRecognizer(tap)
        
        let long = UILongPressGestureRecognizer(target: self, action: #selector(longAction(_:)))
        long.minimumPressDuration = 0.2
        view.addGestureRecognizer(long)
        // Do any additional setup after loading the view.
        
        
        let delayButton = IMDelayButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        delayButton.center = view.center
        delayButton.addTarget(self, action: #selector(delayButtonCilick(_:)), for: .touchUpInside)
        delayButton.setTitle("重复点击", for: .normal)
        delayButton.backgroundColor = UIColor.randomColor()
        delayButton.delayDuration = 2.0
        view.addSubview(delayButton)
        
        
        view.layer.addSublayer(emitterLayer)
        emitterLayer.isHidden = false
        
    }
    
    @objc fileprivate func delayButtonCilick(_ sender: IMDelayButton) {
        print("sender cilick time is \(sender.delayDuration)")
        sender.backgroundColor = UIColor.randomColor()
//        emitterLayer.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension IMHeardAnimationViewController{
    
    @objc fileprivate func tapAction(_ tap: UITapGestureRecognizer) {
        showHeartAnimation()
    }
    
    @objc fileprivate func longAction(_ long: UILongPressGestureRecognizer) {
        switch long.state {
        case .began:
            timer = Timer(timeInterval: 0.2, target: self, selector: #selector(showHeartAnimation), userInfo: nil, repeats: true)
            break
        case .ended:
            timer?.invalidate()
            timer = nil
            break
        default: break
        }
    }

}

extension IMHeardAnimationViewController{
    
     @objc fileprivate func showHeartAnimation() {
        let heartView = IMHearView(frame: CGRect(x: 0, y: 0, width: heartWH, height: heartWH))
        heartView.center = CGPoint(x: screenW * 0.75, y: screenH * 0.9)
        view.addSubview(heartView)
        
        heartView.startAnimation(view)
    }    
}






