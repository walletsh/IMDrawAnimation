//
//  IMMusicBarViewController.swift
//  IMDrawAnimation
//
//  Created by imwallet on 16/12/13.
//  Copyright © 2016年 imWallet. All rights reserved.
//

import UIKit

class IMMusicBarViewController: UIViewController {
    
    fileprivate lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 30, y: 420, width: screenW - 60, height: 250))
        label.text = "剑吹白雪妖邪灭，袖拂春风槁朽苏。盆里的水还是温的，还带些栀子花的香气。西门吹雪刚洗过澡，洗过头，他已将全身上下每个部分都洗得彻底干净。现在小红正在为他梳头束发，小翠和小玉正在为他修剪手脚上的指甲。小云已为他准备了一套全新的衣裳，从内衣到袜子都是白的，雪一样白。她们都是这城里的名妓，都很美，很年轻，也很懂得伺候男人——用各种方法来伺候男人。但西门吹雪却只选择了一种。他连碰都没有碰过她们。他也已斋戒了三天。因为他正准备去做一件他自己认为世上最神圣的事。他要去杀一个人！"
        
        label.numberOfLines = 0;
        label.backgroundColor = UIColor.randomColor()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
//    fileprivate lazy var labelTwo: UILabel = {
//        let label = UILabel()
//        let text: NSString = "剑吹白雪妖邪灭，袖拂春风槁朽苏。盆里的水还是温的，还带些栀子花的香气。西门吹雪刚洗过澡，洗过头，他已将全身上下每个部分都洗得彻底干净。现在小红正在为他梳头束发，小翠和小玉正在为他修剪手脚上的指甲。小云已为他准备了一套全新的衣裳，从内衣到袜子都是白的，雪一样白。她们都是这城里的名妓，都很美，很年轻，也很懂得伺候男人——用各种方法来伺候男人。但西门吹雪却只选择了一种。他连碰都没有碰过她们。他也已斋戒了三天。因为他正准备去做一件他自己认为世上最神圣的事。他要去杀一个人！"
//        
//        let size = text.boundingRect(with: CGSize(width: screenW - 60, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 17)], context: nil)
//        label.frame = CGRect(x: 30, y: 450, width: size.width, height: size.height)
//        label.numberOfLines = 0;
//        label.backgroundColor = UIColor.randomColor()
//        label.font = UIFont.systemFont(ofSize: 17)
//        label.textAlignment = .center
//        label.text = text as String
//        return label
//    }()
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: self.label.frame)
        imageView.image = UIImage(named: "img_01")
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        title = "音乐"
        
        startAnimation()
        
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension IMMusicBarViewController{
    
    fileprivate func startAnimation() {
        let layer = CAReplicatorLayer()
        layer.frame = CGRect(x: 0, y: 100, width: screenW, height: 300)
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


extension IMMusicBarViewController: CustomActionSheetDelegate{
    fileprivate func setupUI() {

        view.addSubview(label)

        view.addSubview(imageView)
        
        let startBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        startBtn.center = CGPoint(x: screenW * 0.5, y: screenH * 0.85)
        startBtn.backgroundColor = UIColor.purple
        startBtn.setTitle("点我", for: .normal)
        startBtn.setTitleColor(UIColor.white, for: .normal)
        startBtn.addTarget(self, action: #selector(clickAnimation(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: startBtn)
    }
    
    @objc fileprivate func clickAnimation(_ sender: UIButton) {
        let sheet = CustomActionSheet(title: "CustomActionSheet", otherTitles: ["actionOne", "actionTwo", "actionThree", "actionFour", "actionFive"])
        sheet.delegate = self
        sheet.cancelTitle = "取消"
        sheet.show()
    }
    
    func sheet(_ sheet: CustomActionSheet, clickButtonAt index: Int) {
        print("clickButtonAt \(index)")
    }
    
    //    func cancelButtonClick(_ sheet: CustomActionSheet) {
    //        print("cancelButtonClick")
    //    }
}

// MARK: - 刮刮卡效果
extension IMMusicBarViewController{
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let contentPoint = touch.location(in: imageView)
            // 设置清除点的大小
            let rect = CGRect(x: contentPoint.x, y: contentPoint.y, width: 20, height: 20)
            // 默认是去创建一个透明的视图
            UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 0)
            let context = UIGraphicsGetCurrentContext()
            if let context = context {
                //把imageView的layer映射到上下文中
                imageView.layer.render(in: context)
                // 清除划过的区域
                context.clear(rect);
                let img = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                self.imageView.image = img
            }
        }
    }
    
}
