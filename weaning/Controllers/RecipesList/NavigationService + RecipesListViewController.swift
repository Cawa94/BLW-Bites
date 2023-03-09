//
//  NavigationService + RecipesListViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import Foundation

extension NavigationService {

    static func recipesListViewController() -> RecipesListViewController {
        let controller = RecipesListViewController(nibName: RecipesListViewController.xibName,
                                                   bundle: nil)
        controller.viewModel = RecipesListViewModel()
        return controller
    }

}
