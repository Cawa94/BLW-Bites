//
//  InfoViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 21/3/23.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var explicationTextView: UITextView!
    @IBOutlet private weak var ewelinaImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        explicationTextView.attributedText = "INFO_DESCRIPTION".localized().htmlToAttributedString()
        DispatchQueue.main.async {
            self.viewDidLayoutSubviews()
        }
    }

    override func viewDidLayoutSubviews() {
        textViewHeightConstraint.constant = explicationTextView.contentSize.height
        contentViewHeightConstraint.constant = textViewHeightConstraint.constant
            + 280
        ewelinaImageView.roundCornersSimplified(cornerRadius: ewelinaImageView.frame.height/2)
    }

}
