//
//  SUEmbeddedSectionController.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 10.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import IGListKit

final class SUEmbeddedSectionController: ListSectionController {
    
    private var attachment: AttachmentDS?
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let height = collectionContext?.containerSize.height ?? 0
        return CGSize(width: 94, height: 71)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: SUAttachmentViewCell.self, for: self, at: index) as? SUAttachmentViewCell else {
            fatalError()
        }
        
        cell.setImage(with: attachment?.thumbnail_url)
       
        return cell
    }
    
    override func didUpdate(to object: Any) {
        attachment = object as? AttachmentDS
    }
    
}
