//
//  MenuViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/3/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class MenuViewController: UIViewController {

    @IBOutlet private weak var mainScrollView: UIScrollView!
    @IBOutlet private weak var mainTableView: ContentSizedTableView!
    @IBOutlet private weak var daysCollectionView: UICollectionView!
    @IBOutlet private weak var daysCollectionViewBackground: UIView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var navigationView: UIView!
    @IBOutlet private weak var navigationTitleLabel: UILabel!
    @IBOutlet private weak var backNavigationView: UIView!
    @IBOutlet private weak var menuImageView: UIImageView!
    @IBOutlet private weak var instructionTextView: UITextView!
    @IBOutlet private weak var instructionTextViewHeightconstraint: NSLayoutConstraint!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!

    var selectedCellIndexPath: IndexPath?
    var selectedStackViewDishTag: Int?
    var viewModel: MenuViewModel?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainTableView.estimatedRowHeight = 1000
        mainTableView.rowHeight = UITableView.automaticDimension
        mainTableView.register(UINib(nibName: "MenuMealTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "MenuMealTableViewCell")
        daysCollectionView.register(UINib(nibName:"DayCollectionViewCell", bundle: nil),
                                    forCellWithReuseIdentifier:"DayCollectionViewCell")

        mainScrollView.contentInsetAdjustmentBehavior = .never

        navigationTitleLabel.text = viewModel?.menuName
        backNavigationView.roundCornersSimplified(cornerRadius: backNavigationView.bounds.height/2)
        imageViewHeightConstraint.constant = viewModel?.is30Days ?? false ? 350 : 250
        menuImageView.image = viewModel?.is30Days ?? false ? nil : .init(named: "istockphoto-488560068-1024x1024")
        instructionTextView.attributedText = (viewModel?.is30Days ?? false
                                              ? "MENU_30_DAYS_EXPLICATORY_TEXT".localized()
                                              : "MENU_7-12_MONTHS_EXPLICATORY_TEXT".localized()).htmlToAttributedString()

        getMenuDayWithId("00")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        FirebaseAnalytics.shared.trackScreenView(className: self.className)
    }

    func getMenuDayWithId(_ id: String) {
        FirestoreService.shared.database
            .collection("menus")
            .document(viewModel?.menuId ?? "")
            .collection("menu")
            .document(id).getDocument(as: MenuDay.self) { result in
            switch result {
            case .success(let menuDay):
                self.viewModel?.menuDay = menuDay
                self.configurePage()
            case .failure(let error):
                print("Error decoding food: \(error)")
            }
        }
    }

    func configurePage() {
        DispatchQueue.main.async {
            self.updateDayPicture()
            self.daysCollectionView.reloadData()
            self.mainTableView.reloadData(completion: {
                self.mainTableView.invalidateIntrinsicContentSize()
                self.mainTableView.layoutIfNeeded()
                self.viewDidLayoutSubviews()
            })
        }
    }

    func updateDayPicture(withAnimation: Bool = true) {
        guard viewModel?.is30Days ?? false, let image = viewModel?.menuDay?.dayPicture
            else { return }
        let reference = StorageService.shared.getReferenceFor(path: image)
        if withAnimation {
            self.menuImageView.sd_setImage(with: reference, placeholderImage: self.menuImageView.image, completion: { image, _, _, _ in
                UIView.transition(with: self.menuImageView,
                                  duration: 0.30,
                                  options: .transitionCrossDissolve,
                                  animations: { self.menuImageView.image = image },
                                  completion: nil)
            })
        } else {
            self.menuImageView.sd_setImage(with: reference, placeholderImage: nil)
        }
    }

    override func viewDidLayoutSubviews() {
        instructionTextViewHeightconstraint.constant = instructionTextView.contentSize.height
        tableViewHeightConstraint.constant = mainTableView.contentSize.height
        contentViewHeightConstraint.constant = imageViewHeightConstraint.constant
            + collectionViewHeightConstraint.constant
            + tableViewHeightConstraint.constant
            + instructionTextViewHeightconstraint.constant
            + .bottomSpace
            + 180
        daysCollectionViewBackground.roundCorners(corners: [.topRight, .topLeft], cornerRadius: 45)
    }

    @IBAction func dimissPage() {
        NavigationService.popViewController()
    }

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard !(viewModel?.menuDay == nil)
            else { return 0 }
        return viewModel?.menuDay?.mealsCount ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuMealTableViewCell", for: indexPath)
            as? MenuMealTableViewCell, let meal = viewModel?.menuDay?.meals[indexPath.section] {
            cell.configureWith(.init(title: meal.category ?? "",
                                     dishes: meal.dishes ?? [],
                                     indexPath: indexPath,
                                     delegate: self))
            return cell
        } else {
            return UITableViewCell()
        }
    }

}

extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        (viewModel?.is30Days ?? false) ? 30 : 14
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCollectionViewCell",
                                                            for: indexPath) as? DayCollectionViewCell
            else { return UICollectionViewCell() }
        cell.configureWithDay("\(indexPath.row + 1)",
                              isSelected: viewModel?.selectedRow == indexPath.row,
                              isPremium: indexPath.row >= .menuFreeDays)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: DayCollectionViewCell.defaultHeight,
                      height: DayCollectionViewCell.defaultHeight)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 20, left: 30, bottom: 20, right: 30)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if RevenueCatService.shared.hasUnlockedPro || indexPath.row < .menuFreeDays {
            viewModel?.selectedRow = indexPath.row

            let menuDayId = indexPath.row < 10 ? "0\(indexPath.row)" : "\(indexPath.row)"
            self.getMenuDayWithId(menuDayId)
        } else {
            NavigationService.openLoginOrSubscription()
        }
    }

}

extension MenuViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if scrollView.contentOffset.y != 0 {
            let startShowingHeader = CGFloat(160)
            var headerTransform = CATransform3DIdentity
            
            if offset < 0 {
                // PULL DOWN -----------------
                let headerScaleFactor: CGFloat = -(offset) / headerView.bounds.height
                let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor))
                                           - headerView.bounds.height)/2.0
                
                headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
                headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 90)
            }
            
            if offset >= startShowingHeader { // after top bar blocked, start showing label
                navigationView.alpha = min (1.0, (offset - startShowingHeader)/50)
            } else {
                navigationView?.alpha = 0.0
            }
            headerView.layer.transform = headerTransform
        }
    }

}

extension MenuViewController: MenuMealDelegate {

    func selectedElement(foodId: String?, recipeId: String?, cellIndexPath: IndexPath, stackViewDishTag: Int) {
        self.selectedStackViewDishTag = stackViewDishTag
        self.selectedCellIndexPath = cellIndexPath
        if let foodId = foodId {
            let foodController = NavigationService.foodViewController(foodId: foodId, food: nil)
            NavigationService.push(viewController: foodController)
        } else if let recipeId = recipeId {
            let recipeController = NavigationService.recipeViewController(recipeId: recipeId, recipe: nil)
            NavigationService.push(viewController: recipeController)
        }
    }

}

extension MenuViewController: ZoomingViewController {

    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return nil
    }

    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        if let selectedCellIndexPath = selectedCellIndexPath,
           let elementsCell = mainTableView?.cellForRow(at: selectedCellIndexPath) as? MenuMealTableViewCell,
           let selectedStackViewDishTag = selectedStackViewDishTag {
            if let dishView = elementsCell.publicStackView.subviews.first(where: { $0.tag == selectedStackViewDishTag }) as? MenuDishView {
                return dishView.publicImageView
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

}
