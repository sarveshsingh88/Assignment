//
//  NewsListTVC.swift
//  NewsReader
//
//  Created by Sarvesh on 25/09/24.
//

import UIKit
import AVFoundation
import AVFAudio
import CoreData

class NewsListTVC: UITableViewCell {

    static let cellReuseIdentifier = "NewsListTVC"
    var stackHeightConstraints: NSLayoutConstraint?
    var callBackOpenNewsDetail:((_ newsDetailUrl: String) ->Void)?
    
    var article: Article?
    var news: NewsListModel?
    var newsCategory: String = ""
    var news_url: String = ""
    
    lazy var imgNewsIcon: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 8
        img.layer.borderWidth = 1
        img.layer.borderColor = UIColor.lightGray.cgColor
        img.contentMode = .scaleToFill
        img.clipsToBounds = true
        return img
    }()
    
    lazy var lblNewsTitle: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textColor = .black
        lbl.text = "News Title"
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        return lbl
    }()
    
    lazy var lblNewsDetail: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textColor = .darkGray
        lbl.text = "News Description"
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        return lbl
    }()
    
    lazy var lblNewPublishedDate: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textColor = .lightGray
        lbl.font = .systemFont(ofSize: 10, weight: .regular)
        return lbl
    }()
    
    lazy var btnReadMe: UIButton = {
        let btn = UIButton()
        btn.setTitle("Read News", for: .normal)
        btn.backgroundColor = .green
        btn.addTarget(self, action: #selector(btnReadMeAction), for: .touchUpInside)
        btn.layer.cornerRadius = 4.0
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var btnSaveToBookMark: UIButton = {
        let btn = UIButton()
        btn.setTitle("Book Mark", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(btnSaveToBookMarkAction), for: .touchUpInside)
        btn.layer.cornerRadius = 4.0
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var btnNewsDetail: UIButton = {
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        btn.addTarget(self, action: #selector(btnOpenNewDetailAction), for: .touchUpInside)
        btn.layer.cornerRadius = 4.0
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [btnReadMe, btnSaveToBookMark])
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        sv.spacing = 20
        return sv
    }()
    
    lazy var viewSeperator: UIView = {
        let vw = UIView()
        vw.backgroundColor = .lightGray
        vw.clipsToBounds = true
        return vw
    }()
    
    
    lazy var viewContainer: UIView = {
        let vw = UIView()
        
        //Add Image
        vw.addSubview(imgNewsIcon)
        self.imgNewsIcon.anchor(top: vw.topAnchor, leading: vw.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 8, left: 12.0, bottom: 0, right: 0), size: CGSize(width: 60, height: 40))
    
        
        //Add Label
        vw.addSubview(self.lblNewsTitle)
        self.lblNewsTitle.anchor(top: vw.topAnchor, leading: self.imgNewsIcon.trailingAnchor, bottom: nil, trailing: vw.trailingAnchor, padding: UIEdgeInsets(top: 8, left: 8, bottom: 4, right: 8))
        
        //Add Description
        vw.addSubview(self.lblNewsDetail)
        self.lblNewsDetail.anchor(top: self.lblNewsTitle.bottomAnchor, leading: self.imgNewsIcon.trailingAnchor, bottom: nil, trailing: vw.trailingAnchor, padding: UIEdgeInsets(top: 4.0, left: 8.0, bottom: 0, right: 8.0))
        
        //Add Stack View
        vw.addSubview(self.stackView)
        self.stackView.anchor(top: nil, leading: self.imgNewsIcon.trailingAnchor, bottom: nil, trailing: vw.trailingAnchor, padding: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 4.0, right: 8.0))
        self.stackHeightConstraints = self.stackView.heightAnchor.constraint(equalToConstant: 44.0)
        self.stackHeightConstraints?.isActive = true
        self.stackView.topAnchor.constraint(greaterThanOrEqualTo: self.imgNewsIcon.bottomAnchor, constant: 8.0).isActive = true
        self.stackView.topAnchor.constraint(greaterThanOrEqualTo: self.lblNewsDetail.bottomAnchor, constant: 8.0).isActive = true
        
        //Add btnNewsDetail
        vw.addSubview(self.btnNewsDetail)
        self.btnNewsDetail.anchor(top: vw.topAnchor, leading: vw.leadingAnchor, bottom: self.stackView.topAnchor, trailing: vw.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        //Add Date Label
        vw.addSubview(self.lblNewPublishedDate)
        self.lblNewPublishedDate.anchor(top: self.stackView.bottomAnchor, leading: vw.leadingAnchor, bottom: nil, trailing: vw.trailingAnchor, padding: UIEdgeInsets(top: 4.0, left: 12.0, bottom: 4.0, right: 12.0))
        
        
        //Add Seperator View
        vw.addSubview(self.viewSeperator)
        self.viewSeperator.anchor(top: self.lblNewPublishedDate.bottomAnchor, leading: vw.leadingAnchor, bottom: vw.bottomAnchor, trailing: vw.trailingAnchor, padding: UIEdgeInsets(top: 4.0, left: 12.0, bottom: 8.0, right: 12.0))
        self.viewSeperator.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        vw.clipsToBounds = true
        return vw
    }()
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: Set Up View
    fileprivate func setUpView(){
        self.contentView.addSubview(self.viewContainer)
        self.viewContainer.anchor(top: self.contentView.topAnchor, leading: self.contentView.leadingAnchor, bottom: self.contentView.bottomAnchor, trailing: self.contentView.trailingAnchor, padding: UIEdgeInsets(top: 2.0, left: 8.0, bottom: 2.0, right: 8.0))
    }
    
    //MARK: Set Data
    func setDataOnNewsListTVC(data: Article?, category: String){
        self.newsCategory = category
        if let data {
            self.article = data
            self.lblNewsTitle.text = data.title
            self.lblNewsDetail.text = data.description
            self.lblNewPublishedDate.text = data.publishedAt
            guard let url = URL(string: data.iconUrl) else{
                return
            }
            self.downloadImage(from: url)
        }
    }
    
    func setDataOnFromBookedMarkedNewsListTVC(data: NewsListModel?, category: String){
        self.newsCategory = category
        if let data {
            self.news = data
            self.lblNewsTitle.text = data.newsTitle
            self.lblNewsDetail.text = data.newsDescription
            self.lblNewPublishedDate.text = data.newsPublieshedDate
            self.news_url = data.newsUrl
            guard let url = URL(string: data.newsIconUrl) else {
                return
            }
            self.downloadImage(from: url)
        }
    }
    
    
    func downloadImage(from url: URL) {
        print("Download Started")
        self.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.imgNewsIcon.image = UIImage(data: data)
            }
        }
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    //MARK: btnReadMeAction
    @objc func btnReadMeAction(){
        
        if let article {
            let title = article.title
            let description = article.description
            let fullArticle = title + description
            let utterance = AVSpeechUtterance(string: fullArticle)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.1
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)           
        }
        if let news = self.news {
            let title = news.newsTitle
            let description = news.newsDescription
            let fullArticle = title + description
            let utterance = AVSpeechUtterance(string: fullArticle)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.1
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
        }
    }
    
    @objc func btnSaveToBookMarkAction(){
        DBOperations().insertNewsDetail(newsData: self.article, news_category: newsCategory)
    }
    
    @objc func btnOpenNewDetailAction(){
        if !self.news_url.isEmpty {
            self.callBackOpenNewsDetail?(self.news_url)
        }
    }

}
