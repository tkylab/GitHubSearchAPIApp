//
//  SearchResult.swift
//  GitHubSearchAPIApp
//
//  Created by thiratani on 2020/09/12.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchResult {

    var login = ""
    var id = ""
    var node_id = ""
    var avatar_url = ""
    var gravatar_id = ""
    var url = ""
    var html_url = ""
    var followers_url = ""
    var following_url = ""
    var gists_url = ""
    var starred_url = ""
    var subscriptions_url = ""
    var organizations_url = ""
    var repos_url = ""
    var events_url = ""
    var received_events_url = ""
    var type = ""
    var site_admin = ""
    var score = ""

    convenience init(json: JSON) {
        self.init()
        self.mapping(json: json)
    }

    func mapping(json: JSON) {
        self.login              = json["login"].stringValue
        self.id                 = json["id"].stringValue
        self.node_id            = json["node_id"].stringValue
        self.avatar_url         = json["avatar_url"].stringValue
        self.gravatar_id        = json["gravatar_id"].stringValue
        self.url                = json["url"].stringValue
        self.html_url           = json["html_url"].stringValue
        self.followers_url      = json["followers_url"].stringValue
        self.following_url      = json["following_url"].stringValue
        self.gists_url          = json["gists_url"].stringValue
        self.starred_url        = json["starred_url"].stringValue
        self.subscriptions_url  = json["subscriptions_url"].stringValue
        self.organizations_url  = json["organizations_url"].stringValue
        self.repos_url          = json["repos_url"].stringValue
        self.events_url         = json["events_url"].stringValue
        self.received_events_url = json["received_events_url"].stringValue
        self.type               = json["type"].stringValue
        self.site_admin         = json["site_admin"].stringValue
        self.score              = json["score"].stringValue
    }
}
