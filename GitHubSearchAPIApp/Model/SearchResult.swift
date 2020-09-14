//
//  SearchResult.swift
//  GitHubSearchAPIApp
//
//  Created by thiratani on 2020/09/12.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SearchResult {

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

    init() {
        // none
    }

    init(json: JSON) {
        login              = json["login"].stringValue
        id                 = json["id"].stringValue
        node_id            = json["node_id"].stringValue
        avatar_url         = json["avatar_url"].stringValue
        gravatar_id        = json["gravatar_id"].stringValue
        url                = json["url"].stringValue
        html_url           = json["html_url"].stringValue
        followers_url      = json["followers_url"].stringValue
        following_url      = json["following_url"].stringValue
        gists_url          = json["gists_url"].stringValue
        starred_url        = json["starred_url"].stringValue
        subscriptions_url  = json["subscriptions_url"].stringValue
        organizations_url  = json["organizations_url"].stringValue
        repos_url          = json["repos_url"].stringValue
        events_url         = json["events_url"].stringValue
        received_events_url = json["received_events_url"].stringValue
        type               = json["type"].stringValue
        site_admin         = json["site_admin"].stringValue
        score              = json["score"].stringValue
    }
}
