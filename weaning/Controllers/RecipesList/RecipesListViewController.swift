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

    var selectedIndexPath: IndexPath?
    var viewModel: RecipesListViewModel?
    private var hasSearched = false

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
        recipeSearchBar.placeholder = "RECIPE_LIST_SEARCH".localized()

        DispatchQueue.main.async {
            self.categoriesCollectionView.reloadData()
        }

        getAllRecipes()

        hideKeyboardWhenTappedAround()
    }

    func getAllRecipes() {
        FirestoreService.shared.database.collection("short_recipes").order(by: "name").getDocuments() { querySnapshot, error in
            self.convertRecipesData(querySnapshot, error)
        }
    }

    func getFilteredRecipes(isFavorites: Bool = false) {
        hasSearched = false
        if !isFavorites, let categorySelected = viewModel?.categorySelected {
            let category = RecipeCategory.allValues[categorySelected].id
            FirestoreService.shared.database.collection("short_recipes")
                .whereField("category", arrayContains: category)
                .getDocuments() { querySnapshot, error in
                    self.convertRecipesData(querySnapshot, error)
            }
        } else if isFavorites {
            FirestoreService.shared.database.collection("short_recipes")
                .whereField("id", in: UserDefaultsService.favoriteRecipes.compactMap { $0 })
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
            cell.configureWithRecipeCategory(.init(recipeCategory: recipeCategory, isFavorites: indexPath.row == 0),
                                             isSelected: viewModel?.categorySelected == indexPath.row)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortRecipeCollectionViewCell",
                                                                for: indexPath) as? ShortRecipeCollectionViewCell,
                  let shortRecipe = viewModel?.shortRecipes[indexPath.row]
                else { return UICollectionViewCell() }
            cell.configureWith(.init(shortRecipe: shortRecipe), imageCornerRadius: 157/2)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 0 {
            return 10
        } else {
            return 5
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
            label.font = .titleFontOf(size: 16)
            label.text = categoryName
            let width = label.intrinsicContentSize.width + 55
            return CGSize(width: width, height: CategoryCollectionViewCell.defaultHeight)
        } else {
            let leftInset = 10
            let columnWidth = Int(collectionView.bounds.width) / 2 - leftInset
            let width = columnWidth - 5

            return CGSize(width: CGFloat(width), height: ShortRecipeCollectionViewCell.defaultHeight)
        }
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 0 {
            return .init(top: 10, left: 10, bottom: 10, right: 10)
        } else {
            return .init(top: 10, left: 10, bottom: 10, right: 10)
        }
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 0 {
            return 0
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            if indexPath.row != 0 || PurchaseManager.shared.hasUnlockedPro {
                recipeSearchBar.text = nil
                let currentCategory = viewModel?.categorySelected
                viewModel?.categorySelected = currentCategory == indexPath.row ? nil : indexPath.row
                DispatchQueue.main.async {
                    self.categoriesCollectionView.reloadData()
                }
                self.getFilteredRecipes(isFavorites: viewModel?.categorySelected != nil ? indexPath.row == 0 : false)
            } else {
                NavigationService.present(viewController: NavigationService.subscriptionViewController())
            }
        } else {
            guard let shortRecipe = viewModel?.shortRecipes[indexPath.row], let id = shortRecipe.id
                else { return }
            if shortRecipe.isFree || PurchaseManager.shared.hasUnlockedPro {
                let recipeController = NavigationService.recipeViewController(
                    recipeId: id,
                    cellFavoriteImageView: (collectionView.cellForItem(at: indexPath) as? ShortRecipeCollectionViewCell)?.publicFavoriteImageView)
                self.selectedIndexPath = indexPath
                NavigationService.push(viewController: recipeController)
            } else {
                NavigationService.present(viewController: NavigationService.subscriptionViewController())
            }
        }
    }

}

extension RecipesListViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getFilteredRecipes()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty ?? true && hasSearched {
            getFilteredRecipes()
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text?.capitalized
            else { return }
        if !keyword.isEmpty {
            searchKeyword(keyword)
        } else if hasSearched {
            getFilteredRecipes()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        guard let keyword = searchBar.text?.capitalized
            else { return }
        if !keyword.isEmpty {
            searchKeyword(keyword)
        } else if hasSearched {
            getFilteredRecipes()
        }
    }

    func searchKeyword(_ keyword: String) {
        hasSearched = true
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

extension RecipesListViewController : ZoomingViewController {

    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return nil
    }

    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        if let indexPath = selectedIndexPath, let cell = recipesCollectionView?.cellForItem(at: indexPath) as? ShortRecipeCollectionViewCell {
            return cell.publicImageView
        } else {
            return nil
        }
    }

}
