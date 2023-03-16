//
//  MainViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class MainViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureAppearance()
        configureTabBar()
    }

    func configureTabBar() {
        self.delegate = self

        let viewControllerList = mainViewControllers
        viewControllers = viewControllerList
    }

    var mainViewControllers: [UIViewController] {
        let homepageController = NavigationService.subscriptionViewController().embedInNavigationController()
        homepageController.isNavigationBarHidden = true
        homepageController.tabBarItem =
            UITabBarItem(title: "Homepage",
                         image: UIImage(named: "home")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "")?.withRenderingMode(.alwaysOriginal))

        let foodListController = NavigationService.foodListViewController().embedInNavigationController()
        foodListController.isNavigationBarHidden = true
        foodListController.tabBarItem =
            UITabBarItem(title: "Foods",
                         image: UIImage(named: "foods")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "")?.withRenderingMode(.alwaysOriginal))

        let menuSelectorController = MenuSelectorViewController().embedInNavigationController()
        menuSelectorController.isNavigationBarHidden = true
        menuSelectorController.tabBarItem =
            UITabBarItem(title: "Menu",
                         image: UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "")?.withRenderingMode(.alwaysOriginal))

        let recipesListController = NavigationService.recipesListViewController().embedInNavigationController()
        recipesListController.isNavigationBarHidden = true
        recipesListController.tabBarItem =
            UITabBarItem(title: "Recipes",
                         image: UIImage(named: "recipes")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "")?.withRenderingMode(.alwaysOriginal))

        let profileController = NavigationService.recipesListViewController().embedInNavigationController()
        profileController.isNavigationBarHidden = true
        profileController.tabBarItem =
            UITabBarItem(title: "Profile",
                         image: UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "")?.withRenderingMode(.alwaysOriginal))

        return [homepageController, foodListController, menuSelectorController, recipesListController, profileController]
    }

    func configureAppearance() {
        UITabBarItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.systemTeal], for: .selected)
        UITabBar.appearance().barTintColor = .systemBackground
        UITabBar.appearance().backgroundColor = .systemBackground
    }

}
