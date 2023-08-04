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

    @IBOutlet private weak var mainScrollView: UIScrollView!
    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var categoriesCollectionView: UICollectionView!
    @IBOutlet private weak var categoriesHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var foodsCollectionView: UICollectionView!
    @IBOutlet private weak var foodSearchBar: CustomSearchBar!

    var selectedIndexPath: IndexPath?
    var viewModel: FoodListViewModel?
    private var hasSearched = false
    private var isFavorites = false
    private var cursor: QueryDocumentSnapshot?
    private var dataMayContinue = true

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

        mainScrollView.contentInsetAdjustmentBehavior = .never

        DispatchQueue.main.async {
            self.categoriesCollectionView.reloadData(completion: {
                self.viewDidLayoutSubviews()
            })
        }

        getFoods()

        addKeyboardSettings()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        FirebaseAnalytics.shared.trackScreenView(className: self.className)
    }

    override func viewDidLayoutSubviews() {
        contentViewHeightConstraint.constant = headerView.bounds.height
            + categoriesHeightConstraint.constant
            + foodsCollectionView.contentSize.height
            + .bottomSpace
            + 150
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    func getFoods(isFavorites: Bool = false) {
        self.isFavorites = isFavorites
        hasSearched = false
        if !isFavorites, let categorySelected = viewModel?.categorySelected {
            let category = FoodCategory.allValues[categorySelected].id
            FirestoreService.shared.database.collection("foods")
                .whereField("category", isEqualTo: category)
                .order(by: "name")
                .limit(to: Int.paginationSize)
                .getDocuments() { querySnapshot, error in
                    self.convertFoodsData(querySnapshot, error)
                }
        } else if isFavorites {
            if AuthService.shared.hasFavoriteFoods {
                FirestoreService.shared.database.collection("foods")
                    .whereField("id", in: UserDefaultsService.favoriteFoods.compactMap { $0 })
                    .order(by: "name")
                    .limit(to: Int.paginationSize)
                    .getDocuments() { querySnapshot, error in
                        self.convertFoodsData(querySnapshot, error)
                    }
            } else {
                self.viewModel?.foods.removeAll()
                DispatchQueue.main.async {
                    self.foodsCollectionView.reloadData(completion: {
                        self.foodsCollectionView.contentInset = .init(top: 0, left: 0, bottom: .bottomSpace, right: 0)
                    })
                }
            }
        } else {
            FirestoreService.shared.database.collection("foods")
                .order(by: "name")
                .limit(to: Int.paginationSize)
                .getDocuments() { querySnapshot, error in
                    self.convertFoodsData(querySnapshot, error)
                }
        }
    }

    func getNextBatch(cursor: QueryDocumentSnapshot) {
        // Because scrolling to bottom will cause this method to be called in rapid succession, use a boolean flag to limit this method to one call.
        dataMayContinue = false
        if !isFavorites, let categorySelected = viewModel?.categorySelected {
            let category = FoodCategory.allValues[categorySelected].id
            FirestoreService.shared.database.collection("foods")
                .whereField("category", isEqualTo: category)
                .order(by: "name")
                .limit(to: Int.paginationSize)
                .start(afterDocument: cursor)
                .getDocuments() { querySnapshot, error in
                    self.convertFoodsData(querySnapshot, error, isNextBatch: true)
                    self.dataMayContinue = true
                }
        } else if isFavorites {
            FirestoreService.shared.database.collection("foods")
                .whereField("id", in: UserDefaultsService.favoriteFoods.compactMap { $0 })
                .order(by: "name")
                .limit(to: Int.paginationSize)
                .start(afterDocument: cursor)
                .getDocuments() { querySnapshot, error in
                    self.convertFoodsData(querySnapshot, error, isNextBatch: true)
                    self.dataMayContinue = true
                }
        } else {
            FirestoreService.shared.database.collection("foods")
                .order(by: "name")
                .limit(to: Int.paginationSize)
                .start(afterDocument: cursor)
                .getDocuments() { querySnapshot, error in
                    self.convertFoodsData(querySnapshot, error, isNextBatch: true)
                    self.dataMayContinue = true
                }
        }
    }

    func convertFoodsData(_ querySnapshot: QuerySnapshot?, _ error: Error?, isNextBatch: Bool = false) {
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            if (querySnapshot?.count ?? 0) < Int.paginationSize {
                // no need to load more
                self.cursor = nil
            } else {
                self.cursor = querySnapshot?.documents.last
            }
            if !isNextBatch {
                self.viewModel?.foods.removeAll()
            }
            for document in querySnapshot!.documents {
                self.viewModel?.foods.append(.init(data: document.data()))
            }
            DispatchQueue.main.async {
                self.foodsCollectionView.reloadData(completion: {
                    self.foodsCollectionView.contentInset = .init(top: 0, left: 0, bottom: .bottomSpace, right: 0)
                    self.viewDidLayoutSubviews()
                })
            }
        }
    }

}

extension FoodListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return FoodCategory.allValues.count
        } else {
            return viewModel?.visibleFoods.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell",
                                                                for: indexPath) as? CategoryCollectionViewCell
                else { return UICollectionViewCell() }
            let foodCategory = FoodCategory.allValues[indexPath.row]
            cell.configureWithFoodCategory(.init(foodCategory: foodCategory, isFavorites: indexPath.row == 0),
                                           isSelected: viewModel?.categorySelected == indexPath.row)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortFoodCollectionViewCell",
                                                                for: indexPath) as? ShortFoodCollectionViewCell,
                  let food = viewModel?.visibleFoods[indexPath.row]
                else { return UICollectionViewCell() }
            cell.configureWith(.init(shortFood: food.asShortFood, food: food), imageCornerRadius: 157/2)
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
            label.font = .boldFontOf(size: 16)
            label.text = categoryName
            let width = label.intrinsicContentSize.width + 55
            return CGSize(width: width, height: CategoryCollectionViewCell.defaultHeight)
        } else {
            let cellsWidth = CGFloat(collectionView.bounds.width * CGFloat.foodCellsSpacePercentage)
            let width = cellsWidth / 2
            let height = width * ShortFoodCollectionViewCell.heightWidthRatio
            return CGSize(width: width, height: height)
        }
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 0 {
            return .init(top: 10, left: 10, bottom: 10, right: 10)
        } else {
            let cellsWidth = CGFloat(collectionView.bounds.width * CGFloat.foodCellsSpacePercentage)
            let inset = CGFloat(collectionView.bounds.width - cellsWidth) / 3
            return .init(top: 20, left: inset, bottom: 20, right: inset)
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
            if indexPath.row != 0 || RevenueCatService.shared.hasUnlockedPro {
                foodSearchBar.text = nil
                let currentCategory = viewModel?.categorySelected
                viewModel?.categorySelected = currentCategory == indexPath.row ? nil : indexPath.row
                DispatchQueue.main.async {
                    self.categoriesCollectionView.reloadData()
                }
                self.getFoods(isFavorites: viewModel?.categorySelected != nil ? indexPath.row == 0 : false)
            } else {
                NavigationService.openLoginOrSubscription()
            }
        } else {
            guard let food = viewModel?.visibleFoods[indexPath.row], let id = food.id
                else { return }
            if food.isFree || RevenueCatService.shared.hasUnlockedPro {
                let foodController = NavigationService.foodViewController(
                    foodId: id, food: food,
                    cellFavoriteImageView: (collectionView.cellForItem(at: indexPath) as? ShortFoodCollectionViewCell)?.publicFavoriteImageView)
                self.selectedIndexPath = indexPath
                NavigationService.push(viewController: foodController)
            } else {
                NavigationService.openLoginOrSubscription()
            }
        }
    }

}

extension FoodListViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getFoods()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty ?? true && hasSearched {
            getFoods()
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text?.capitalized
            else { return }
        if !keyword.isEmpty {
            searchKeyword(keyword)
        } else if hasSearched {
            getFoods()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        guard let keyword = searchBar.text?.capitalized
            else { return }
        if !keyword.isEmpty {
            searchKeyword(keyword)
        } else if hasSearched {
            getFoods()
        }
    }

    func searchKeyword(_ keyword: String) {
        hasSearched = true
        FirestoreService.shared.database.collection("foods")
            .whereField("name", isEqualTo: keyword)
            .getDocuments() { querySnapshot, error in
                if !querySnapshot!.documents.isEmpty {
                    self.convertFoodsData(querySnapshot, error)
                } else {
                    FirestoreService.shared.database.collection("foods")
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
        if scrollView == self.mainScrollView {
            let contentSize = scrollView.contentSize.height
            if contentSize - scrollView.contentOffset.y <= scrollView.bounds.height {
                didScrollToBottom()
            }

            let offset = scrollView.contentOffset.y
            var headerTransform = CATransform3DIdentity

            if offset < 0 {
                // PULL DOWN -----------------
                let headerScaleFactor: CGFloat = -(offset) / headerView.bounds.height
                let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height)/2.0
                headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
                headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 90)
            } else {
                // SCROLL UP/DOWN ------------
                headerTransform = CATransform3DTranslate(headerTransform, 0, -offset, 0)
            }

            headerView.layer.transform = headerTransform
        }
    }

    func didScrollToBottom() {
        if dataMayContinue, let cursor = cursor {
            getNextBatch(cursor: cursor)
        }
    }

}

extension FoodListViewController : ZoomingViewController {

    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return nil
    }

    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        if let indexPath = selectedIndexPath, let cell = foodsCollectionView?.cellForItem(at: indexPath) as? ShortFoodCollectionViewCell {
            return cell.publicImageView
        } else {
            return nil
        }
    }

}
