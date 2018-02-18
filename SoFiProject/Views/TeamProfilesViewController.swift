//
//  TeamProfilesViewController.swift
//  SoFiProject
//
//  Created by Keaton Harward on 2/12/18.
//  Copyright © 2018 Keaton Harward. All rights reserved.
//

import UIKit
import MessageUI

private let avatarCellReuse = "AvatarCell"
private let shareRecipients = ["keatonharward@gmail.com"]

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
        guard let screenshot = takeScreenshot() else { return }
        
        presentEmail(withAttachment: screenshot)
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

extension TeamProfilesViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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
    
    // take a screenshot to share
    func takeScreenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        guard let navController = self.navigationController else { return nil }
        navController.view.drawHierarchy(in: navController.view.frame, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot
    }
    
    // present the mail view controller
    func presentEmail(withAttachment attachment: UIImage) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        guard let screenshotData = UIImagePNGRepresentation(attachment) as? Data else { return }
        
        composeVC.setToRecipients(shareRecipients)
        composeVC.setSubject("Keaton's SoFi team project screenshot")
        composeVC.setMessageBody("Check out this screenshot!", isHTML: false)
        composeVC.addAttachmentData(screenshotData, mimeType: "image/png", fileName: "KeatonsTestScreenshot")
        
        self.present(composeVC, animated: true, completion: nil)
    }
}
