//
//  MemeCollectionViewCell.swift
//  MemeMeV2
//
//  Created by Lorrayne Paraiso  on 22/09/18.
//  Copyright © 2018 Lorrayne Paraiso. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var memeImageView: UIImageView!

    func fill(with meme: Meme) {
        memeImageView.image = meme.properties.memedImage
    }
}

