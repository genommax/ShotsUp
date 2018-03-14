//
//  SUProfileHorizontalSectionController.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 11.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import IGListKit


final class SUProfileHorizontalSectionController: ListSectionController {
    
    private var object: ProfileSection?
    
    override init() {
        super.init()
        self.minimumInteritemSpacing = 1
        self.minimumLineSpacing = 1
    }
    
    override func numberOfItems() -> Int {
        
        if let items = object?.object as? Array<ShotsDS> {
            return items.count
        } else {
            return 0
        }
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        let itemSize = floor(width / 4)
        return CGSize(width: itemSize, height: itemSize)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: SUProfileShotCell.self, for: self, at: index) as? SUProfileShotCell else {
            fatalError()
        }

        
        if let items = object?.object as? Array<ShotsDS> {
            let item = items[index].images
            cell.setupImage(with: item)
        }
                
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.object = object as? ProfileSection
    }
    
}
