//
//  HeaderView.swift
//  NewsReader
//
//  Created by Sarvesh on 25/09/24.
//

import UIKit

class HeaderView: UIView {
    
    var callBackOpenFiler: (() -> Void)?
    var callBackToBack:(() -> Void)?
    
    lazy var btnBack: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        btn.setImage(UIImage(named: "back_icon_black"), for: .normal)
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var btnSetting: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(btnSettingAction), for: .touchUpInside)
        btn.setImage(UIImage(named: "filter"), for: .normal)
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 30, weight: .bold)
        return lbl
    }()
    
    lazy var viewContainer: UIView = {
        let vw = UIView()
        
        //Add Back Button
        vw.addSubview(self.btnBack)
        self.btnBack.anchor(top: vw.topAnchor, leading: vw.leadingAnchor, bottom: vw.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 8.0, left: 12.0, bottom: 8.0, right: 12.0), size: CGSize(width: 24.0, height: 24.0))
        
        //Add Setting Button
        vw.addSubview(self.btnSetting)
        self.btnSetting.anchor(top: vw.topAnchor, leading: nil, bottom: vw.bottomAnchor, trailing: vw.trailingAnchor, padding: UIEdgeInsets(top: 8.0, left: 0, bottom: 8.0, right: 12.0), size: CGSize(width: 24.0, height: 24.0))
        
        //Add Title Label
        vw.addSubview(self.lblTitle)
        self.lblTitle.anchor(top: vw.topAnchor, leading: self.btnBack.trailingAnchor, bottom: vw.bottomAnchor, trailing: self.btnSetting.leadingAnchor,padding: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0))
        vw.clipsToBounds = true
        return vw
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    //MARK:
    fileprivate func setUpView(){
        self.addSubview(self.viewContainer)
        self.viewContainer.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    //MARK: Btn Action
    @objc func btnSettingAction(){
        self.callBackOpenFiler?()
    }
    
    @objc func btnBackAction(){
        self.callBackToBack?()
    }
}
