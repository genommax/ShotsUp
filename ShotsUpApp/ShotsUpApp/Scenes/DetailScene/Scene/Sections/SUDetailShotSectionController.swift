//
//  SUDetailShotSectionController.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 08.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation

import IGListKit

final class SUDetailShotSectionController: ListSectionController {
    
    private var object: ShotsDS?
    
    var delegate: DetailSectionControllerDelegate?
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        let height: CGFloat = 64
        return CGSize(width: width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(withNibName: "SUDetailUserViewCell", bundle: nil, for: self, at: index) as? SUDetailUserViewCell else {
            fatalError()
        }
        
        guard let shot = object else {
            return cell
        }
        
        cell.delegate = delegate
        
        cell.setupUserInfo(with: shot)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.object = object as? ShotsDS
    }
        
}
