//
//  MemeDetailsViewController.swift
//  MemeMeV2
//
//  Created by Lorrayne Paraiso  on 22/09/18.
//  Copyright © 2018 Lorrayne Paraiso. All rights reserved.
//

import UIKit

class MemeDetailsViewController: UIViewController {
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    
    var meme: Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let meme = meme {
            memeImageView.image = meme.properties.memedImage
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

