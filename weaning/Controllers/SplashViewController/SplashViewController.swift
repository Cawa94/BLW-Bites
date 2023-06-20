//
//  SplashViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 21/6/23.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        RevenueCatService.shared.configure()
    }

}
