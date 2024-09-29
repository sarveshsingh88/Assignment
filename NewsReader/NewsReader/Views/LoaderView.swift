//
//  LoaderView.swift
//  NewsReader
//
//  Created by Sarvesh on 25/09/24.
//

import UIKit


class LoaderView: UIView {
    
    private let spinner = UIActivityIndicatorView(style: .large)
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.white.withAlphaComponent(0.8)
        layer.cornerRadius = 10
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(spinner)
        addSubview(label)
        
        label.text = "Loading..."
        label.textColor = .gray
        label.textAlignment = .center
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func startLoading() {
        spinner.startAnimating()
    }
    
    func stopLoading() {
        spinner.stopAnimating()
    }
}


