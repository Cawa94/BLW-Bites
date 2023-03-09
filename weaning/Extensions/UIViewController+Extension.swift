//
//  ViewController+Extension.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import UIKit

public extension UIViewController {

    class var xibName: String {
        return String(describing: self)
    }

    /// Return top visible controller even if we have inner UI(Navigation/TabBar)Controller's inside
    var topVisibleViewController: UIViewController {
        switch self {
        case let navController as UINavigationController:
            return navController.visibleViewController?.topVisibleViewController ?? navController
        case let tabController as UITabBarController:
            return tabController.selectedViewController?.topVisibleViewController ?? tabController
        default:
            return self.presentedViewController?.topVisibleViewController ?? self
        }
    }

    func embedInNavigationController() -> UINavigationController {
        let navController = UINavigationController(rootViewController: self)
        let appearance = UINavigationBarAppearance()
        /*
        navController.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "common_navigation_back")
        navController.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "common_navigation_back")

        let backgroundImage = UIImage.support
            .imageWith(color: .green, size: CGSize(width: 1, height: 1))?
            .base

        appearance.backgroundImage = backgroundImage
        appearance.shadowImage = #imageLiteral(resourceName: "navbar_shadow")*/

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.titleFontOf(size: 16),
            .foregroundColor: UIColor.white
        ]

        navController.navigationBar.tintColor = .white
        appearance.titleTextAttributes = attributes

        navController.isNavigationBarHidden = true

        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = navController.navigationBar.standardAppearance

        return navController
    }

}
