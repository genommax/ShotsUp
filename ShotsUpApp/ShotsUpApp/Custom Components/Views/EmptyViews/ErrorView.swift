//
//  ErrorView.swift
//  ShotsList
//
//  Created by Maxim Lyashenko on 09.08.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit

class ErrorView: UIView {

    var delegate: EmptyViewProtocol?
    
    @IBOutlet weak var titleLabel: UILabel!

    
    var error: Swift.Error?
    
    class func instanceFromNib(with error: Error) -> ErrorView {
        let view =  UINib(nibName: "ErrorView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ErrorView
        view.error = error
        return view
    }
    
    @IBAction func tryAgainAction(_ sender: Any) {
        delegate?.load()
    }

}
