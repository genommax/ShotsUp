//
//  EmptyView.swift
//  ShotsList
//
//  Created by Maxim Lyashenko on 02.08.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit

protocol EmptyViewProtocol {
    func load()
}

class EmptyView: UIView {

    
    var delegate: EmptyViewProtocol?
    
    class func instanceFromNib() -> EmptyView {
        return UINib(nibName: "EmptyView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EmptyView
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.addSubview(view)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = self.bounds
        activityIndicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    func load() {
        activityIndicator.startAnimating()
        delegate?.load()
    }

}
