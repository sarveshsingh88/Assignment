//
//  LandingViewModel.swift
//  NewsReader
//
//  Created by Sarvesh on 25/09/24.
//

import Foundation


class LandingViewModel {
    
    var selectedNewsCategory: String = NewsType.business.rawValue
    var titleValue: String = ""
    var newsArticles: [Article] = []
    
    var updateValue:((Bool) -> Void)?
    var errorResponse:((_ errorMessage: String) -> Void)?
    
    func getNews(){
        debugPrint(selectedNewsCategory)
        let newsUrl = getNewsUrl()
        debugPrint(newsUrl)
        guard let url = URL(string: newsUrl) else {
            self.errorResponse?("Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                self.errorResponse?("Error fetching data: \(error.localizedDescription)")
                return
            }
            guard let data else {
                self.errorResponse?("No data received")
                return
            }
            do {
                if let result = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                    print("i eat it \(result)")
                    let model = NewsModel(json: result)
                    self.newsArticles = model.articles
                    self.updateValue?(true)
                } else {
                    self.errorResponse?("No data received")
                }
            }
            catch let error {
                self.errorResponse?(error.localizedDescription)
            }
            
        }.resume()
    }
    
    func getNewsUrl() -> String {
        self.titleValue = self.selectedNewsCategory.uppercased()
        return "https://newsapi.org/v2/top-headlines?country=us&category=\(self.selectedNewsCategory)&apiKey=fb3dae1ae67149eeb2bcea7bcc3b0147"
    }
    
    
}



enum NewsType: String {
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
    
}
