//
//  GlowingButton.swift
//  NavigationButtonRotateQuestion
//
//  Created by Reinier Melian on 01/07/2017.
//  Copyright © 2017 Pruebas. All rights reserved.
//

import UIKit

@IBDesignable
class GlowingButton: UIButton {

    @IBInspectable var animDuration: CGFloat = 3
    @IBInspectable var cornerRadius: CGFloat = 5
    @IBInspectable var maxGlowSize: CGFloat = 10
    @IBInspectable var minGlowSize: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentScaleFactor = UIScreen.main.scale
        self.layer.masksToBounds = false
        self.setupButton()
        self.startAnimation()
    }

    func setupButton() {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowPath = CGPath(roundedRect: self.bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = maxGlowSize
        self.layer.shadowOpacity = 1
    }

    func startAnimation() {
        let layerAnimation = CABasicAnimation(keyPath: "shadowRadius")
        layerAnimation.fromValue = maxGlowSize
        layerAnimation.toValue = minGlowSize
        layerAnimation.autoreverses = true
        layerAnimation.isAdditive = false
        layerAnimation.duration = CFTimeInterval(animDuration/2)
//        layerAnimation.fillMode = kCAFillModeForwards
        layerAnimation.isRemovedOnCompletion = false
        layerAnimation.repeatCount = .infinity
        self.layer.add(layerAnimation, forKey: "glowingAnimation")

    }

    public func stopAnimation() {
        self.layer.removeAllAnimations()
    }

}
