//
//  SUDetailDescriptionSectionController.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 09.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation

import IGListKit


class SUDetailDescriptionSectionController: ListSectionController {
    
    private var expanded = false
    private var object: String?
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        let height = expanded ? SUDetailDecriptionViewCell.textHeight(object ?? "", width: width) : SUDetailDecriptionViewCell.singleLineHeight
        return CGSize(width: width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: SUDetailDecriptionViewCell.self, for: self, at: index) as? SUDetailDecriptionViewCell else {
            fatalError()
        }
        cell.text = object
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.object = object as? String
    }
    
    override func didSelectItem(at index: Int) {
        expanded = !expanded
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.6,
                       options: [],
                       animations: {
                        self.collectionContext?.invalidateLayout(for: self)
        })
    }
}
