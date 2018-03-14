//
//  SUAttachmentViewCell.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 10.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit

class SUAttachmentViewCell: UICollectionViewCell {

    fileprivate let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return view
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        imageView.frame = bounds
    }
    
    func setImage(with url: String?) {
        guard let url = url else { return }
        imageView.download(image: url)
     
    }

}
