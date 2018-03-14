//
//  SUDetailImageSectionController.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 08.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation

import IGListKit

final class SUDetailImageSectionController: ListSectionController {
    
    private var object: ImagesDS?
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        let height: CGFloat = width / 1.3
        return CGSize(width: width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(withNibName: "SUDetailShotViewCell", bundle: nil, for: self, at: index) as? SUDetailShotViewCell else {
            fatalError()
        }
        
        guard let images = object else {
            return cell
        }
        
        cell.setupUserInfo(with: images)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.object = object as? ImagesDS
    }
        
}
