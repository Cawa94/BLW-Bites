//
//  MenuSelectorViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import UIKit

class MenuSelectorViewController: UIViewController {

    @IBOutlet private weak var mainScrollView: UIScrollView!
    @IBOutlet private weak var mainTableView: ContentSizedTableView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.estimatedRowHeight = 1000
        mainTableView.rowHeight = UITableView.automaticDimension
        
        mainTableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "TitleTableViewCell")
        mainTableView.register(UINib(nibName: "MenuSelectorTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "MenuSelectorTableViewCell")
        
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
        contentViewHeightConstraint.constant = tableViewHeightConstraint.constant
    }

}


extension MenuSelectorViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath)
                as? TitleTableViewCell {
                cell.configureWith("MENU_SELECTOR_TITLE".localized())
                return cell
            } else {
                return UITableViewCell()
            }
        case 1:
            return menusSection(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }

    func menusSection(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuSelectorTableViewCell", for: indexPath)
                as? MenuSelectorTableViewCell {
                let viewModel = MenuSelectorTableViewModel.init(image: "30_days_icon",
                                                                title: "MENU_30_DAYS".localized(),
                                                                subtitle: "MENU_30_DAYS_DESCRIPTION".localized(),
                                                                isPremium: false,
                                                                tapHandler: {
                    self.openMenuWith(id: "30_days", name: "MENU_30_DAYS".localized(), isPremium: false)
                })
                cell.configureWith(viewModel)
                return cell
            } else {
                return UITableViewCell()
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuSelectorTableViewCell", for: indexPath)
                as? MenuSelectorTableViewCell {
                let viewModel = MenuSelectorTableViewModel.init(image: "7-12_months_icon",
                                                                title: "MENU_7-12_MONTHS".localized(),
                                                                subtitle: "MENU_7-12_MONTHS_DESCRIPTION".localized(),
                                                                isPremium: true,
                                                                tapHandler: {
                    self.openMenuWith(id: "7_12_even", name: "MENU_7-12_MONTHS".localized(), isPremium: true)
                })
                cell.configureWith(viewModel)
                return cell
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }

    func openMenuWith(id: String, name: String, isPremium: Bool) {
        if PurchaseManager.shared.hasUnlockedPro || !isPremium {
            NavigationService.push(viewController: NavigationService.menuViewController(menuId: id,
                                                                                        menuName: name))
        } else {
            NavigationService.present(viewController: NavigationService.subscriptionViewController())
        }
    }

}
