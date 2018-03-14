//
//  ShotSectionController.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 28.11.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation

import IGListKit
import Kingfisher


protocol ShotSectionControllerDelegate {
    func shotWantsOpen(_ shot: ShotsDS)
    func reboundsWantsOpen(_ shot: ShotsDS)
}

final class ShotSectionController: ListSectionController, ListWorkingRangeDelegate {
    
    private var object: ShotsDS?
    private var downloadedImage: UIImage?
    
    
    var delegate: ShotSectionControllerDelegate?
    
    private var urlString: String {
        guard let shot = object as? ShotsDS else { return "" }
        return shot.images.normal
    }
    
    var currentObject: ShotsDS? {
        get {
            return object
        }
    }
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 10, left: 9, bottom: 0, right: 0)
        self.minimumInteritemSpacing = 4
        self.minimumLineSpacing = 4
        
        workingRangeDelegate = self
    }
    
    
    
    override func sizeForItem(at index: Int) -> CGSize {
        
        var size: CGSize = CGSize(width: 172, height: 128)
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            //print("iPhone 5 or 5S or 5C")
            size = CGSize(width: 146, height: 128)
        case 1334:
            print("iPhone 6/6S/7/8")
        case 2208:
            //print("iPhone 6+/6S+/7+/8+")
            size = CGSize(width: 192, height: 128)
        case 2436:
            print("iPhone X")
        default:
            print("unknown")
        }
        
        return size
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(withNibName: "SUShotCell", bundle: nil, for: self, at: index) as? SUShotCell else {
            fatalError()
        }
        
        cell.bindViewModel(object as Any)
        cell.delegate = self
        
        cell.imageView.image = nil
        guard downloadedImage != nil else { return cell }
        
        cell.imageView.image = self.downloadedImage
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.object = object as? ShotsDS
    }
    
    
    // MARK: ListWorkingRangeDelegate
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerWillEnterWorkingRange sectionController: ListSectionController) {
        
        guard downloadedImage == nil else { return }
        let url = URL(string: urlString)
        
        KingfisherManager.shared.downloader.downloadImage(with: url!, options: nil, progressBlock: nil, completionHandler: {  (image, error, cacheType, imageUrl) in
            
            DispatchQueue.main.async {
                self.downloadedImage = image
                if let cell = self.collectionContext?.cellForItem(at: 0, sectionController: self) as? SUShotCell {
                    cell.imageView.image = self.downloadedImage
                }
            }
        })
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerDidExitWorkingRange sectionController: ListSectionController) {}
}



extension ShotSectionController: SUShotCellDelegate {
    
    func shotCellDidTapButton(_ cell: SUShotCell) {
        guard let shot = currentObject else {
            return
        }
        
        delegate?.shotWantsOpen(shot)
    }
    
    func reboundsCellDidTapButton(_ cell: SUShotCell) {
        guard let shot = currentObject else {
            return
        }
        
        delegate?.reboundsWantsOpen(shot)
    }
}
