//
//  SentMemesTableViewController.swift
//  MemeMeV2
//
//  Created by Lorrayne Paraiso  on 22/09/18.
//  Copyright © 2018 Lorrayne Paraiso. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMemes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateMemes()
    }
    
    func updateMemes() {
        memes = MemeList.sharedInstance.getMemes()
        tableView.reloadData()
    }
    
    // MARK: - Empty Table View
    private func EmptyMessage(shouldShow: Bool) {
        
        if shouldShow {
            
            let messageLabel = empityLabel()
            
            self.tableView.backgroundView = messageLabel
            self.tableView.separatorStyle = .none
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        }
    }
    
    
    //Here we control the Empty Message exhibition
    override func numberOfSections(in tableView: UITableView) -> Int {
        if memes.count > 0 {
            EmptyMessage(shouldShow: false)
            return 1
        } else {
            EmptyMessage(shouldShow: true)
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(MemeTableViewCell.self)", for: indexPath) as! MemeTableViewCell
        let meme: Meme = memes[indexPath.row]
        cell.fill(with: meme)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "\(MemeDetailsViewController.self)") as! MemeDetailsViewController
        detailController.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MemeList.sharedInstance.removeMeme(at: indexPath.row)
            updateMemes()
        }
    }
    
}

