//
//  NoInternetView.swift
//  ShotsList
//
//  Created by Maxim Lyashenko on 09.08.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit
import Moya

class NoInternetView: UIView {
    
    var delegate: EmptyViewProtocol?
    
    @IBOutlet weak var titleLabel: UILabel!

    var error: MoyaError?
    
    class func instanceFromNib(with error: MoyaError) -> NoInternetView {
        let view = UINib(nibName: "NoInternetView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NoInternetView
        view.error = error
        return view
    }

    @IBAction func tryAgainAction(_ sender: Any) {
        delegate?.load()
    }
}
