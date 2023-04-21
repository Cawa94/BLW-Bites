//
//  MenuDishView.swift
//  weaning
//
//  Created by Yuri Cavallin on 15/3/23.
//

import UIKit

class MenuDishView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var dishImageView: UIImageView!
    @IBOutlet private var separatorView: UIView!

    private var viewModel: MenuDishViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("MenuDishView",
                                 owner: self,
                                 options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    func configureWith(_ viewModel: MenuDishViewModel) {
        self.viewModel = viewModel

        nameLabel.text = viewModel.menuDish.name
        separatorView.isHidden = viewModel.hideSeparator
        dishImageView.roundCornersSimplified(cornerRadius: dishImageView.frame.height/2)
        guard let image = viewModel.menuDish.image, !image.isEmpty
            else { return }
        let reference = StorageService.shared.getReferenceFor(path: image)
        dishImageView.sd_setImage(with: reference, placeholderImage: nil)
    }

    @IBAction func openDish() {
        viewModel?.tapHandler()
    }

}
