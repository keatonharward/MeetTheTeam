//
//  TeamMember.swift
//  SoFiProject
//
//  Created by Keaton Harward on 2/12/18.
//  Copyright © 2018 Keaton Harward. All rights reserved.
//

import Foundation
import UIKit

private let avatarKey = "avatar"
private let bioKey = "bio"
private let firstNameKey = "firstName"
private let lastNameKey = "lastName"
private let idKey = "id"
private let titleKey = "title"

class TeamMember {
    var avatar: UIImage? = nil
    let avatarURL: String
    let bio: String
    let name: String
    let id: String
    let title: String
    
    init?(dictionary: [String : String]) {
        guard let avatarURL = dictionary[avatarKey],
            let bio = dictionary[bioKey],
            let firstName = dictionary[firstNameKey],
            let lastName = dictionary[lastNameKey],
            let id = dictionary[idKey],
            let title = dictionary[titleKey] else { return nil }
        
        self.avatarURL = avatarURL
        self.bio = bio
        self.name = "\(firstName) \(lastName)"
        self.id = id
        self.title = title
        
    }
    
    func getImage(completion: @escaping () -> Void) {
        guard let url = URL(string: avatarURL) else { fatalError("Image URL is missing for TeamMember.") }
        
        NetworkController.performRequest(for: url, httpMethod: .get) { (data, error) in
            guard let data = data,
                let image = UIImage(data: data) else {
                    DispatchQueue.main.async { completion() }
                    return
            }
            self.avatar = image
            DispatchQueue.main.async { completion() }
        }
    }
}
