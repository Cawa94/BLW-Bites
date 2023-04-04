//
//  FoodViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FoodViewController: UIViewController {

    @IBOutlet private weak var mainScrollView: UIScrollView!
    @IBOutlet private weak var mainTableView: ContentSizedTableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var foodNameLabel: UILabel!
    @IBOutlet private weak var navigationView: UIView!
    @IBOutlet private weak var backNavigationView: UIView!
    @IBOutlet private weak var foodImageView: UIImageView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!

    var viewModel: FoodViewModel?

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
        mainTableView.register(UINib(nibName: "FoodTitleTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "FoodTitleTableViewCell")
        mainTableView.register(UINib(nibName: "FoodSectionTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "FoodSectionTableViewCell")
        mainTableView.register(UINib(nibName: "FoodMonthsSectionTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "FoodMonthsSectionTableViewCell")
        mainTableView.register(UINib(nibName: "SeparatorTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "SeparatorTableViewCell")

        backNavigationView.roundCornersSimplified(cornerRadius: backNavigationView.bounds.height/2)

        FirestoreService.shared.database.document("foods/\(viewModel?.foodId ?? "")").getDocument(as: Food.self) { result in
            switch result {
            case .success(let food):
                self.viewModel?.food = food
                self.configurePage()
            case .failure(let error):
                print("Error decoding food: \(error)")
            }
        }
    }

    func configurePage() {
        guard let food = viewModel?.food
            else { return }
        foodNameLabel.text = food.name

        guard let image = food.image
            else { return }
        let reference = StorageService.shared.getReferenceFor(path: image)
        foodImageView.sd_setImage(with: reference, placeholderImage: nil)

        DispatchQueue.main.async {
            self.mainTableView.reloadData(completion: {
                self.mainTableView.invalidateIntrinsicContentSize()
                self.mainTableView.layoutIfNeeded()
                self.viewDidLayoutSubviews()
            })
        }
    }

    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = mainTableView.contentSize.height
        contentViewHeightConstraint.constant = imageViewHeightConstraint.constant + tableViewHeightConstraint.constant
        mainTableView.roundCorners(corners: [.topRight, .topLeft], cornerRadius: 45)
    }

    @IBAction func dimissPage() {
        NavigationService.popViewController()
    }

}

extension FoodViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 1
        if viewModel?.food?.hasAgeDictionary ?? false {
            numberOfSections += 1
        }
        if viewModel?.food?.hasInfosDictionary ?? false {
            numberOfSections += 1
        }
        if viewModel?.food?.hasRecipes ?? false {
            numberOfSections += 1
        }
        return numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if viewModel?.food?.hasAgeDictionary ?? false {
                return 2
            } else if viewModel?.food?.hasInfosDictionary ?? false {
                return (viewModel?.food?.infoSections.count ?? 0) + 1
            } else {
                return 2
            }
        case 2:
            if viewModel?.food?.hasInfosDictionary ?? false {
                return (viewModel?.food?.infoSections.count ?? 0) + 1
            } else {
                return 2
            }
        case 3:
            return 2
        default:
            return 0
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FoodTitleTableViewCell", for: indexPath)
                as? FoodTitleTableViewCell, let food = viewModel?.food {
                cell.configureWith(food)
                return cell
            } else {
                return UITableViewCell()
            }
        case 1:
            if viewModel?.food?.hasAgeDictionary ?? false {
                return ageSectionTableViewCell(tableView, cellForRowAt: indexPath)
            } else if viewModel?.food?.hasInfosDictionary ?? false {
                return infoSectionTableViewCell(tableView, cellForRowAt: indexPath)
            } else {
                return recipesSection(tableView, cellForRowAt: indexPath)
            }
        case 2:
            if viewModel?.food?.hasInfosDictionary ?? false {
                return infoSectionTableViewCell(tableView, cellForRowAt: indexPath)
            } else {
                return recipesSection(tableView, cellForRowAt: indexPath)
            }
        case 3:
            return recipesSection(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }

    func ageSectionTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SeparatorTableViewCell", for: indexPath)
                as? SeparatorTableViewCell {
                cell.configureWith(50)
                return cell
            } else {
                return UITableViewCell()
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FoodMonthsSectionTableViewCell", for: indexPath)
                as? FoodMonthsSectionTableViewCell, let food = viewModel?.food {
                cell.configureWith(food: food, delegate: self)
                return cell
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }

    func infoSectionTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SeparatorTableViewCell", for: indexPath)
                as? SeparatorTableViewCell {
                cell.configureWith(50)
                return cell
            } else {
                return UITableViewCell()
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FoodSectionTableViewCell", for: indexPath)
                as? FoodSectionTableViewCell, let food = viewModel?.food {
                cell.configureWith(infoSection: food.infoSections[indexPath.row - 1], delegate: self)
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }

    func recipesSection(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SeparatorTableViewCell", for: indexPath)
                as? SeparatorTableViewCell {
                cell.configureWith(50)
                return cell
            } else {
                return UITableViewCell()
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FoodRecipesTableViewCell", for: indexPath)
                as? FoodRecipesTableViewCell, let recipes = viewModel?.food?.recipes {
                cell.configureWith(shortRecipes: recipes)
                return cell
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }

}

extension FoodViewController: FoodMonthsSectionDelegate, FoodSectionDelegate {

    func updatedSegment() {
        UIView.performWithoutAnimation {
            self.mainTableView.beginUpdates()
            self.mainTableView.endUpdates()
        }
    }

    func toggleContent() {
        self.mainTableView.beginUpdates()
        self.mainTableView.endUpdates()
    }

}

extension FoodViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity
        let blockProfileImageY = CGFloat(160)

        if offset < 0 {
            // PULL DOWN -----------------
            let headerScaleFactor: CGFloat = -(offset) / headerView.bounds.height
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor))
                - headerView.bounds.height)/2.0

            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 90)
        } else {
            // SCROLL UP/DOWN ------------
            // headerTransform = CATransform3DTranslate(headerTransform, 0, max(-blockProfileImageY, -offset), 0)
        }

        if offset >= blockProfileImageY { // after top bar blocked, start showing label
            navigationView.alpha = min (1.0, (offset - blockProfileImageY)/50)
        } else {
            navigationView?.alpha = 0.0
        }
        headerView.layer.transform = headerTransform
    }

}
