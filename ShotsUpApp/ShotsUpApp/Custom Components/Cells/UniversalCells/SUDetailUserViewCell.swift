//
//  SUDetailUserViewCell.swift
//  ShotsUp
//
//  Created by Maxim Lyashenko on 18.08.17.
//  Copyright © 2017 dev-pro. All rights reserved.
//

import UIKit

import ActiveLabel


class SUDetailUserViewCell: UICollectionViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var userNameLabel: ActiveLabel!
    @IBOutlet weak var titleInfoLabel: UILabel!
    
    private var shot: ShotsDS? 
    
     var delegate: DetailSectionControllerDelegate?
    
    class func instanceFromNib() -> SUDetailUserViewCell {
        return UINib(nibName: "SUDetailUserViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SUDetailUserViewCell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupUserInfo(with shotItem: ShotsDS?) {
        
        guard let item = shotItem else { return  }
        
        titleInfoLabel.text = item.title
        setupUserName(with: item)
        setupTeamIcon(with: item)
        
        let userURL = item.user.avatar_url ?? ""
        userImageView.download(image: userURL)
    }
    
    
    private func setupTeamIcon(with shot: ShotsDS) {
        
        teamImageView.isHidden = true
        guard let url = shot.team?.avatar_url else {
            return
        }
        
        teamImageView.isHidden = false
        teamImageView.download(image: url)
    }
    
    private func setupUserName(with shot: ShotsDS) {
        
        guard let userName = shot.user.name else {
            return
        }
        
        guard let created_at = shot.created_at else {
            return
        }
        
        var teamName = ""
        
        if  shot.team != nil {
            
            guard let name = shot.team?.name else {
                return
            }
            
            teamName = name
        }
        
        let customTypeUser = ActiveType.custom(pattern: "\\s" + userName + "\\b") //Looks for "are"
        let customTypeTeam = ActiveType.custom(pattern: "\\s" + teamName + "\\b") //Looks for "are"

        
        userNameLabel.enabledTypes.append(customTypeUser)
        userNameLabel.enabledTypes.append(customTypeTeam)

        
        userNameLabel.customize { label in
            
            label.numberOfLines = 0
            label.lineSpacing = 1
            
            label.textColor = UIColor(red: 102.0/255, green: 117.0/255, blue: 127.0/255, alpha: 1)

            label.customColor[customTypeUser] = UIColor.magenta
            label.customColor[customTypeTeam] = UIColor.magenta


            label.handleCustomTap(for: customTypeUser) {_ in
                //self.alert("Custom type", message: $0)
               
                self.delegate?.profileWantsOpen(shot.user)
            }
            
            if teamName.count > 0 {
                label.text = "by \(userName) for \(teamName) on \(created_at.correctDate())"

                label.handleCustomTap(for: customTypeTeam) { self.alert("Custom type", message: $0) }
                
            } else {
                label.text = "by \(userName) on \(created_at.correctDate())"
            }
            
        }
    }

        func alert(_ title: String, message: String) {
            let vc = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            vc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        }
        
}


extension String {
    
    func correctDate() -> String  {
        let isoDate = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:isoDate)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from:components)
    
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "d MMM. yyyy"
        return dateFormatter.string(from: finalDate!)
    }
    
}
