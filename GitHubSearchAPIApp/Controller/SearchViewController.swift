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
    var searchKeyword: String = ""
    var searchResultTotalCount: Int = 0
    var searchResultPage: Int = 1
    
    private var loadStatus: String = "initial"

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
            self.searchKeyword = keyword
            let searchViewModel = SearchViewModel()
            self.searchResults = [SearchResult]()
            self.searchResultPage = 1
            searchViewModel.search(keyword: keyword, page: self.searchResultPage, completion: { result in
                if let error = result.error {
                    let alert = UIAlertController.singleBtnAlertWithTitle(title: "ERROR".localized, message: error.localizedDescription, actionTitle: "CLOSE".localized, completion: nil)
                    self.present(alert, animated: true, completion: nil)
                    return
                }

                DispatchQueue.main.async() { () -> Void in
                    self.searchResults.append(contentsOf: result.data)
                    self.searchResultTotalCount = result.total_count
                    self.searchView.tableView.reloadData()
                    if result.total_count > 0 {
                        self.searchView.displayView(isTableView: true, isTextLabel: false, isActivityIndicatorView: false)
                    } else {
                        self.searchView.displayView(isTableView: false, isTextLabel: true, isActivityIndicatorView: false)
                        self.searchView.textLabel.text = "\"\(keyword)\"\n" + "SEARCH_EMPTY_MESSAGE".localized
                    }
                    self.searchView.activityIndicatorView.stopAnimating()
                }
            })
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(self.searchResults.count) " + " / \(self.searchResultTotalCount) " + "SEARCH_RESULTS".localized
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY
//        print("currentOffsetY: \(currentOffsetY)")
//        print("maximumOffset: \(maximumOffset)")
//        print("distanceToBottom: \(distanceToBottom)")
        if distanceToBottom < 500 {
            print(loadStatus)
            guard loadStatus != "fetching" && loadStatus != "full" else { return }

//            if self.searchResultTotalCount == self.searchResults.count {
//                self.loadStatus = "full"
//                return
//            }
//
            loadStatus = "fetching"

            print(self.searchResultTotalCount)
            print(self.searchResults.count)

            let searchViewModel = SearchViewModel()
            searchViewModel.search(keyword: self.searchKeyword, page: self.searchResultPage, completion: { result in
                if let error = result.error {
                    let alert = UIAlertController.singleBtnAlertWithTitle(title: "ERROR".localized, message: error.localizedDescription, actionTitle: "CLOSE".localized, completion: nil)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                self.searchResults.append(contentsOf: result.data)
                DispatchQueue.main.async() { () -> Void in
                    self.searchView.tableView.reloadData()
                    self.loadStatus = "loadmore"
                    self.searchResultPage += 1
                }
            })
        }
    }
}
