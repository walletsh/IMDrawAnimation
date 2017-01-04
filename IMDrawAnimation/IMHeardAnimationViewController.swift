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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.lightGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        view.addGestureRecognizer(tap)
        
        let long = UILongPressGestureRecognizer(target: self, action: #selector(longAction(_:)))
        long.minimumPressDuration = 0.2
        view.addGestureRecognizer(long)
        // Do any additional setup after loading the view.
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
        heartView.center = CGPoint(x: screenW * 0.5, y: screenH * 0.9)
        view.addSubview(heartView)
        
        heartView.startAnimation(view)
    }    
}






