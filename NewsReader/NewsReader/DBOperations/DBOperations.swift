//
//  DBOperations.swift
//  NewsReader
//
//  Created by Sarvesh on 25/09/24.
//

import Foundation
import CoreData

class DBOperations {
    
    lazy var coreDataStack = CoreDataStack(modelName: "NewsReader")
    var fetchedResultsController: NSFetchedResultsController<NewsList> = NSFetchedResultsController()
    
    
    func insertNewsDetail(newsData: Article?, news_category: String) {
        if let data = newsData {
            let value = checkNewsIsAlreadyBookedMarked(newsTitle: data.title)
            if value == false {
                 coreDataStack.storeContainer.performBackgroundTask { (context) in
                    let newsList = NSEntityDescription.entity(forEntityName: "NewsList", in: context)!
                    let bannerMo = NewsList(entity: newsList, insertInto: context)
                    bannerMo.icon_url = data.iconUrl
                    bannerMo.news_description = data.description
                    bannerMo.news_published_date = data.publishedAt
                    bannerMo.news_title = data.title
                    bannerMo.news_url = data.newsDetailUrl
                    bannerMo.news_category = news_category.uppercased()
                    do {
                        try context.save()
                    } catch {
                        print("Failure to save context: \(error)")
                    }
                }
            } else {
                debugPrint("data are already saved")
            }
        }
    }
    
    func checkNewsIsAlreadyBookedMarked(newsTitle: String?) -> Bool {
        if let title = newsTitle {
            let context = coreDataStack.mainContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsList")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate  = NSPredicate(format: "news_title == %@", "\(title)")
            do {
                if let result = try context.fetch(fetchRequest) as? [NewsList], result.count > 0{
                    return true
                } else {
                    return false
                }
            }
            catch  {
                print ("unable to fetch FacilitiesEntity")
                return false
            }
        }
        return false
    }
    
    func fetchAllBookedMarkedNews(newsCategory: String) -> Array<NewsListModel>? {
        var arr = [NewsListModel]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsList")
        fetchRequest.returnsObjectsAsFaults = false

        if !newsCategory.isEmpty {
            fetchRequest.predicate  = NSPredicate(format: "news_category == %@", "\(newsCategory.uppercased())")
        }
        do {
            let results = try self.coreDataStack.mainContext.fetch(fetchRequest)
            if results.count > 0 {
                for result in results {
                    let value = NewsListModel.init(json: result as? NSManagedObject)
                        arr.append(value)
                }
            }
        } catch _ as NSError {
            debugPrint("Some error occured:- ")
        }
        return arr
    }

}

class NewsListModel {
    let newsTitle: String
    let newsDescription: String
    let newsUrl: String
    let newsCategory: String
    let newsIconUrl: String
    let newsPublieshedDate: String
    init(json: NSManagedObject?) {
        if let js = json as? NewsList {
            self.newsTitle = js.news_title ?? ""
            self.newsDescription = js.news_description ?? ""
            self.newsUrl = js.news_url ?? ""
            self.newsIconUrl = js.icon_url ?? ""
            self.newsCategory = js.news_category ?? ""
            self.newsPublieshedDate = js.news_published_date ?? ""
        } else {
            self.newsTitle =  ""
            self.newsDescription = ""
            self.newsUrl =  ""
            self.newsIconUrl = ""
            self.newsCategory =  ""
            self.newsPublieshedDate = ""
        }
        
    }
}
