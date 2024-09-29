//
//  NewsModel.swift
//  NewsReader
//
//  Created by Sarvesh on 25/09/24.
//

import Foundation


class NewsModel {
    
    let status: String
    var articles = [Article]()
    let totalResults: Int
    
    init(json: [String: Any]) {
        self.status = json[""] as? String ?? ""
        self.totalResults = json["totalResults"] as? Int ?? 0
        if let articlesValues = json["articles"] as? [[String:Any]], articlesValues.count > 0 {
            self.articles =  articlesValues.map({Article(json: $0)})
        }
    }
    
}

class Article {
    let title: String
    let description: String
    let iconUrl: String
    let publishedAt: String
    let newsDetailUrl: String
    
    init(json: [String: Any]) {
        self.title = json["title"] as? String ?? ""
        self.description = json["description"] as? String ?? ""
        self.iconUrl = json["urlToImage"] as? String ?? ""
        self.publishedAt = "News Published Date:  " + DateFormater.getDate(from: (json["publishedAt"] as? String ?? ""))
        self.newsDetailUrl = json["url"] as? String ?? ""
    }
}
