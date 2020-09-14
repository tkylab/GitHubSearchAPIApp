//
//  UITableViewExtensions.swift
//  GitHubSearchAPIApp
//
//  Created by thiratani on 2020/09/12.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func ts_deselectedCell() {
        if let indexPathForSelectedRow = self.indexPathForSelectedRow {
            self.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
}
