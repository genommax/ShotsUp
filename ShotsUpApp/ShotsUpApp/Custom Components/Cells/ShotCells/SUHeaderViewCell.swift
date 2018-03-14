//
//  SUHeaderViewCell.swift
//  ShotsList
//
//  Created by Maxim Lyashenko on 08.08.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit


import IGListKit

func headerSectionController(with requestTypeName: String) -> ListSingleSectionController {
    let configureBlock = { (item: Any, cell: UICollectionViewCell) in
        guard let cell = cell as? SUHeaderViewCell else { return }
        cell.text = requestTypeName
    }
    
    let sizeBlock = { (item: Any, context: ListCollectionContext?) -> CGSize in
        guard let context = context else { return .zero }
        return CGSize(width: context.containerSize.width, height: 82)
    }
    
    return ListSingleSectionController(cellClass: SUHeaderViewCell.self,
                                       configureBlock: configureBlock,
                                       sizeBlock: sizeBlock)
}


class SUHeaderViewCell: UICollectionViewCell {

    lazy private var label: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.textAlignment = .left
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.semibold)
        self.contentView.addSubview(view)
        return view
    }()
    
    var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = contentView.bounds
        rect.origin.x = 24
        rect.origin.y = 12
        label.frame = rect
    }

}
