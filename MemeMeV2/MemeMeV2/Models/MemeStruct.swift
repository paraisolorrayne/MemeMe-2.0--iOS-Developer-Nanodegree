//
//  MemeStruct.swift
//  MemeMeV1
//
//  Created by cedro_nds on 21/07/18.
//  Copyright © 2018 Lorrayne Paraiso. All rights reserved.
//

import UIKit

typealias MemeProperties = MemeScene.Meme

struct MemeScene {
    struct Meme {
        let topText: String
        let bottomText: String
        let originalImage: UIImage
        let memedImage: UIImage
    }
}

class Meme: NSObject, NSCoding {
    
    var properties: MemeProperties!
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("memes")
    
    //MARK: Types
    
    struct PropertyKey {
        static let topText = "topText"
        static let bottomText = "bottomText"
        static let originalImage = "originalImage"
        static let memeImage = "memeImage"
    }
    
    //MARK: Initialization
    init?(topText: String,bottomText: String, originalImage: UIImage, memeImage: UIImage) {
        // Initialize stored properties.
        properties = MemeProperties(topText: topText, bottomText: bottomText, originalImage: originalImage, memedImage: memeImage)
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(properties.topText, forKey: PropertyKey.topText)
        aCoder.encode(properties.bottomText, forKey: PropertyKey.bottomText)
        aCoder.encode(properties.originalImage, forKey: PropertyKey.originalImage)
        aCoder.encode(properties.memedImage, forKey: PropertyKey.memeImage)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let topText = aDecoder.decodeObject(forKey: PropertyKey.topText) as! String
        let bottomText = aDecoder.decodeObject(forKey: PropertyKey.bottomText) as! String
        let originalImage = aDecoder.decodeObject(forKey: PropertyKey.originalImage) as! UIImage
        let memeImage = aDecoder.decodeObject(forKey: PropertyKey.memeImage) as! UIImage
        
        self.init(topText: topText, bottomText: bottomText, originalImage: originalImage, memeImage: memeImage)
    }
}
