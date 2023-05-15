//
//  RecipeViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class RecipeViewController: UIViewController {

    @IBOutlet private weak var mainScrollView: UIScrollView!
    @IBOutlet private weak var mainTableView: ContentSizedTableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var recipeNameLabel: UILabel!
    @IBOutlet private weak var navigationView: UIView!
    @IBOutlet private weak var backNavigationView: UIView!
    @IBOutlet private weak var recipeImageView: UIImageView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var newView: UIView!
    @IBOutlet private weak var seasonalView: UIView!
    @IBOutlet private weak var favoriteView: UIView!
    @IBOutlet private weak var favoriteImageView: UIImageView!

    var viewModel: RecipeViewModel?
    private var blurEffectView: UIVisualEffectView?

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
        mainTableView.register(UINib(nibName: "RecipeTitleTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "RecipeTitleTableViewCell")
        mainTableView.register(UINib(nibName: "RecipeInfoTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "RecipeInfoTableViewCell")
        mainTableView.register(UINib(nibName: "RecipeFoodsTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "RecipeFoodsTableViewCell")
        mainTableView.register(UINib(nibName: "SeparatorTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "SeparatorTableViewCell")

        backNavigationView.roundCornersSimplified(cornerRadius: backNavigationView.bounds.height/2)
        favoriteView.roundCornersSimplified(cornerRadius: .smallCornerRadius)
        newView.roundCornersSimplified(cornerRadius: newView.frame.height/2, borderWidth: 1, borderColor: .white)
        seasonalView.roundCornersSimplified(cornerRadius: .smallCornerRadius, borderWidth: 1, borderColor: .white)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        FirestoreService.shared.database.document("recipes/\(viewModel?.recipeId ?? "")").getDocument(as: Recipe.self) { result in
            switch result {
            case .success(let recipe):
                self.viewModel?.recipe = recipe
                self.configurePage()
            case .failure(let error):
                print("Error decoding recipe: \(error)")
            }
        }
    }

    func configurePage() {
        DispatchQueue.main.async {
            self.mainTableView.reloadData(completion: {
                self.mainTableView.invalidateIntrinsicContentSize()
                self.mainTableView.layoutIfNeeded()
                self.viewDidLayoutSubviews()
            })
        }

        recipeNameLabel.text = viewModel?.recipe?.name
        newView.isHidden = !(viewModel?.recipe?.isNew ?? false)
        seasonalView.isHidden = !(viewModel?.recipe?.isSeasonal ?? false)

        guard let image = viewModel?.recipe?.image, !image.isEmpty
            else { return }
        let reference = StorageService.shared.getReferenceFor(path: image)
        recipeImageView.sd_setImage(with: reference, placeholderImage: nil)
    }

    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = mainTableView.contentSize.height
        contentViewHeightConstraint.constant = imageViewHeightConstraint.constant + tableViewHeightConstraint.constant + .bottomSpace
        mainTableView.roundCorners(corners: [.topRight, .topLeft], cornerRadius: 45)
    }

    @IBAction func dimissPage() {
        NavigationService.popViewController()
    }

    @IBAction func toggleFavorite() {
        favoriteImageView.image = .init(named: "heart_full")
        favoriteImageView.bounce()
    }

}

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 1
        if viewModel?.recipe?.hasIngredients ?? false {
            numberOfSections += 1
        }
        if viewModel?.recipe?.hasSteps ?? false {
            numberOfSections += 1
        }
        if viewModel?.recipe?.hasTips ?? false {
            numberOfSections += 1
        }
        if viewModel?.recipe?.hasFoods ?? false {
            numberOfSections += 1
        }
        return numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel?.recipe?.hasDescription ?? false ? 2 : 1
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTitleTableViewCell", for: indexPath)
                as? RecipeTitleTableViewCell, let recipe = viewModel?.recipe {
                cell.configureWith(recipe)
                return cell
            } else {
                return UITableViewCell()
            }
        case 1:
            if viewModel?.recipe?.hasIngredients ?? false {
                return ingredientsSection(tableView, cellForRowAt: indexPath, showSeparator: viewModel?.recipe?.hasDescription ?? false)
            } else if viewModel?.recipe?.hasSteps ?? false {
                return stepsSection(tableView, cellForRowAt: indexPath, showSeparator: viewModel?.recipe?.hasDescription ?? false)
            } else if viewModel?.recipe?.hasTips ?? false {
                return tipsSection(tableView, cellForRowAt: indexPath, showSeparator: viewModel?.recipe?.hasDescription ?? false)
            } else {
                return foodsSection(tableView, cellForRowAt: indexPath, showSeparator: viewModel?.recipe?.hasDescription ?? false)
            }
        case 2:
            if viewModel?.recipe?.hasSteps ?? false {
                return stepsSection(tableView, cellForRowAt: indexPath)
            } else if viewModel?.recipe?.hasTips ?? false {
                return tipsSection(tableView, cellForRowAt: indexPath)
            } else {
                return foodsSection(tableView, cellForRowAt: indexPath)
            }
        case 3:
            if viewModel?.recipe?.hasTips ?? false {
                return tipsSection(tableView, cellForRowAt: indexPath)
            } else {
                return foodsSection(tableView, cellForRowAt: indexPath)
            }
        case 4:
            return foodsSection(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }

    func ingredientsSection(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, showSeparator: Bool = true) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SeparatorTableViewCell", for: indexPath)
                as? SeparatorTableViewCell, showSeparator {
                cell.configureWith(50)
                return cell
            } else if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeInfoTableViewCell", for: indexPath)
                as? RecipeInfoTableViewCell, let recipe = viewModel?.recipe {
                cell.configureWith(title: recipe.ingredientsTitle ?? "RECIPE_INGREDIENTS".localized(), text: recipe.ingredientsDescription)
                return cell
            } else {
                return UITableViewCell()
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeInfoTableViewCell", for: indexPath)
                as? RecipeInfoTableViewCell, let recipe = viewModel?.recipe {
                cell.configureWith(title: recipe.ingredientsTitle ?? "RECIPE_INGREDIENTS".localized(), text: recipe.ingredientsDescription)
                return cell
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }

    func stepsSection(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, showSeparator: Bool = true) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SeparatorTableViewCell", for: indexPath)
                as? SeparatorTableViewCell, showSeparator {
                cell.configureWith(50)
                return cell
            } else if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeInfoTableViewCell", for: indexPath)
                as? RecipeInfoTableViewCell, let recipe = viewModel?.recipe {
                cell.configureWith(title: "RECIPE_PREPARATION".localized(), text: recipe.stepsDescription)
                return cell
            } else {
                return UITableViewCell()
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeInfoTableViewCell", for: indexPath)
                as? RecipeInfoTableViewCell, let recipe = viewModel?.recipe {
                cell.configureWith(title: "RECIPE_PREPARATION".localized(), text: recipe.stepsDescription)
                return cell
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }

    func tipsSection(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, showSeparator: Bool = true) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SeparatorTableViewCell", for: indexPath)
                as? SeparatorTableViewCell, showSeparator {
                cell.configureWith(50)
                return cell
            } else if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeInfoTableViewCell", for: indexPath)
                as? RecipeInfoTableViewCell, let tips = viewModel?.recipe?.tips {
                cell.configureWith(title: "Tips", text: tips)
                return cell
            } else {
                return UITableViewCell()
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeInfoTableViewCell", for: indexPath)
                as? RecipeInfoTableViewCell, let tips = viewModel?.recipe?.tips {
                cell.configureWith(title: "Tips", text: tips)
                return cell
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }

    func foodsSection(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, showSeparator: Bool = true) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SeparatorTableViewCell", for: indexPath)
                as? SeparatorTableViewCell, showSeparator {
                cell.configureWith(50)
                return cell
            } else if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeFoodsTableViewCell", for: indexPath)
                as? RecipeFoodsTableViewCell, let foods = viewModel?.recipe?.foods {
                cell.configureWith(shortFoods: foods)
                return cell
            } else {
                return UITableViewCell()
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeFoodsTableViewCell", for: indexPath)
                as? RecipeFoodsTableViewCell, let foods = viewModel?.recipe?.foods {
                cell.configureWith(shortFoods: foods)
                return cell
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }

}

extension RecipeViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity
        let blockProfileImageY = CGFloat(imageViewHeightConstraint.constant - 59)

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

extension RecipeViewController : ZoomingViewController {

    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return nil
    }

    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        return recipeImageView
    }

}
