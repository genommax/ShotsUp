//
//  SUShotCell.swift
//  ShotsList
//
//  Created by Maxim Lyashenko on 21.07.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit

import IGListKit

protocol SUShotCellDelegate: class {
    func shotCellDidTapButton(_ cell: SUShotCell)
    func reboundsCellDidTapButton(_ cell: SUShotCell)
}


class SUShotCell: UICollectionViewCell {

    weak var delegate: SUShotCellDelegate?
    weak var viewModel: ShotsDS?
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rebountsButton: UIButton!
    @IBOutlet weak var gifView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var reboundImageView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        setTouchRecognizer()
    }
        
    fileprivate func setTouchRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        imageView.addGestureRecognizer(tap)
    }
    
    func setup(item: ShotsDS?) {
        
        guard let shot = item else {
            return
        }
        
        //imageView.download(image: shot.images.normal)
        
        gifView.isHidden = shot.animated == true ?  false : true
        
        if shot.rebounds_count == 0 {
            rebountsButton.isHidden = true
            reboundImageView.isHidden = true
        } else {
            rebountsButton.isHidden = false
            reboundImageView.isHidden = false
            //rebountsButton.setTitle("\(shot.rebounds_count!)", for: .normal)
        }
    }

    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        delegate?.shotCellDidTapButton(self)
    }
    
    @IBAction func handleReboundAction(_ sender: Any) {
        delegate?.reboundsCellDidTapButton(self)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        self.rebountsButton.layer.masksToBounds = false
        self.rebountsButton.clipsToBounds  = false
        self.clipsToBounds  = false
        
        self.reboundImageView.layer.cornerRadius = 16
    }
    
}

extension SUShotCell: ListBindable {
    
    func bindViewModel(_ viewModel: Any) {
        guard let model: ShotsDS = viewModel as? ShotsDS else { return }
        
        self.viewModel = model
        setup(item: self.viewModel)
    }
    
}
