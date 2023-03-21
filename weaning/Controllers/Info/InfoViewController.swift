//
//  InfoViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 21/3/23.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet private weak var ewelinaImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        ewelinaImageView.roundCornersSimplified()
    }

}
