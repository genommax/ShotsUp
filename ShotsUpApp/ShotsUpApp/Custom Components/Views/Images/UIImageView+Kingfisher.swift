//
//  UIImageView+Kingfisher.swift
//  ShotsList
//
//  Created by Maxim Lyashenko on 02.08.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func download(image url: String) {
        guard let imageURL = URL(string:url) else {
            return
        }
        //self.kf.setImage(with: imageURL)
        self.kf.setImage(with: imageURL, placeholder: nil, options:  [.onlyLoadFirstFrame], progressBlock: nil) { (image, error, cacheType, url) in
           self.image = image
        }
    }
    
    func downloadDetail(image url: String) {
        guard let imageURL = URL(string:url) else {
            return
        }

        self.kf.setImage(with: imageURL, placeholder: nil, options:  nil, progressBlock: nil) { (image, error, cacheType, url) in
            self.image = image
        }
    }

    
    func cancelDownload() {
        self.kf.cancelDownloadTask()
    }
}
