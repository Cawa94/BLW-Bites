//
//  ImageCollectionViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 25/2/23.
//

import UIKit
import ImageScrollView
import ImageViewer_swift

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var foodImageView: UIImageView!

    func configureWith(_ image: String) {
        if !image.isEmpty {
            let reference = StorageService.shared.getReferenceFor(path: image)
            foodImageView.sd_setImage(with: reference, placeholderImage: nil)
            foodImageView.roundCornersSimplified()
            let pictureTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            foodImageView.addGestureRecognizer(pictureTap)
            foodImageView.isUserInteractionEnabled = true
        }

        drawShadow()
        layoutIfNeeded()
    }

    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let imageScrollView = ImageScrollView()
        imageScrollView.setup()
        imageScrollView.backgroundColor = .white
        imageScrollView.display(image: imageView.image ?? UIImage())
        imageScrollView.frame = UIScreen.main.bounds
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        imageScrollView.addGestureRecognizer(tap)
        NavigationService.mainViewController?.view.addSubview(imageScrollView)
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }

}
