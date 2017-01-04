//
//  CustomActionSheet.swift
//  IMActionSheetSwift
//
//  Created by imwallet on 17/1/3.
//  Copyright © 2017年 imWallet. All rights reserved.
//

import UIKit

@objc protocol CustomActionSheetDelegate: NSObjectProtocol {
    func sheet(_ sheet: CustomActionSheet, clickButtonAt index: Int)
    @objc optional func cancelButtonClick(_ sheet: CustomActionSheet)
}

class CustomActionSheet: UIView {
    
    fileprivate var title: String = ""
    fileprivate var otherTitles: [String] = []
    fileprivate var buttonCount: Int = 0
    
    fileprivate var mainView: UIView!
    fileprivate var cancelBtn: UIButton!
    
    var cancelTitle: String?{
        didSet{
            self.cancelBtn.setTitle(cancelTitle, for: .normal)
        }
    }
    
    weak var delegate: CustomActionSheetDelegate?
    
    init(title: String, otherTitles: [String]) {
        
        self.title = title
        self.otherTitles = otherTitles
        self.buttonCount = otherTitles.count
        
        super.init(frame: CGRect.zero)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension CustomActionSheet{
    
    fileprivate func setupUI() {
        let  window = UIApplication.shared.keyWindow
        self.frame = (window?.bounds)!
        window?.addSubview(self)
        
        self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEvent(_:)))
        self.addGestureRecognizer(tap)
        
        let viewW = self.frame.size.width
        let viewH = self.frame.size.height
        let lineH: CGFloat = 1.0
        let buttonH: CGFloat = 48
        let splitH: CGFloat = 4.0
        let mainViewH = (buttonH + buttonH + splitH) + (lineH + buttonH) * CGFloat(buttonCount)
        
        mainView = UIView(frame: CGRect(x: 0, y: viewH, width: viewW, height: mainViewH))
        mainView.backgroundColor = UIColor.randomColor()
        self.addSubview(mainView)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewW, height: buttonH))
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.randomColor()
        mainView.addSubview(titleLabel)
        
        for idx in 0..<buttonCount {
            let lineY = titleLabel.frame.maxY + CGFloat(idx) * buttonH
            
            let lineView = UIView(frame: CGRect(x: 0, y: lineY, width: viewW, height: lineH))
            lineView.backgroundColor = UIColor.lightGray
            mainView.addSubview(lineView)
            
            let button = UIButton(frame: CGRect(x: 0, y: lineY + lineH, width: viewW, height: buttonH))
            button.tag = idx
            button.setTitle(otherTitles[idx], for: .normal)
            button.setTitleColor(UIColor.randomColor(), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            button.addTarget(self, action: #selector(otherButtonClick(_:)), for: .touchUpInside)
            mainView.addSubview(button)
        }
        
        let splitView = UIView(frame: CGRect(x: 0, y: buttonH + (buttonH + lineH) * CGFloat(buttonCount), width: viewW, height: splitH))
        splitView.backgroundColor = UIColor.lightGray
        mainView.addSubview(splitView)
        
        cancelBtn = UIButton(frame: CGRect(x: 0, y: splitView.frame.maxY, width: viewW, height: buttonH))
        cancelBtn.setTitleColor(UIColor.randomColor(), for: .normal)
        cancelBtn.setTitle("cancel", for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick(_:)), for: .touchUpInside)
        mainView.addSubview(cancelBtn)
        
    }
}

extension CustomActionSheet{
    func show() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: { 
            self.mainView.transform = CGAffineTransform(translationX: 0, y: -self.mainView.frame.size.height)
            self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        }, completion: nil)
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { 
            self.mainView.transform = CGAffineTransform.identity
            self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
}

extension CustomActionSheet{
    @objc fileprivate func tapEvent(_ tap: UITapGestureRecognizer) {
        dismiss()
    }
    
    @objc fileprivate func otherButtonClick(_ sender: UIButton) {
        delegate?.sheet(self, clickButtonAt: sender.tag)
        dismiss()
    }
    
    @objc fileprivate func cancelBtnClick(_ sender: UIButton) {
        delegate?.cancelButtonClick?(self)
        dismiss()
    }
}


