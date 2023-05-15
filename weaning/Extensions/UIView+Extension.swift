//
//  UIView+Extensions.swift
//  weaning
//
//  Created by Yuri Cavallin on 18/2/23.
//

import UIKit
import ObjectiveC.runtime

private var _roundLayerKey: UInt8 = 0

extension UIView {
    
    private var storedRoundLayer: CAShapeLayer? {
        get {
            return objc_getAssociatedObject(self, &_roundLayerKey) as? CAShapeLayer
        }
        set {
            objc_setAssociatedObject(self, &_roundLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func roundCorners(corners: UIRectCorner = .allCorners,
                      cornerRadius: CGFloat = .defaultCornerRadius,
                      borderWidth: CGFloat = 0,
                      borderColor: UIColor = .clear) {

        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds

        let roundedPath = UIBezierPath(roundedRect: bounds,
                                       byRoundingCorners: corners,
                                       cornerRadii: CGSize(width: cornerRadius,
                                                           height: cornerRadius))
        maskLayer.path = roundedPath.cgPath

        let roundLayer = CAShapeLayer()
        roundLayer.frame = bounds
        roundLayer.path = roundedPath.cgPath
        roundLayer.lineWidth = borderWidth
        roundLayer.strokeColor = borderColor.cgColor
        roundLayer.fillColor = nil

        storedRoundLayer?.removeFromSuperlayer()
        storedRoundLayer = roundLayer

        layer.mask = maskLayer
        layer.addSublayer(roundLayer)
        layer.masksToBounds = true
    }

    func roundCornersSimplified(cornerRadius: CGFloat = .defaultCornerRadius,
                                borderWidth: CGFloat = 0,
                                borderColor: UIColor = .clear) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }

    func drawShadow(cornerRadius: CGFloat = .defaultCornerRadius) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.2
    }

    func bounce() {
        UIView.animate(withDuration: 0.3 / 1.5, animations: {
                self.transform =
                    CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
            }) { finished in
                UIView.animate(withDuration: 0.3 / 2, animations: {
                    self.transform = .identity.scaledBy(x: 0.9, y: 0.9)
                }) { finished in
                    UIView.animate(withDuration: 0.3 / 2, animations: {
                        self.transform = CGAffineTransform.identity
                    })
                }
            }
    }

}
