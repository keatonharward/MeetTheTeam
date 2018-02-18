//
//  AvatarCollectionViewCell.swift
//  SoFiProject
//
//  Created by Keaton Harward on 2/13/18.
//  Copyright © 2018 Keaton Harward. All rights reserved.
//

import UIKit

class AvatarCollectionViewCell: UICollectionViewCell {
    
    var teamMember: TeamMember? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let teamMember = teamMember else { return }
        teamMember.avatar = #imageLiteral(resourceName: "GreyAvatar")
        updateCell()
    }
    
    func updateCell() {
        self.layer.cornerRadius = 12.0
        guard let teamMember = teamMember else { return }
        if teamMember.avatar == nil {
            teamMember.getImage(completion: {
                self.imageView.image = teamMember.avatar
            })
        } else {
            imageView.image = teamMember.avatar
        }
    }
}
