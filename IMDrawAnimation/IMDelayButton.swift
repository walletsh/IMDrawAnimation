//
//  IMDelayButton.swift
//  IMDrawAnimation
//
//  Created by imwallet on 17/1/9.
//  Copyright © 2017年 imWallet. All rights reserved.
//

import UIKit



/// Button延迟点击

class IMDelayButton: UIButton {

    fileprivate let defaultDuration = 1.0
    fileprivate var isDelayEvent = false
    var delayDuration: Double?
    
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
        if self.isKind(of: UIButton.self) {
            
            self.delayDuration = self.delayDuration == 0 ? defaultDuration : self.delayDuration
            
            print("delayDuration value is \(delayDuration)")
            
            if isDelayEvent { return }
            
            guard (delayDuration != nil) else {
                return super.sendAction(action, to: target, for: event)
            }
            
            if delayDuration! > 0 {
                isDelayEvent = true
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayDuration!, execute: {
                    self.isDelayEvent = false
                })
                super.sendAction(action, to: target, for: event)
            }
            
        } else {
            super.sendAction(action, to: target, for: event)
        }
    }

}
