//
//  NotificationCenter+Extension.swift
//  weaning
//
//  Created by Yuri Cavallin on 20/3/23.
//

import Foundation

extension NotificationCenter {

    func setUniqueObserver(_ observer: AnyObject, selector: Selector, name: NSNotification.Name, object: AnyObject?) {
        NotificationCenter.default.removeObserver(observer, name: name, object: object)
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
    }

}
