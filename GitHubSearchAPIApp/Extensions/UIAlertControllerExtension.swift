//
//  UIAlertControllerExtension.swift
//  GitHubSearchAPIApp
//
//  Created by thiratani on 2020/09/12.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {

    class func singleBtnAlertWithTitle(title: String, message: String, actionTitle: String, completion: (() -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction!) -> Void in
            if let completion = completion {
                completion()
            }
        }))
        return alert
    }

    class func singleBtnAlertWithTitle(title: String, message: String, completion: (() -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES".localized, style: .default, handler: { (action:UIAlertAction!) -> Void in
            if let completion = completion {
                completion()
            }
        }))
        return alert
    }

    class func doubleBtnAlertWithTitle(title: String, message: String, btnTitle: String, completion: (() -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: btnTitle, style: .default, handler: { (action:UIAlertAction!) -> Void in
            if let completion = completion {
                completion()
            }
        }))
        alert.addAction(UIAlertAction(title: "NO".localized, style: .cancel, handler: nil))
        return alert
    }
}
