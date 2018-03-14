//
//  SUProfileUserSectionController.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 11.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import IGListKit

final class SUProfileUserSectionController: ListSectionController {
    
    
    private var object: ProfileSection?
    
    
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        let height: CGFloat = 200
        return CGSize(width: width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(withNibName: "SUProfileHeaderCell", bundle: nil, for: self, at: index) as? SUProfileHeaderCell else {
            fatalError()
        }
        
        guard let item = object else {
            return cell
        }
        
       // cell.backgroundColor = .lightGray
        
        cell.setupUserInfo(with: item.object as! UserDS)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.object = object as? ProfileSection
    }
    
    
}
