//
//  UIImage+Extension.swift
//  weaning
//
//  Created by Yuri Cavallin on 24/4/23.
//

import UIKit

extension UIImage{

    var grayscaled: UIImage?{
        let ciImage = CIImage(image: self)
        let grayscale = ciImage?.applyingFilter("CIColorControls",
                                                parameters: [ kCIInputSaturationKey: 0.0 ])
        if let gray = grayscale{
            return UIImage(ciImage: gray)
        } else {
            return nil
        }
    }

}
