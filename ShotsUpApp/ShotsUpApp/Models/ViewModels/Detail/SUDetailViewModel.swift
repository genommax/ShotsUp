//
//  SUDetailViewModel.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 08.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit

import IGListKit


class SUDetailViewModel {
    
    var shot: ShotsDS?
    var attachments: [AttachmentDS] = [AttachmentDS]()
    var comments: [CommentDS] = [CommentDS]()
    
    var count: Int {
        return 1
    }
    
    var objects: [SUViewModel] {
        
        guard let shot = shot else { return [] }
        
        var array: [SUViewModel] = [shot.images, shot]

        
        if shot.description != nil {
            array.append(shot.description!)
        }
        
        guard attachments.count > 0  else { return array }
        let attach = SUDetailAttachmentsViewModel(with: attachments)
        
        if shot.description != nil {
            array.insert(attach, at: array.count - 1)
        } else {
            array.append(attach)
        }
        return array
        
    }
    
    
    
}


class SUDetailAttachmentsViewModel: SUViewModel {
    var attachments: [AttachmentDS] = [AttachmentDS]()

    init(with attachments: [AttachmentDS]) {
        self.attachments.append(contentsOf: attachments)
    }
}

extension SUDetailAttachmentsViewModel: ListDiffable {
    // MARK: ListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return attachments as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? SUDetailAttachmentsViewModel else { return false }
        return attachments.count == object.attachments.count
    }
}



extension String: SUViewModel {
    
}

extension AttachmentDS: SUViewModel {
    
}
