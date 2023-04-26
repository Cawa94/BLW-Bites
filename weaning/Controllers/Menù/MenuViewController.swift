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
    @IBOutlet private weak var menuNameLabel: UILabel!
    @IBOutlet private weak var navigationView: UIView!
    @IBOutlet private weak var backNavigationView: UIView!
    @IBOutlet private weak var menuImageView: UIImageView!
    @IBOutlet private weak var instructionTextView: UITextView!
    @IBOutlet private weak var instructionTextViewHeightconstraint: NSLayoutConstraint!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!

    private var freeMenuDays = 3

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

        menuNameLabel.text = viewModel?.menuName
        // backNavigationView.roundCornersSimplified(cornerRadius: backNavigationView.bounds.height/2)

        FirestoreService.shared.database
            .collection("menus")
            .document("30_days")
            .collection("menu")
            .getDocuments() { querySnapshot, error in
                self.convertMenuData(querySnapshot, error)
            }
    }

    func convertMenuData(_ querySnapshot: QuerySnapshot?, _ error: Error?) {
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            for document in querySnapshot!.documents {
                self.viewModel?.menuDays?.append(.init(data: document.data()))
            }
            DispatchQueue.main.async {
                self.daysCollectionView.reloadData()
                self.mainTableView.reloadData(completion: {
                    self.mainTableView.invalidateIntrinsicContentSize()
                    self.mainTableView.layoutIfNeeded()
                    self.viewDidLayoutSubviews()
                })
            }
        }
    }

    override func viewDidLayoutSubviews() {
        instructionTextViewHeightconstraint.constant = instructionTextView.contentSize.height
        tableViewHeightConstraint.constant = mainTableView.contentSize.height
        contentViewHeightConstraint.constant = imageViewHeightConstraint.constant
            + collectionViewHeightConstraint.constant
            + tableViewHeightConstraint.constant
            + 20
            + instructionTextViewHeightconstraint.constant
        daysCollectionViewBackground.roundCorners(corners: [.topRight, .topLeft], cornerRadius: 45)
        mainTableView.roundCorners(corners: [.topRight, .topLeft], cornerRadius: 45)
    }

    @IBAction func dimissPage() {
        NavigationService.popViewController()
    }

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard !(viewModel?.menuDays?.isEmpty ?? true)
            else { return 0 }
        return viewModel?.menuDays?[viewModel?.selectedRow ?? 0].mealsCount ?? 0
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
            as? MenuMealTableViewCell, let meal = viewModel?.menuDays?[viewModel?.selectedRow ?? 0].meals[indexPath.section] {
            cell.configureWith(.init(title: meal.category ?? "",
                                     dishes: meal.dishes ?? []))
            return cell
        } else {
            return UITableViewCell()
        }
    }

}

extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.menuDays?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCollectionViewCell",
                                                            for: indexPath) as? DayCollectionViewCell
            else { return UICollectionViewCell() }
        cell.configureWithDay("\(indexPath.row + 1)",
                              isSelected: viewModel?.selectedRow == indexPath.row,
                              isPremium: indexPath.row >= freeMenuDays)
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
        if PurchaseManager.shared.hasUnlockedPro || indexPath.row < freeMenuDays {
            viewModel?.selectedRow = indexPath.row
            
            DispatchQueue.main.async {
                self.daysCollectionView.reloadData()
                self.mainTableView.reloadData(completion: {
                    self.mainTableView.invalidateIntrinsicContentSize()
                    self.mainTableView.layoutIfNeeded()
                    self.viewDidLayoutSubviews()
                })
            }
        } else {
            NavigationService.present(viewController: NavigationService.subscriptionViewController())
        }
    }

}
