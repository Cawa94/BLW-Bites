//
//  ViewController+Extension.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import UIKit

public extension UIViewController {

    class var xibName: String {
        return String(describing: self)
    }

    @objc var internalScrollView: UIScrollView {
        UIScrollView()
    }

    @objc var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last ?? ""
    }

    /// Return top visible controller even if we have inner UI(Navigation/TabBar)Controller's inside
    var topVisibleViewController: UIViewController {
        switch self {
        case let navController as UINavigationController:
            return navController.visibleViewController?.topVisibleViewController ?? navController
        case let tabController as UITabBarController:
            return tabController.selectedViewController?.topVisibleViewController ?? tabController
        default:
            return self.presentedViewController?.topVisibleViewController ?? self
        }
    }

    func embedInNavigationController() -> UINavigationController {
        let navController = UINavigationController(rootViewController: self)
        let appearance = UINavigationBarAppearance()
        /*
        navController.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "common_navigation_back")
        navController.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "common_navigation_back")

        let backgroundImage = UIImage.support
            .imageWith(color: .green, size: CGSize(width: 1, height: 1))?
            .base

        appearance.backgroundImage = backgroundImage
        appearance.shadowImage = #imageLiteral(resourceName: "navbar_shadow")*/

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldFontOf(size: 16),
            .foregroundColor: UIColor.white
        ]

        navController.navigationBar.tintColor = .white
        appearance.titleTextAttributes = attributes

        navController.isNavigationBarHidden = true

        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = navController.navigationBar.standardAppearance

        return navController
    }

    func addKeyboardSettings() {
        hideKeyboardWhenTappedAround()
        scrollWhenKeyboardAppears()
    }

    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    func scrollWhenKeyboardAppears() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = internalScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        internalScrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        internalScrollView.contentInset = contentInset
    }

}
