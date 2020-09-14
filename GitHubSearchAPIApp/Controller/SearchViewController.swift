//
//  SearchViewController.swift
//  GitHubSearchAPIApp
//
//  Created by thiratani on 2020/09/12.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchViewController: UIViewController {
    
    var textView = UITextView()
    var tableView = UITableView()
    var searchBar = UISearchBar()
    var activityIndicatorView = UIActivityIndicatorView()
    var searchResults = [SearchResult]()

    var searchView: SearchView!

    override func loadView() {
        super.loadView()
        searchView = SearchView(frame: view.frame)
        searchView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        self.view.addSubview(searchView)
        self.view.backgroundColor = UIColor.white
    }
    
    required init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "SEARCH".localized
        navigationController?.navigationBar.isTranslucent = false
        extendedLayoutIncludesOpaqueBars = true

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "ENTER_SEARCH_KEYWORD".localized
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func setupTableView() {
        searchView.tableView.dataSource = self
        searchView.tableView.delegate = self
    }
}

extension SearchViewController : UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        // none
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchView.displayView(isTableView: false, isTextLabel: false, isActivityIndicatorView: true)
        searchView.activityIndicatorView.startAnimating()
        if let keyword = searchBar.text {
            let urlStr = "https://api.github.com/search/users?q=\(keyword)"
            let encodeUrlString: String = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let url = URL(string: encodeUrlString)!
            let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
                if let error = error {
                    DispatchQueue.main.async() { () -> Void in
                        let alert = UIAlertController.singleBtnAlertWithTitle(title: "ERROR".localized, message: error.localizedDescription, actionTitle: "CLOSE".localized, completion: nil)
                        self.present(alert, animated: true, completion: nil)
                    }
                    return
                }

                guard let data = data, let response = response as? HTTPURLResponse else {
                    NSLog("data or response is nil")
                    return
                }

                guard response.statusCode == 200 else {
                    NSLog("Server Error: \(response.statusCode)")
                    return
                }
                
                let json = JSON(data)
                let items = json["items"].array
                self.searchResults = [SearchResult]()
                items?.forEach { item in
                    let result = SearchResult(json: item)
                    print(result.login)
                    self.searchResults.append(result)
                }
                DispatchQueue.main.async() { () -> Void in
                    self.searchView.tableView.reloadData()
                    if self.searchResults.count > 0 {
                        self.searchView.displayView(isTableView: true, isTextLabel: false, isActivityIndicatorView: false)
                    } else {
                        self.searchView.displayView(isTableView: false, isTextLabel: true, isActivityIndicatorView: false)
                        self.searchView.textLabel.text = "\"\(keyword)\"\n" + "SEARCH_EMPTY_MESSAGE".localized
                    }
                    self.searchView.activityIndicatorView.stopAnimating()
                }
            })
            task.resume()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(self.searchResults.count) " + "SEARCH_RESULTS".localized
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
            
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "userCell")
        let searchResult = self.searchResults[indexPath.row]
        cell.textLabel?.text = searchResult.login
        cell.detailTextLabel?.text = searchResult.type

        if let url = URL(string: searchResult.avatar_url) {
            do {
                let data = try Data(contentsOf: url)
                cell.imageView?.image = UIImage(data: data)
            }
            catch {
                NSLog("Error")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchView.tableView.ts_deselectedCell()
        let searchResult = self.searchResults[indexPath.row]
        let detailVC = DetailViewController(searchResult: searchResult)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
