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
        let homepageController = NavigationService.homepageViewController().embedInNavigationController()
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

        let infoController = NavigationService.infoViewController().embedInNavigationController()
        infoController.isNavigationBarHidden = true
        infoController.tabBarItem =
            UITabBarItem(title: "Info",
                         image: UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal),
                         selectedImage: UIImage(named: "")?.withRenderingMode(.alwaysOriginal))

        return [homepageController, foodListController, menuSelectorController, recipesListController, infoController]
    }

    func configureAppearance() {
        UITabBarItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.textColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.mainColor], for: .selected)
        UITabBar.appearance().barTintColor = .systemBackground
        UITabBar.appearance().backgroundColor = .white
    }

}
