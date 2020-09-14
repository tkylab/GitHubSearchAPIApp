//
//  SearchView.swift
//  GitHubSearchAPIApp
//
//  Created by thiratani on 2020/09/14.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit

class SearchView : UIView {

    var tableView: UITableView!
    var activityIndicatorView: UIActivityIndicatorView!
    var textLabel: UILabel!
        
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }

    func setup() {
        setupTableView()
        setupTextLabel()
        setupActivityIndicatory()
    }
    
    func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        addSubview(tableView)
    }

    func setupActivityIndicatory() {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        backView.backgroundColor = UIColor.white
        activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicatorView.color = UIColor.darkGray
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.center = backView.center
        backView.addSubview(activityIndicatorView)
        addSubview(activityIndicatorView)
    }

    func setupTextLabel() {
        textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        textLabel.textAlignment = .center
        textLabel.center = self.center
        textLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        addSubview(textLabel)
    }

    func displayView(isTableView: Bool, isTextLabel: Bool, isActivityIndicatorView: Bool) {
        tableView.isHidden = !isTableView
        textLabel.isHidden = !isTextLabel
        activityIndicatorView.isHidden = !isActivityIndicatorView
    }
    
}
