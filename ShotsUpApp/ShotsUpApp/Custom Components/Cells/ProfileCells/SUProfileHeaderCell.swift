//
//  SUProfileHeaderCell.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 11.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit


class SUProfileHeaderCell: UICollectionViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var shotsCountLabel: UILabel!

    class func instanceFromNib() -> SUProfileHeaderCell {
        return UINib(nibName: "SUProfileHeaderCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SUProfileHeaderCell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupUserInfo(with user: UserDS?) {
        guard let item = user else { return  }
        
        nameLabel.text = item.name
        shotsCountLabel.text = "Shots count: \(item.shots_count!)"
        
        let url = item.avatar_url
        userImageView.download(image: url!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
