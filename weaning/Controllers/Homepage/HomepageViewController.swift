//
//  HomepageViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 18/2/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class HomepageViewController: UIViewController {

    @IBOutlet private weak var mainScrollView: UIScrollView!
    @IBOutlet private weak var mainTableView: ContentSizedTableView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!

    var viewModel: HomepageViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        mainTableView.estimatedRowHeight = 1000
        mainTableView.rowHeight = UITableView.automaticDimension
        mainTableView.register(UINib(nibName: "HomepageHeaderTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "HomepageHeaderTableViewCell")
        mainTableView.register(UINib(nibName: "HomepageElementsTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "HomepageElementsTableViewCell")

        getHomepageFoods()
    }

    func getHomepageFoods() {
        FirestoreService.shared.database.collection("short_foods").whereField("properties", arrayContainsAny: ["free", "seasonal", "new"]).getDocuments() { querySnapshot, error in
            self.convertFoodsData(querySnapshot, error)
        }
    }

    func getHomepageRecipes() {
        FirestoreService.shared.database.collection("short_recipes").whereField("properties", arrayContainsAny: ["free", "seasonal", "new"]).getDocuments() { querySnapshot, error in
            self.convertRecipesData(querySnapshot, error)
        }
    }

    func convertFoodsData(_ querySnapshot: QuerySnapshot?, _ error: Error?) {
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            self.viewModel?.homepageFoods.removeAll()
            for document in querySnapshot!.documents {
                self.viewModel?.homepageFoods.append(.init(data: document.data()))
            }
            self.getHomepageRecipes()
        }
    }

    func convertRecipesData(_ querySnapshot: QuerySnapshot?, _ error: Error?) {
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            self.viewModel?.homepageRecipes.removeAll()
            for document in querySnapshot!.documents {
                self.viewModel?.homepageRecipes.append(.init(data: document.data()))
            }
            DispatchQueue.main.async {
                self.mainTableView.reloadData(completion: {
                    self.mainTableView.invalidateIntrinsicContentSize()
                    self.mainTableView.layoutIfNeeded()
                    self.viewDidLayoutSubviews()
                })
            }
        }
    }

    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = mainTableView.contentSize.height
        contentViewHeightConstraint.constant = tableViewHeightConstraint.constant
    }

}

extension HomepageViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 4
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomepageHeaderTableViewCell", for: indexPath)
                as? HomepageHeaderTableViewCell {
                cell.configureWith(.init(tapHandler: { NavigationService.present(viewController: NavigationService.subscriptionViewController()) }))
                return cell
            } else {
                return UITableViewCell()
            }
        case 1:
            return PurchaseManager.shared.hasUnlockedPro
                ? homepageElementsSection(tableView, cellForRowAt: indexPath)
                : freeHomepageElementsSection(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }

    func homepageElementsSection(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return newCell(tableView, cellForRowAt: indexPath)
        case 1:
            return seasonalCell(tableView, cellForRowAt: indexPath)
        case 2:
            return freeFoodCell(tableView, cellForRowAt: indexPath)
        case 3:
            return freeRecipesCell(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }

    func freeHomepageElementsSection(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return freeFoodCell(tableView, cellForRowAt: indexPath)
        case 1:
            return freeRecipesCell(tableView, cellForRowAt: indexPath)
        case 2:
            return newCell(tableView, cellForRowAt: indexPath)
        case 3:
            return seasonalCell(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }

    func seasonalCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomepageElementsTableViewCell", for: indexPath)
            as? HomepageElementsTableViewCell {
            cell.configureWith(shortFoods: viewModel?.seasonalFoods, shortRecipes: viewModel?.seasonalRecipes, title: "HOME_SEASONAL".localized())
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func newCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomepageElementsTableViewCell", for: indexPath)
            as? HomepageElementsTableViewCell {
            cell.configureWith(shortFoods: viewModel?.newFoods, shortRecipes: viewModel?.newRecipes, title: "HOME_NEW_ENTRY".localized())
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func freeFoodCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomepageElementsTableViewCell", for: indexPath)
            as? HomepageElementsTableViewCell {
            cell.configureWith(shortFoods: viewModel?.freeFoods, shortRecipes: nil, title: "HOME_FREE_FOODS".localized())
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func freeRecipesCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomepageElementsTableViewCell", for: indexPath)
            as? HomepageElementsTableViewCell {
            cell.configureWith(shortFoods: nil, shortRecipes: viewModel?.freeRecipes, title: "HOME_FREE_RECIPES".localized())
            return cell
        } else {
            return UITableViewCell()
        }
    }

}
