//
//  SUHorizontalAttachmentsSectionController.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 10.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation

import IGListKit

final class SUHorizontalAttachmentsSectionController: ListSectionController, ListAdapterDataSource {
    
    private var attachment: SUDetailAttachmentsViewModel?
    
    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(),
                                  viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 134)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: AttachmentCollectionViewCell.self,
                                                                for: self,
                                                                at: index) as? AttachmentCollectionViewCell else {
                                                                    fatalError()
        }
        adapter.collectionView = cell.collectionView
        return cell
    }
    
    override func didUpdate(to object: Any) {
        attachment = object as? SUDetailAttachmentsViewModel
    }
    
    // MARK: ListAdapterDataSource
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let attachment = attachment else { return [] }
        return attachment.attachments as [ListDiffable]
        // return (0..<number).map { $0 as ListDiffable }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return SUEmbeddedSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
