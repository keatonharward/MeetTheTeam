//
//  TeamProfilesViewController.swift
//  SoFiProject
//
//  Created by Keaton Harward on 2/12/18.
//  Copyright © 2018 Keaton Harward. All rights reserved.
//

import UIKit

private let avatarCellReuse = "AvatarCell"

class TeamProfilesViewController: UIViewController {
    
    var teamMembers = [TeamMember]()
    var deleteModeActive = false {
        didSet {
            collectionView.reloadData()
        }
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var bioTextField: UITextView!

    
    @IBAction func saveButtonTapped(_ sender: Any) {
        deleteModeActive = !deleteModeActive
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch teamMembers and populate the array
        let teamMembersJSONURL = URL(fileURLWithPath: Bundle.main.path(forResource: "team", ofType: "json")!)
        do {
            let teamMembersJSONData = try Data(contentsOf: teamMembersJSONURL)
            let tmJSONObject = try JSONSerialization.jsonObject(with: teamMembersJSONData, options: JSONSerialization.ReadingOptions(rawValue: UInt(0)))
            if let allMembersData = tmJSONObject as? [[String : String]] {
                for member in allMembersData {
                    if let teamMember = TeamMember(dictionary: member) {
                        teamMembers.append(teamMember)
                    } else {
                        print("Unable to convert JSON data to team member")
                    }
                }
            }
        }
        catch {
            print("Error getting team member data")
        }
        updateInfo(forTeamMember: teamMembers[0])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - UICollectionViewDelegate
extension TeamProfilesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let teamMember = teamMembers[indexPath.row]
        updateInfo(forTeamMember: teamMember)
    }
    
    
}

// MARK: - UICollectionViewDataSource
extension TeamProfilesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamMembers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: avatarCellReuse, for: indexPath) as? AvatarCollectionViewCell else { return AvatarCollectionViewCell() }
        let teamMember = teamMembers[indexPath.row]
        cell.teamMember = teamMember
        
        if !deleteModeActive {
            cell.deleteButton.isHidden = true
        } else {
            cell.deleteButton.isHidden = false
        }
        
        cell.addGestureRecognizer(getLongPressGesture())
        
        return cell
    }
}

// MARK: - Private (Helper functions)
private extension TeamProfilesViewController {
    // Update profile info for selected cell
    func updateInfo(forTeamMember member: TeamMember) {
        nameLabel.text = member.name
        idLabel.text = "\(member.id) / 300"
        bioTextField.text = member.bio
    }
    
    // to add long press gesture to avatar cells
    func getLongPressGesture() -> UIGestureRecognizer {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(avatarCellLongPressed))
        return gesture
    }
    
    // set the deleteMode to add/remove X button
    @objc func avatarCellLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            deleteModeActive = !deleteModeActive
        }
    }
}
