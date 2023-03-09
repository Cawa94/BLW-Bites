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
        mainTableView.register(UINib(nibName: "HomepageHeaderTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "HomepageHeaderTableViewCell")
        mainTableView.register(UINib(nibName: "FavoriteDefaultTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "FavoriteDefaultTableViewCell")
        
        getHomepageFoods()
    }

    func getHomepageFoods() {
        FirestoreService.shared.database.collection("short_foods").limit(to: 5).getDocuments() { querySnapshot, error in
            self.convertFoodsData(querySnapshot, error)
        }
    }

    func getHomepageRecipes() {
        FirestoreService.shared.database.collection("short_recipes").limit(to: 5).getDocuments() { querySnapshot, error in
            self.convertRecipesData(querySnapshot, error)
        }
    }

    func convertFoodsData(_ querySnapshot: QuerySnapshot?, _ error: Error?) {
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            self.viewModel?.shortFoods.removeAll()
            for document in querySnapshot!.documents {
                self.viewModel?.shortFoods.append(.init(data: document.data()))
            }
            self.getHomepageRecipes()
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
            return 2
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
                return cell
            } else {
                return UITableViewCell()
            }
        case 1:
            return favoritesDefaultSection(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }

    func favoritesDefaultSection(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteDefaultTableViewCell", for: indexPath)
            as? FavoriteDefaultTableViewCell {
            cell.configureWith(shortFoods: indexPath.row == 0 ? viewModel?.shortFoods : nil,
                               shortRecipes: indexPath.row == 1 ? viewModel?.shortRecipes : nil,
                               isFavorites: false)
            return cell
        } else {
            return UITableViewCell()
        }
    }

}
