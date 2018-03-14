//
//  SUDetailShotViewCell.swift
//  ShotsUp
//
//  Created by Maxim Lyashenko on 18.08.17.
//  Copyright © 2017 dev-pro. All rights reserved.
//

import Foundation

import IGListKit

class SUDetailShotViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var shotImageView: UIImageView!
    
    class func instanceFromNib() -> SUDetailShotViewCell {
        return UINib(nibName: "SUDetailShotViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SUDetailShotViewCell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupUserInfo(with images: ImagesDS?) {
        guard let item = images else { return  }
        
        let url = item.hidpi != nil ? item.hidpi! : item.normal
        shotImageView.download(image: url!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
