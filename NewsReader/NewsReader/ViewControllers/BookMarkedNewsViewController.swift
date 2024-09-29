//
//  BookMarkedNewsViewController.swift
//  NewsReader
//
//  Created by Sarvesh on 25/09/24.
//

import UIKit
import CoreData

class BookMarkedNewsViewController: BaseViewController {
    
    var newsType: String = ""
    var newsList = [NewsListModel]()

    
    lazy var headerView: HeaderView = {
        let hv = HeaderView()
        hv.lblTitle.text = "Bookmarked News"
        hv.btnBack.setImage(UIImage(named: "back_icon_black"), for: .normal)
        hv.callBackOpenFiler = {[weak self] in
            self?.filterNews()
        }
        hv.callBackToBack = {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        hv.clipsToBounds = true
        return hv
    }()
    
    lazy var lblNoDataFound: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.text = "No data available"
        lbl.font = .systemFont(ofSize: 30, weight: .bold)
        return lbl
    }()
    
    
    lazy var tblNewsList: UITableView = {
        let tbl = UITableView()
        tbl.delegate = self
        tbl.dataSource = self
        tbl.showsVerticalScrollIndicator = false
        tbl.separatorStyle = .none
        tbl.clipsToBounds = true
        return tbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupview()
        self.registerNibs()
        self.getBookedMarkedNews(newsType: "")
    }
    
    //MARK: Register Nibs
    fileprivate func registerNibs(){
        self.tblNewsList.register(NewsListTVC.self, forCellReuseIdentifier: NewsListTVC.cellReuseIdentifier)
    }
    
    //MARK: SetupView
    fileprivate func setupview(){
        // Add Header View
        self.view.addSubview(self.headerView)
        self.headerView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        self.headerView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        self.view.addSubview(self.tblNewsList)
        self.tblNewsList.anchor(top: self.headerView.bottomAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0))
        
        self.view.addSubview(self.lblNoDataFound)
        self.lblNoDataFound.anchor(top: self.headerView.bottomAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        self.view.backgroundColor = .white
    }
    
    fileprivate func getBookedMarkedNews(newsType: String){
        
        self.showLoader()
        if let value = DBOperations().fetchAllBookedMarkedNews(newsCategory: newsType) {
            self.newsList = value
            self.reloadDatas()
        } else {
            DispatchQueue.main.async(execute: {
                self.hideLoader()
            })
        }
    }
    
    fileprivate func reloadDatas(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.hideLoader()
            if self.newsList.count > 0 {
                self.tblNewsList.isHidden = false
                self.lblNoDataFound.isHidden = true
                self.headerView.btnSetting.isHidden = false
            } else {
                self.tblNewsList.isHidden = true
                self.lblNoDataFound.isHidden = false
                self.headerView.btnSetting.isHidden = true
            }
        })
    }
    

}



extension BookMarkedNewsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tblNewsList.dequeueReusableCell(withIdentifier: NewsListTVC.cellReuseIdentifier, for: indexPath) as? NewsListTVC else {
            return UITableViewCell()
        }
        if self.newsList.count > indexPath.row {
             let news = self.newsList[indexPath.row]
            cell.setDataOnFromBookedMarkedNewsListTVC(data: news, category: news.newsCategory.lowercased() ?? "")
        }
        cell.callBackOpenNewsDetail = {[weak self] newsUrl in
            self?.openNewsDetailUrl(urlValue: newsUrl)
        }
        cell.btnSaveToBookMark.isHidden = true
        cell.selectionStyle = .none
        return cell
    }
   
    
    
    fileprivate func openNewsDetailUrl(urlValue: String) {
        let vc = NewsDetailViewController()
        vc.newsUrl = urlValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension BookMarkedNewsViewController {
    
    
    
    //MARK: Get Filter
    fileprivate func filterNews(){
        self.showAlert(cancelTitle: "No Filter") { newsType in
            self.getBookedMarkedNews(newsType: newsType.rawValue)
        }
    }
}
