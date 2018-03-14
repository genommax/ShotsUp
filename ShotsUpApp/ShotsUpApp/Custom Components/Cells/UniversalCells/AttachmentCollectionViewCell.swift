//
//  AttachmentCollectionViewCell.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 10.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit

import IGListKit

class AttachmentCollectionViewCell: UICollectionViewCell {

    
    lazy private var label: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.textAlignment = .left
        view.textColor = .black
        view.font = .boldSystemFont(ofSize: 14)
        view.text = "ATTACHMENTS"
        self.contentView.addSubview(view)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = true
        self.contentView.addSubview(view)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = .lightGray
        
        var collectionViewRect = contentView.frame
        collectionViewRect.origin.y = 34
        collectionViewRect.size.height = collectionViewRect.size.height - collectionViewRect.origin.y
        collectionView.frame = collectionViewRect
        
        //
        label.frame = CGRect(x: 16, y: 8, width: contentView.frame.size.width, height: 30)
    }    
}
