//
//  UICollectionView+Extension.swift
//  weaning
//
//  Created by Yuri Cavallin on 28/2/23.
//

import UIKit

extension UICollectionView {

    func reloadData(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() }) { _ in
            completion()
        }
    }

}
