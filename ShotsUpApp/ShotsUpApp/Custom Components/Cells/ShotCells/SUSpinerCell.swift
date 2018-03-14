//
//  SUSpinerCell.swift
//  ShotsList
//
//  Created by Maxim Lyashenko on 21.07.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit

import IGListKit

func spinnerSectionController() -> ListSingleSectionController {
    let configureBlock = { (item: Any, cell: UICollectionViewCell) in
        guard let cell = cell as? SUSpinerCell else { return }
        cell.activityIndicator.startAnimating()
    }
    
    let sizeBlock = { (item: Any, context: ListCollectionContext?) -> CGSize in
        guard let context = context else { return .zero }
        return CGSize(width: context.containerSize.width, height: 100)
    }
    
    return ListSingleSectionController(cellClass: SUSpinerCell.self,
                                       configureBlock: configureBlock,
                                       sizeBlock: sizeBlock)
}


class SUSpinerCell: UICollectionViewCell {

    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.contentView.addSubview(view)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        activityIndicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
