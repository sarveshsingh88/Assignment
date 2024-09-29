//
//  NewDetailViewController.swift
//  NewsReader
//
//  Created by Sarvesh on 25/09/24.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController {
    
    var newsUrl: String = ""
    
    lazy var loaderView: LoaderView = {
        return LoaderView()
    }()
    
    
    lazy var headerView: HeaderView = {
        let hv = HeaderView()
        hv.btnSetting.isHidden = true
        hv.lblTitle.text = "News Details"
        hv.btnBack.setImage(UIImage(named: "back_icon_black"), for: .normal)
        hv.callBackToBack = {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        hv.clipsToBounds = true
        return hv
    }()
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.clipsToBounds = true
        return webView
    }()
    
    lazy var viewContainer: UIView = {
        let vw = UIView()
        //Add Header View
        vw.addSubview(self.headerView)
        self.headerView.anchor(top: vw.topAnchor, leading: vw.leadingAnchor, bottom: nil, trailing: vw.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        self.headerView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        //Add WebView
        vw.addSubview(self.webView)
        self.webView.anchor(top: self.headerView.bottomAnchor, leading: vw.leadingAnchor, bottom: vw.bottomAnchor, trailing: vw.trailingAnchor, padding: UIEdgeInsets(top: 4.0, left: 0, bottom: 0, right: 0))
        
        vw.clipsToBounds = true
        return vw
    }()

    //MARK: View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupview()
        self.checkUrlIsValid()
    }
    
    fileprivate func setupview() {
        self.view.addSubview(self.viewContainer)
        self.viewContainer.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        self.view.backgroundColor = .white
    }
    
    fileprivate func checkUrlIsValid() {
        guard let url = URL(string: self.newsUrl) else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.showLoader()
        let loadRequest = URLRequest(url: url)
        self.webView.load(loadRequest)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.hideLoader()
        })
    }
    
}




extension NewsDetailViewController {
    
    func showLoader() {
        loaderView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        loaderView.center = view.center
        view.addSubview(loaderView)
        loaderView.startLoading()
    }
    
    func hideLoader() {
        loaderView.stopLoading()
        loaderView.removeFromSuperview()
    }
}
