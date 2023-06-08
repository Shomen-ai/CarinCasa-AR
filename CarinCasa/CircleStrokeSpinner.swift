import UIKit

// ZXLoadingView is available under the MIT license. See the LICENSE file for more info.
// Author: zxin2928, zxin2928@icloud.com
// https://github.com/zxincrash/ZXLoadingView/tree/master

let kZXRingStrokeAnimationKey: String = "zxloadingview.stroke"
let kZXRingRotationAnimationKey: String = "zxloadingview.rotation"

public class ZXLoadingView: UIView {
    public var hidesWhenStopped: Bool! {
        didSet {
            self.isHidden = !self.isAnimating && hidesWhenStopped
        }
    }
    
    public var color: UIColor!
    
    public var lineWidth: CGFloat! {
        didSet {
            self.progressLayer.lineWidth = lineWidth
            self.updatePath()
        }
    }
    
//    public var lineCap: String! {
//        didSet {
//            guard let cap = self.lineCap else { return }
//            CAShapeLayerLineCap(rawValue: self.progressLayer.lineCap = cap)
//            self.updatePath()
//        }
//    }
    
    var timingFunction: CAMediaTimingFunction!
    
    public var duration: TimeInterval!
    
    public var percentComplete: CGFloat! {
        didSet {
            if self.isAnimating {
                return
            }
            
            self.progressLayer.strokeStart = 0.0
            self.progressLayer.strokeEnd = self.percentComplete
        }
    }
    
    lazy var isAnimating: Bool! = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        self.hidesWhenStopped = false
        self.duration = 1.5
        self.percentComplete = 0.0
        self.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        self.layer.addSublayer(self.progressLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(resetAnimations), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        self.invalidateIntrinsicContentSize()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.progressLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        
        self.invalidateIntrinsicContentSize()
        
        self.updatePath()
    }
    
    private func intrinsicContentSize() -> CGSize {
        return CGSize(width: self.bounds.width, height: self.bounds.height)
    }
    
    override public func tintColorDidChange() {
        super.tintColorDidChange()
        self.progressLayer.strokeColor = self.tintColor.cgColor
    }
    
    @objc private func resetAnimations() {
        if self.isAnimating {
            self.stopAnimating()
            self.startAnimating()
        }
    }
    
    public func setAnimating(animate: Bool) {
        animate ? self.startAnimating() : self.stopAnimating()
    }
    
    public func startAnimating() {
        if self.isAnimating {
            return
        }
        
        let rotationAnimation = CABasicAnimation()
        rotationAnimation.keyPath = "transform.rotation"
        rotationAnimation.duration = self.duration / 0.375
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.isRemovedOnCompletion = false
        self.progressLayer.add(rotationAnimation, forKey: kZXRingStrokeAnimationKey)
        
        let headAnimation = CABasicAnimation()
        headAnimation.keyPath = "strokeStart"
        headAnimation.duration = self.duration / 1.5
        headAnimation.fromValue = 0.0
        headAnimation.toValue = 0.25
        headAnimation.timingFunction = self.timingFunction
        
        let tailAnimation = CABasicAnimation()
        tailAnimation.keyPath = "strokeEnd"
        tailAnimation.duration = self.duration / 1.5
        tailAnimation.fromValue = 0.0
        tailAnimation.toValue = 1.0
        tailAnimation.timingFunction = self.timingFunction
        
        let endHeadAnimation = CABasicAnimation()
        endHeadAnimation.keyPath = "strokeStart"
        endHeadAnimation.beginTime = self.duration / 1.5
        endHeadAnimation.duration = self.duration / 3.0
        endHeadAnimation.fromValue = 0.25
        endHeadAnimation.toValue = 1.0
        endHeadAnimation.timingFunction = self.timingFunction
        
        let endTailAnimation = CABasicAnimation()
        endTailAnimation.keyPath = "strokeEnd"
        endTailAnimation.beginTime = self.duration / 1.5
        endTailAnimation.duration = self.duration / 3.0
        endTailAnimation.fromValue = 1.0
        endTailAnimation.toValue = 1.0
        endTailAnimation.timingFunction = self.timingFunction
        
        let animations = CAAnimationGroup()
        animations.duration = self.duration
        animations.animations = [headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]
        animations.repeatCount = .infinity
        animations.isRemovedOnCompletion = false
        self.progressLayer.add(animations, forKey: kZXRingRotationAnimationKey)
        
        self.isAnimating = true
        
        if self.hidesWhenStopped {
            self.isHidden = false
        }
    }
    
    public func stopAnimating() {
        if !self.isAnimating {
            return
        }
        
        self.progressLayer.removeAnimation(forKey: kZXRingStrokeAnimationKey)
        self.progressLayer.removeAnimation(forKey: kZXRingRotationAnimationKey)
        self.isAnimating = false
        
        if self.hidesWhenStopped {
            self.isHidden = true
        }
    }
    
    private func updatePath() {
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let radius = min(self.bounds.width * 0.5, self.bounds.height * 0.5 - self.progressLayer.lineWidth * 0.5)
        let startAngle = CGFloat(0)
        let endAngle = CGFloat(Double.pi * 2)
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        self.progressLayer.path = path.cgPath
        
        self.progressLayer.strokeStart = 0.0
        self.progressLayer.strokeEnd = self.percentComplete
    }
    
    lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = self.tintColor.cgColor
        layer.fillColor = nil
        layer.lineWidth = 1.5
        
        return layer
    }()
}
