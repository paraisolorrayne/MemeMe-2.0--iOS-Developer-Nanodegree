//
//  MemeList.swift
//  MemeMeV2
//
//  Created by Lorrayne Paraiso  on 22/09/18.
//  Copyright © 2018 Lorrayne Paraiso. All rights reserved.
//

import Foundation
import UIKit


final class MemeList: NSObject {
    

    private var memes = [Meme]()
    
    //Singleton Instance class
    static let sharedInstance = MemeList()
    
    //Load memeFrom local persistence
    private override init() {
        super.init()
        
        if let loadMemes = loadMemes() {
            memes = loadMemes
        }
    }
    
    //Save memes localy
    private func persistMemes() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(memes, toFile: Meme.ArchiveURL.path)
        if isSuccessfulSave {
            print("meme saved successfully")
        } else {
            print("Failed to save memes...")
        }
    }
    
    //Get memes from local persistence
    private func loadMemes() -> [Meme]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meme.ArchiveURL.path) as? [Meme]
    }
    
    //Get memes to list
    func getMemes() -> [Meme] {
        return memes
    }
    
    //Add new meme
    func addMeme(meme: Meme) {
        memes.append(meme)
        persistMemes()
    }
    
    func removeMeme(at: Int) {
        memes.remove(at: at)
        persistMemes()
    }
}

