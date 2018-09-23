//
//  MemeTableViewCell.swift
//  MemeMeV2
//
//  Created by Lorrayne Paraiso  on 22/09/18.
//  Copyright © 2018 Lorrayne Paraiso. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memeTopText: UILabel!
    @IBOutlet weak var memeBottomText: UILabel!
    @IBOutlet weak var memeImage: UIImageView!

    func fill(with meme: Meme) {
        memeImage.image = meme.properties.memedImage
        memeTopText.text = meme.properties.topText
        memeBottomText.text = meme.properties.bottomText
    }
}
