//
//  NavigationService+HomepageViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 18/2/23.
//

import Foundation

extension NavigationService {

    static func homepageViewController() -> HomepageViewController {
        let controller = HomepageViewController(nibName: HomepageViewController.xibName,
                                                bundle: nil)
        controller.viewModel = HomepageViewModel()
        return controller
    }

}
