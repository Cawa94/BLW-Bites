//
//  MenuViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/3/23.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet private weak var mainScrollView: UIScrollView!
    @IBOutlet private weak var mainTableView: ContentSizedTableView!
    @IBOutlet private weak var daysCollectionView: UICollectionView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var menuNameLabel: UILabel!
    @IBOutlet private weak var navigationView: UIView!
    @IBOutlet private weak var backNavigationView: UIView!
    @IBOutlet private weak var menuImageView: UIImageView!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!

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
        mainTableView.register(UINib(nibName: "RecipeTitleTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "RecipeTitleTableViewCell")
        mainTableView.register(UINib(nibName: "RecipeInfoTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "RecipeInfoTableViewCell")
        mainTableView.register(UINib(nibName: "RecipeFoodsTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "RecipeFoodsTableViewCell")
        mainTableView.register(UINib(nibName: "SeparatorTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "SeparatorTableViewCell")

        daysCollectionView.register(UINib(nibName:"DayCollectionViewCell", bundle: nil),
                                    forCellWithReuseIdentifier:"DayCollectionViewCell")

        DispatchQueue.main.async {
            self.daysCollectionView.reloadData()
        }

        // backNavigationView.roundCornersSimplified(cornerRadius: backNavigationView.bounds.height/2)

        FirestoreService.shared.database.document("recipes/\(viewModel?.menuId ?? "")").getDocument(as: Recipe.self) { result in
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
        guard let recipe = viewModel?.recipe
            else { return }
        menuNameLabel.text = recipe.name

        guard let image = recipe.image
            else { return }
        let reference = StorageService.shared.getReferenceFor(path: image)
        menuImageView.sd_setImage(with: reference, placeholderImage: nil)

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
        contentViewHeightConstraint.constant = imageViewHeightConstraint.constant
            + collectionViewHeightConstraint.constant
            + tableViewHeightConstraint.constant
        daysCollectionView.roundCornersSimplified(cornerRadius: 45)
        mainTableView.roundCorners(corners: [.topRight, .topLeft], cornerRadius: 45)
    }

    @IBAction func dimissPage() {
        NavigationService.popViewController()
    }

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        1
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
        return UITableViewCell()
    }

}

extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCollectionViewCell",
                                                            for: indexPath) as? DayCollectionViewCell
            else { return UICollectionViewCell() }
        cell.configureWithDay("\(indexPath.row + 1)", isSelected: viewModel?.selectedRow == indexPath.row)
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
        return CGSize(width: 50, height: DayCollectionViewCell.defaultHeight)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 30, bottom: 20, right: 30)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.selectedRow = indexPath.row

        DispatchQueue.main.async {
            self.daysCollectionView.reloadData()
        }
    }

}
