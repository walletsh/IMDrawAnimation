//
//  IMWaveProgressView.swift
//  IMDrawAnimation
//
//  Created by imwallet on 17/1/4.
//  Copyright © 2017年 imWallet. All rights reserved.
//

import UIKit


//水波动画的关键点就在于正余弦函数,使用两条正余弦函数进行周期性变化,就会产生所谓的波纹动画.
/*
 正弦型函数解析式：y=Asin（ωx+φ）+h
 各常数值对函数图像的影响：
 φ（初相位）：决定波形与X轴位置关系或横向移动距离（左加右减）
 ω：决定周期（最小正周期T=2π/|ω|）
 A：决定峰值（即纵向拉伸压缩的倍数）
 h：表示波形在Y轴的位置关系或纵向移动距离（上加下减）
 */
/*
 如果想绘制出来一条正弦函数曲线，可以沿着假想的曲线绘制许多个点，然后把点逐一用直线连在一起，如果点足够多，就可以得到一条满足需求的曲线，这也是一种微分的思想。而这些点的位置可以通过正弦函数的解析式求得。
 加入水波的峰值是1，周期是2π，初相位是0，h位移也是0。那么计算各个点的坐标公式就是y = sin(x);获得各个点的坐标之后，使用CGPathAddLineToPoint这个函数，把这些点逐一连成线，就可以得到最后的路径。
 */
/*
 如果想要得到一个动态的波纹,随着时间的变化,我们如果假定每个点的x位置没有变化,那么只要让其y随着时间有规律的变化就可以让人觉得是在有规律的动.需要注意UIKit的坐标系统y轴是向下延伸。
 如果想在0到2π这个距离显示2个完整的波曲线，那么周期就是π.如果每次增加π/4,则4s就会完成一个周期.
 如果想要在width上来宽度上展示2个周期的水波,则周期是waveWidth / 2,w = 2 * M_PI / waveWidth
 */

class IMWaveProgressView: UIView {
    
    /// 浪弧度
    var waveCurvature: CGFloat!
    
    /// 波动速度
    var waveSpeed: CGFloat!
    
    /// 浪高
    var waveHeight: CGFloat!
    
    /// 真实浪的颜色
    var realWaveColor: UIColor?
    
    /// 虚拟浪的颜色
    var maskWaveColor: UIColor?
    
    fileprivate var timer: CADisplayLink?
    
    /// 真实浪
    fileprivate lazy var realWaveLayer: CAShapeLayer = {
        let realLayer = CAShapeLayer()
        realLayer.frame = CGRect(x: 0, y: self.bounds.size.height - self.waveHeight, width: self.bounds.size.width, height: self.waveHeight)
        realLayer.fillColor = self.realWaveColor?.cgColor
        return realLayer
    }()
    
    /// 虚拟浪
    fileprivate lazy var maskWaveLayer: CAShapeLayer = {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRect(x: 0, y: self.bounds.size.height - self.waveHeight, width: self.bounds.size.width, height: self.waveHeight)

        maskLayer.fillColor = self.maskWaveColor?.cgColor
        return maskLayer
    }()
    
    /// 偏移量,决定了这个点在y轴上的位置,以此来实现动态效果
    fileprivate var offset: CGFloat = 0
    
    lazy var iconView: UIImageView = {
        let icon = UIImageView(frame: CGRect(x: (self.bounds.size.width - 60) * 0.5, y: 0, width: 60, height: 60))
        icon.layer.cornerRadius = 20
        icon.layer.borderWidth = 2
        icon.layer.borderColor = UIColor.white.cgColor
        return icon
    }()
    

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        installDefaultData()
        
        startWaveAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension IMWaveProgressView{
    
    fileprivate func installDefaultData() {
        waveCurvature = 2
        waveSpeed = 1
        waveHeight = 5
        realWaveColor = UIColor.white
        maskWaveColor = UIColor.white.withAlphaComponent(0.5)
        
        self.layer.addSublayer(realWaveLayer)
        self.layer.addSublayer(maskWaveLayer)
        self.addSubview(iconView)
    }
    
    func startWaveAnimation() {
        timer = CADisplayLink(target: self, selector: #selector(waveAnimation(_:)))
        timer?.add(to: RunLoop.current, forMode: .commonModes)
    }
    
    func stopWaveAnimation() {
        timer?.invalidate()
        timer = nil
    }
}


extension IMWaveProgressView{
    
    @objc fileprivate func waveAnimation(_ timer: CADisplayLink) {
        
        let viewWidth = self.bounds.size.width
        let viewHeight = self.bounds.size.height
        let iconViewH = iconView.bounds.size.height
        
        //累加偏移量,这样就可以通过speed来控制波动的速度了
        offset += waveSpeed
        
        // 真实浪的路径
        let realPath = CGMutablePath()
        realPath.move(to: CGPoint(x: 0, y: waveHeight))
        
        var realWaveY: CGFloat = 0.0
        for realWaveX in 0...Int(viewWidth) {
            realWaveY = waveHeight * sin(0.01 * waveCurvature * CGFloat(realWaveX) + offset * 0.045)
            realPath.addLine(to: CGPoint(x: CGFloat(realWaveX), y: realWaveY))
        }
        
        // 头像波动
        let iconCenterX = viewWidth * 0.5
        let iconCenterY = waveHeight * sin(0.01 * waveCurvature * iconCenterX + offset * 0.045)
        iconView.frame.origin.y = viewHeight - iconViewH - waveHeight + iconCenterY
        
        //连接四个角和以及波浪,共同组成水波.
        realPath.addLine(to: CGPoint(x: viewWidth, y: waveHeight))
        realPath.addLine(to: CGPoint(x: 0, y: waveHeight))
        realPath.closeSubpath()
        realWaveLayer.path = realPath
        realWaveLayer.fillColor = realWaveColor?.cgColor
        
        // 虚拟浪的路径
        let maskPath = CGMutablePath()
        maskPath.move(to: CGPoint(x: 0, y: waveHeight))
        var maskWaveY: CGFloat = 0.0
        for maskWaveX in 0...Int(viewWidth){
            maskWaveY = waveHeight * cos(0.01 * waveCurvature * CGFloat(maskWaveX) + offset * 0.045)
            maskPath.addLine(to: CGPoint(x: CGFloat(maskWaveX), y: maskWaveY))
        }
        
        //连接四个角和以及波浪,共同组成水波.
        maskPath.addLine(to: CGPoint(x: viewWidth, y: waveHeight))
        maskPath.addLine(to: CGPoint(x: 0, y: waveHeight))
        maskPath.closeSubpath()
        maskWaveLayer.path = maskPath
        maskWaveLayer.fillColor = maskWaveColor?.cgColor
    }
    
    
//    #pragma mark -- 波动动画实现
//    - (void)waveAnimation
//    {
//    CGFloat waveHeight = self.waveHeight;
//    //如果是0或者1,则不需要wave的高度,否则会看出来一个小的波动.
//    if (self.progress == 0.0f || self.progress == 1.0f) {
//    waveHeight = 0.f;
//    }
//    self.offset += self.speed;
//    CGMutablePathRef pathRef = CGPathCreateMutable();
//    CGFloat startOffY = waveHeight * sinf(self.offset * M_PI * 2 / self.bounds.size.width);
//    CGFloat orignOffY = 0.0;
//    CGPathMoveToPoint(pathRef, NULL, 0, startOffY);
//    for (CGFloat i = 0.f; i <= self.bounds.size.width; i++) {
//    orignOffY = waveHeight * sinf(2 * M_PI / self.bounds.size.width * i + self.offset * M_PI * 2 / self.bounds.size.width) + self.yHeight;
//    CGPathAddLineToPoint(pathRef, NULL, i, orignOffY);
//    }
//    //连接四个角和以及波浪,共同组成水波.
//    CGPathAddLineToPoint(pathRef, NULL, self.bounds.size.width, orignOffY);
//    CGPathAddLineToPoint(pathRef, NULL, self.bounds.size.width, self.bounds.size.height);
//    CGPathAddLineToPoint(pathRef, NULL, 0, self.bounds.size.height);
//    CGPathAddLineToPoint(pathRef, NULL, 0, startOffY);
//    CGPathCloseSubpath(pathRef);
//    self.waveLayer.path = pathRef;
//    self.waveLayer.fillColor = self.waveColor.CGColor;
//    CGPathRelease(pathRef);
//    }
    
    @objc fileprivate func waveAnimationTwo(_ timer: CADisplayLink) {
        let viewWidth = self.bounds.size.width
        let viewHeight = self.bounds.size.height
        let iconViewH = iconView.bounds.size.height
        
        //累加偏移量,这样就可以通过speed来控制波动的速度了
        offset += waveSpeed
        
        // 真实浪的路径
        let realPath = CGMutablePath()
        //  如果想要在width上来宽度上展示2个周期的水波,则周期是waveWidth / 2,w = 2 * M_PI / waveWidth
        let realStartY = waveHeight * sin(2 * CGFloat.pi / viewWidth * offset)
        realPath.move(to: CGPoint(x: 0, y: realStartY))
        
        var realWaveY: CGFloat = 0.0
        for realWaveX in 0...Int(viewWidth) {
            realWaveY = waveHeight * sin(2 * CGFloat.pi / viewWidth * (CGFloat(realWaveX) + offset))
            realPath.addLine(to: CGPoint(x: CGFloat(realWaveX), y: realWaveY))
        }
        
        // 头像波动
        let iconCenterX = viewWidth * 0.5
        let iconCenterY = waveHeight * sin(2 * CGFloat.pi / viewWidth * (iconCenterX + offset))
        iconView.frame.origin.y = viewHeight - iconViewH - waveHeight + iconCenterY
        
        realPath.addLine(to: CGPoint(x: viewWidth, y: realStartY))
        realPath.addLine(to: CGPoint(x: 0, y: realStartY))
        realPath.closeSubpath()
        realWaveLayer.path = realPath
        realWaveLayer.fillColor = realWaveColor?.cgColor
        
        // 虚拟浪的路径
        let maskPath = CGMutablePath()
        let maskStartY = waveHeight * cos(2 * CGFloat.pi / viewWidth * offset)

        maskPath.move(to: CGPoint(x: 0, y: maskStartY))
        var maskWaveY: CGFloat = 0.0
        for maskWaveX in 0...Int(viewWidth){
            maskWaveY = waveHeight * cos(2 * CGFloat.pi / viewWidth * (CGFloat(maskWaveX) + offset))
            maskPath.addLine(to: CGPoint(x: CGFloat(maskWaveX), y: maskWaveY))
        }
        
        maskPath.addLine(to: CGPoint(x: viewWidth, y: maskStartY))
        maskPath.addLine(to: CGPoint(x: 0, y: maskStartY))
        maskPath.closeSubpath()
        maskWaveLayer.path = maskPath
        maskWaveLayer.fillColor = maskWaveColor?.cgColor
    }
}






