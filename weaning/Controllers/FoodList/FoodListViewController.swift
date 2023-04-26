//
//  FoodListViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FoodListViewController: UIViewController {

    @IBOutlet private weak var categoriesCollectionView: UICollectionView!
    @IBOutlet private weak var categoriesHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var foodsCollectionView: UICollectionView!
    @IBOutlet private weak var foodSearchBar: CustomSearchBar!

    var viewModel: FoodListViewModel?

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
        foodsCollectionView.register(UINib(nibName:"ShortFoodCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier:"ShortFoodCollectionViewCell")
        foodSearchBar.placeholder = "FOOD_LIST_SEARCH".localized()

        DispatchQueue.main.async {
            self.categoriesCollectionView.reloadData()
        }

        getAllFoods()
    }

    func getAllFoods() {
        FirestoreService.shared.database.collection("short_foods").order(by: "name").getDocuments() { querySnapshot, error in
            self.convertFoodsData(querySnapshot, error)
        }
    }

    func getFilteredFoods() {
        if let categorySelected = viewModel?.categorySelected {
            let category = FoodCategory.allValues[categorySelected].id
            FirestoreService.shared.database.collection("short_foods")
                .whereField("category", isEqualTo: category)
                .getDocuments() { querySnapshot, error in
                    self.convertFoodsData(querySnapshot, error)
            }
        } else {
            getAllFoods()
        }
    }

/*
    func getFilteredFoods() {
        let keyword = keywordTextField.text
        let onlyAllergenic = allergenicSwitch.isOn
        let onlyChoking = chokingSwitch.isOn

        if onlyAllergenic && onlyChoking {
            FirestoreService.shared.database.collection("short_foods")
                // .whereField("name", isGreaterThan: keyword ?? "")
                .whereField("allergenic", isEqualTo: true)
                .whereField("risk_choking", isEqualTo: true)
                .getDocuments() { querySnapshot, error in
                    self.convertFoodsData(querySnapshot, error)
            }
        } else if onlyAllergenic {
            FirestoreService.shared.database.collection("short_foods")
                // .whereField("name", isGreaterThan: keyword ?? "")
                .whereField("allergenic", isEqualTo: true)
                .getDocuments() { querySnapshot, error in
                    self.convertFoodsData(querySnapshot, error)
            }
        } else if onlyChoking {
            FirestoreService.shared.database.collection("short_foods")
                // .whereField("name", isGreaterThan: keyword ?? "")
                .whereField("risk_choking", isEqualTo: true)
                .getDocuments() { querySnapshot, error in
                    self.convertFoodsData(querySnapshot, error)
            }
        } else {
            getAllFoods()
        }

    }
*/
    func convertFoodsData(_ querySnapshot: QuerySnapshot?, _ error: Error?) {
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            self.viewModel?.shortFoods.removeAll()
            for document in querySnapshot!.documents {
                self.viewModel?.shortFoods.append(.init(data: document.data()))
            }
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    self.foodsCollectionView.reloadData(completion: {
                        // self.foodsCollectionView.invalidateIntrinsicContentSize()
                        // self.foodsCollectionView.layoutIfNeeded()
                        // self.afterLoading()
                    })
                }
            }
        }
    }

}

extension FoodListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return FoodCategory.allValues.count
        } else {
            return viewModel?.shortFoods.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell",
                                                                for: indexPath) as? CategoryCollectionViewCell
                else { return UICollectionViewCell() }
            let foodCategory = FoodCategory.allValues[indexPath.row]
            cell.configureWithFoodCategory(foodCategory, isSelected: viewModel?.categorySelected == indexPath.row)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortFoodCollectionViewCell",
                                                                for: indexPath) as? ShortFoodCollectionViewCell,
                  let shortFood = viewModel?.shortFoods[indexPath.row]
                else { return UICollectionViewCell() }
            cell.configureWith(shortFood, imageCornerRadius: 157/2)
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
            let categoryName = FoodCategory.allValues[indexPath.row].name
            let label = UILabel()
            label.font = .titleFontOf(size: 16)
            label.text = categoryName
            let width = label.intrinsicContentSize.width + 55
            return CGSize(width: width, height: CategoryCollectionViewCell.defaultHeight)
        } else {
            let leftInset = 20
            let columnWidth = Int(collectionView.bounds.width) / 2 - leftInset
            let width = columnWidth - (20 / 2)
            return CGSize(width: CGFloat(width), height: ShortFoodCollectionViewCell.defaultHeight)
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
            foodSearchBar.text = nil
            let currentCategory = viewModel?.categorySelected
            viewModel?.categorySelected = currentCategory == indexPath.row ? nil : indexPath.row
            DispatchQueue.main.async {
                self.categoriesCollectionView.reloadData()
            }
            self.getFilteredFoods()
        } else {
            guard let shortFood = viewModel?.shortFoods[indexPath.row], let id = shortFood.id
                else { return }
            if shortFood.isFree ?? false || PurchaseManager.shared.hasUnlockedPro {
                let foodController = NavigationService.foodViewController(foodId: id)
                NavigationService.push(viewController: foodController)
            } else {
                NavigationService.present(viewController: NavigationService.subscriptionViewController())
            }
        }
    }

}

extension FoodListViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getFilteredFoods()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        guard let keyword = searchBar.text?.capitalized
            else { return }
        if !keyword.isEmpty {
            searchKeyword(keyword)
        } else {
            getFilteredFoods()
        }
    }

    func searchKeyword(_ keyword: String) {
        FirestoreService.shared.database.collection("short_foods")
            .whereField("name", isEqualTo: keyword)
            .getDocuments() { querySnapshot, error in
                if !querySnapshot!.documents.isEmpty {
                    self.convertFoodsData(querySnapshot, error)
                } else {
                    FirestoreService.shared.database.collection("short_foods")
                        .whereField("name", isGreaterThan: keyword)
                        .whereField("name", isLessThan: "\(keyword)~")
                        .getDocuments() { querySnapshot, error in
                            self.convertFoodsData(querySnapshot, error)
                        }
                }
        }
    }

}

extension FoodListViewController: UIScrollViewDelegate {

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
