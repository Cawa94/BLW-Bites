//
//  RecipesListViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class RecipesListViewController: UIViewController {

    @IBOutlet private weak var categoriesCollectionView: UICollectionView!
    @IBOutlet private weak var categoriesHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var recipesCollectionView: UICollectionView!
    @IBOutlet private weak var recipeSearchBar: CustomSearchBar!

    var viewModel: RecipesListViewModel?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        categoriesCollectionView.register(UINib(nibName:"CategoryCollectionViewCell", bundle: nil),
                                          forCellWithReuseIdentifier:"CategoryCollectionViewCell")
        recipesCollectionView.register(UINib(nibName:"ShortRecipeCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier:"ShortRecipeCollectionViewCell")
        recipeSearchBar.placeholder = "Search recipe"

        DispatchQueue.main.async {
            self.categoriesCollectionView.reloadData()
        }

        getAllRecipes()
    }

    func getAllRecipes() {
        FirestoreService.shared.database.collection("short_recipes").order(by: "name").getDocuments() { querySnapshot, error in
            self.convertRecipesData(querySnapshot, error)
        }
    }

    func getFilteredRecipes() {
        if let categorySelected = viewModel?.categorySelected {
            let category = RecipeCategory.allValues[categorySelected].id
            FirestoreService.shared.database.collection("short_recipes")
                .whereField("category", isEqualTo: category)
                .getDocuments() { querySnapshot, error in
                    self.convertRecipesData(querySnapshot, error)
            }
        } else {
            getAllRecipes()
        }
    }

    func convertRecipesData(_ querySnapshot: QuerySnapshot?, _ error: Error?) {
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            self.viewModel?.shortRecipes.removeAll()
            for document in querySnapshot!.documents {
                self.viewModel?.shortRecipes.append(.init(data: document.data()))
            }
            DispatchQueue.main.async {
                self.recipesCollectionView.reloadData()
            }
        }
    }

}

extension RecipesListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return RecipeCategory.allValues.count
        } else {
            return viewModel?.shortRecipes.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell",
                                                                for: indexPath) as? CategoryCollectionViewCell
                else { return UICollectionViewCell() }
            let recipeCategory = RecipeCategory.allValues[indexPath.row]
            cell.configureWithRecipeCategory(recipeCategory, isSelected: viewModel?.categorySelected == indexPath.row)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortRecipeCollectionViewCell",
                                                                for: indexPath) as? ShortRecipeCollectionViewCell,
                  let shortRecipe = viewModel?.shortRecipes[indexPath.row]
                else { return UICollectionViewCell() }
            cell.configureWith(shortRecipe)
            return cell
        }
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            let categoryName = RecipeCategory.allValues[indexPath.row].name
            let label = UILabel()
            label.font = .regularFontOf(size: 16)
            label.text = categoryName
            let width = label.intrinsicContentSize.width + 55
            return CGSize(width: width, height: CategoryCollectionViewCell.defaultHeight)
        } else {
            let leftInset = 20
            let columnWidth = Int(collectionView.bounds.width) / 2 - leftInset
            let width = columnWidth - (20 / 2)

            return CGSize(width: CGFloat(width), height: ShortRecipeCollectionViewCell.defaultHeight)
        }
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 0 {
            return .init(top: 10, left: 10, bottom: 10, right: 10)
        } else {
            return .init(top: 10, left: 20, bottom: 10, right: 20)
        }
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 0 {
            return 0
        } else {
            return 20
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            recipeSearchBar.text = nil
            let currentCategory = viewModel?.categorySelected
            viewModel?.categorySelected = currentCategory == indexPath.row ? nil : indexPath.row
            DispatchQueue.main.async {
                self.categoriesCollectionView.reloadData()
            }
            self.getFilteredRecipes()
        } else {
            guard let shortRecipe = viewModel?.shortRecipes[indexPath.row], let id = shortRecipe.id
                else { return }
            let recipeController = NavigationService.recipeViewController(recipeId: id)
            NavigationService.push(viewController: recipeController)
        }
    }

}

extension RecipesListViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getFilteredRecipes()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        guard let keyword = searchBar.text?.capitalized
            else { return }
        if !keyword.isEmpty {
            searchKeyword(keyword)
        } else {
            getFilteredRecipes()
        }
    }

    func searchKeyword(_ keyword: String) {
        FirestoreService.shared.database.collection("short_recipes")
            .whereField("name", isEqualTo: keyword)
            .getDocuments() { querySnapshot, error in
                if !querySnapshot!.documents.isEmpty {
                    self.convertRecipesData(querySnapshot, error)
                } else {
                    FirestoreService.shared.database.collection("short_recipes")
                        .whereField("name", isGreaterThan: keyword)
                        .whereField("name", isLessThan: "\(keyword)~")
                        .getDocuments() { querySnapshot, error in
                            self.convertRecipesData(querySnapshot, error)
                        }
                }
        }
    }

}

extension RecipesListViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y > 0 && categoriesHeightConstraint.constant == 0 {
            // swipes from top to bottom of screen -> down
            categoriesHeightConstraint.constant = 65
        } else if translation.y < -25 && categoriesHeightConstraint.constant == 65 {
            // swipes from bottom to top of screen -> up
            categoriesHeightConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }

}
