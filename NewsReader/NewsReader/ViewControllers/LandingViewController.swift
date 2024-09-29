//
//  LandingViewController.swift
//  NewsReader
//
//  Created by Sarvesh on 25/09/24.
//

import UIKit

class LandingViewController: BaseViewController {
    
    lazy var landingViewModel: LandingViewModel = {
        return LandingViewModel()
    }()
    
    lazy var headerView: HeaderView = {
        let hv = HeaderView()
        hv.btnBack.setImage(UIImage(named: "book_marks"), for: .normal)
        hv.callBackOpenFiler = {[weak self] in
            self?.filterNews()
        }
        hv.callBackToBack = {[weak self] in
            self?.openBookedMarkedNews()
        }
        hv.clipsToBounds = true
        return hv
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

    //MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupview()
        self.registerNibs()
        
        self.showLoader()
        self.landingViewModel.getNews()
        self.bindViewModel()
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
    }
    
    //MARK: View Model Bind
    fileprivate func bindViewModel(){
        self.landingViewModel.updateValue = {[weak self] status in
            self?.reloadTableView()
        }
        self.landingViewModel.errorResponse = {[weak self] errorMessage in
            debugPrint(errorMessage)
            self?.reloadTableView()
        }
    }
    //MARK: Load Table View
    fileprivate func reloadTableView(){
        DispatchQueue.main.async(execute: {
            self.hideLoader()
            self.headerView.lblTitle.text = self.landingViewModel.titleValue
            self.tblNewsList.reloadData()
        })
    }
}


extension LandingViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.landingViewModel.newsArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tblNewsList.dequeueReusableCell(withIdentifier: NewsListTVC.cellReuseIdentifier, for: indexPath) as? NewsListTVC else {
            return UITableViewCell()
        }
        if self.landingViewModel.newsArticles.count > indexPath.row {
            cell.setDataOnNewsListTVC(data: self.landingViewModel.newsArticles[indexPath.row], category: self.landingViewModel.selectedNewsCategory)
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsUrl = self.landingViewModel.newsArticles[indexPath.row].newsDetailUrl
        self.openNewsDetailUrl(urlValue: newsUrl)
    }
    
    //MARK: Open Filer Aler
    fileprivate func filterNews(){
        self.showAlert(cancelTitle: "Cancle") { newsType in
            self.landingViewModel.selectedNewsCategory = newsType.rawValue
            self.loadFilteredNews()
        }
    }
    
    fileprivate func loadFilteredNews() {
        self.showLoader()
        self.landingViewModel.getNews()
    }
    
    fileprivate func openNewsDetailUrl(urlValue: String) {
        let vc = NewsDetailViewController()
        vc.newsUrl = urlValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func openBookedMarkedNews(){
        let vc = BookMarkedNewsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
