//
//  NavigationService.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import Foundation
import UIKit

struct NavigationService {

    enum TabControllers: Int {
        case foodList = 0
        case recipesList = 1
        case menuSelector = 2
    }

    init() {}

    static var appWindow: UIWindow {
        return SceneDelegate.shared.appWindow
    }

    static var tabNavigationController: UINavigationController? {
        return appWindow.rootViewController?.topVisibleViewController.navigationController
    }

    static var mainViewController: MainViewController? {
        return rootNavigationController?.viewControllers.first as? MainViewController
    }

    static var rootNavigationController: UINavigationController? {
        return appWindow.rootViewController as? UINavigationController
    }

    static func push(viewController: UIViewController) {
        tabNavigationController?.pushViewController(viewController, animated: true)
    }

    static func showControllerInTabBar(controller: TabControllers) {
        mainViewController?.selectedIndex = controller.rawValue
    }

    static func popViewController() {
        tabNavigationController?.popViewController(animated: true)
    }

}
