//
//  SUProfileShotCell.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 11.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit

class SUProfileShotCell: UICollectionViewCell {

    fileprivate let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return view
    }()
    
    fileprivate let activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.startAnimating()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(activityView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        activityView.center = CGPoint(x: bounds.width/2.0, y: bounds.height/2.0)
        imageView.frame = bounds
    }
    
    func setupImage(with images: ImagesDS?) {
        
        guard let item = images else { return  }
        
        let url = item.hidpi != nil ? item.hidpi! : item.normal
        
        imageView.download(image: url!)
    }

}
