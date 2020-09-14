//
//  SearchViewModel.swift
//  GitHubSearchAPIApp
//
//  Created by thiratani on 2020/09/14.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Result {
    var data = [SearchResult]()
    var total_count: Int = 0
    var response: HTTPURLResponse?
    var error: Error?
}

class SearchViewModel {
    
    func search(keyword: String, page: Int, completion: @escaping ((Result) -> Void)) {
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.waitsForConnectivity = false
        let session = URLSession(configuration: config, delegate: .none, delegateQueue: OperationQueue.main)
        
        let urlStr = "https://api.github.com/search/users?q=\(keyword)&per_page=30&page=\(page)"
        let encodeUrlString: String = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: encodeUrlString) else { return }

        var result = Result()
        
        let task = session.dataTask(with: url, completionHandler: {data, response, error in
            
            if error != nil {
                result.error = error
            }

            if response != nil {
                result.response = response as? HTTPURLResponse
            }

            guard let data = data else {
                completion(result)
                return
            }
            
            let json = JSON(data)
            result.total_count = json["total_count"].int ?? 0

            let items = json["items"].array
            var searchResults = [SearchResult]()
            items?.forEach { item in
                let result = SearchResult(json: item)
                searchResults.append(result)
            }
            result.data = searchResults
            
            completion(result)
        })
        task.resume()
    }
    
}
