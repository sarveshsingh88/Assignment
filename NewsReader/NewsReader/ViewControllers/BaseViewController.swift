//
//  BaseViewController.swift
//  NewsReader
//
//  Created by Sarvesh on 27/09/24.
//

import UIKit

class BaseViewController: UIViewController {

    lazy var loaderView: LoaderView = {
        return LoaderView()
    }()
    
    func showAlert(cancelTitle: String, callBack: @escaping((_ newsType: NewsType) -> Void)) {
        let alertController = UIAlertController()
        alertController.title = "Filter News"
        alertController.message = "Select News Category"
        
        let action1 = UIAlertAction(title: NewsType.business.rawValue, style: .default) { (action) in
            callBack(NewsType(rawValue: NewsType.business.rawValue)!)
            
        }
        let action2 = UIAlertAction(title: NewsType.entertainment.rawValue, style: .default) { (action) in
            callBack(NewsType(rawValue: NewsType.entertainment.rawValue)!)
        }
        let action3 = UIAlertAction(title: NewsType.general.rawValue, style: .default) { (action) in
            callBack(NewsType(rawValue: NewsType.general.rawValue)!)
        }
        let action4 = UIAlertAction(title: NewsType.health.rawValue, style: .default) { (action) in
            callBack(NewsType(rawValue: NewsType.health.rawValue)!)
        }
        let action5 = UIAlertAction(title: NewsType.science.rawValue, style: .default) { (action) in
            callBack(NewsType(rawValue: NewsType.science.rawValue)!)
        }
        let action6 = UIAlertAction(title: NewsType.sports.rawValue, style: .default) { (action) in
            callBack(NewsType(rawValue:  NewsType.sports.rawValue)!)
        }
        let action7 = UIAlertAction(title: NewsType.technology.rawValue, style: .default) { (action) in
            callBack(NewsType(rawValue: NewsType.technology.rawValue)!)
        }
        let action8 =  UIAlertAction(title: cancelTitle, style: .destructive) { (action) in
            
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        alertController.addAction(action4)
        alertController.addAction(action5)
        alertController.addAction(action6)
        alertController.addAction(action7)
        alertController.addAction(action8)
        self.present(alertController, animated: true)
    }
    
    
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
