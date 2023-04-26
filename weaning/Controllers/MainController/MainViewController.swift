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
        UITabBarItem(title: "MAIN_START".localized(),
                         image: UIImage(systemName: "house")?.withRenderingMode(.alwaysOriginal).withTintColor(.lightGray),
                         selectedImage: UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.mainColor))

        let foodListController = NavigationService.foodListViewController().embedInNavigationController()
        foodListController.isNavigationBarHidden = true
        foodListController.tabBarItem =
            UITabBarItem(title: "Żywność",
                         image: UIImage(systemName: "carrot")?.withRenderingMode(.alwaysOriginal).withTintColor(.lightGray),
                         selectedImage: UIImage(systemName: "carrot.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.mainColor))

        let menuSelectorController = MenuSelectorViewController().embedInNavigationController()
        menuSelectorController.isNavigationBarHidden = true
        menuSelectorController.tabBarItem =
            UITabBarItem(title: "Menu",
                         image: UIImage(systemName: "menucard")?.withRenderingMode(.alwaysOriginal).withTintColor(.lightGray),
                         selectedImage: UIImage(systemName: "menucard.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.mainColor))

        let recipesListController = NavigationService.recipesListViewController().embedInNavigationController()
        recipesListController.isNavigationBarHidden = true
        recipesListController.tabBarItem =
            UITabBarItem(title: "Przepisy",
                         image: UIImage(systemName: "birthday.cake")?.withRenderingMode(.alwaysOriginal).withTintColor(.lightGray),
                         selectedImage: UIImage(systemName: "birthday.cake.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.mainColor))

        let infoController = NavigationService.infoViewController().embedInNavigationController()
        infoController.isNavigationBarHidden = true
        infoController.tabBarItem =
            UITabBarItem(title: "Info",
                         image: UIImage(systemName: "info.bubble")?.withRenderingMode(.alwaysOriginal).withTintColor(.lightGray),
                         selectedImage: UIImage(systemName: "info.bubble.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.mainColor))

        return [homepageController, foodListController, menuSelectorController, recipesListController, infoController]
    }

    func configureAppearance() {
        UITabBarItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont(name: "Nunito-Bold", size: 10)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.mainColor,
            NSAttributedString.Key.font: UIFont(name: "Nunito-Bold", size: 10)!], for: .selected)
        UITabBar.appearance().barTintColor = .systemBackground
        UITabBar.appearance().backgroundColor = .white
    }

}
