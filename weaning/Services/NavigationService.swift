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

    static let zoomNavigation = ZoomTransitioningDelegate()
    static var willPresentSubscription = false

    init() {}

    static var appWindow: UIWindow {
        return SceneDelegate.shared.appWindow
    }

    static func makeSplashRootController() {
        appWindow.changeRootController(controller: SplashViewController())
    }

    static func makeMainRootController() {
        appWindow.changeRootController(controller: MainViewController().embedInNavigationController())
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
        tabNavigationController?.delegate = zoomNavigation
        tabNavigationController?.pushViewController(viewController, animated: true)
    }

    static func present(viewController: UIViewController) {
        rootNavigationController?.delegate = zoomNavigation
        rootNavigationController?.present(viewController, animated: true)
    }

    static func dismiss() {
        rootNavigationController?.delegate = zoomNavigation
        rootNavigationController?.dismiss(animated: true)
    }

    static func showControllerInTabBar(controller: TabControllers) {
        mainViewController?.selectedIndex = controller.rawValue
    }

    static func popViewController() {
        tabNavigationController?.delegate = zoomNavigation
        tabNavigationController?.popViewController(animated: true)
    }

    static func openLoginOrSubscription() {
        if AuthService.shared.isLoggedIn {
            NavigationService.present(viewController: NavigationService.subscriptionViewController())
        } else {
            NavigationService.present(viewController: NavigationService.loginViewController())
        }
    }

}
