//
//  Meme.swift
//  MemeMe
//
//  Created by Daniel Frank on 5/5/15.
//  Copyright (c) 2015 Daniel Frank. All rights reserved.
//

import UIKit

class Meme {
    
    var topString: String?
    var bottomString: String?
    var originalImage: UIImage?
    var memedImage: UIImage?
    
    init(topString :String, bottomString:String, image: UIImage, memedImage: UIImage) {
        self.topString = topString
        self.bottomString = bottomString
        self.originalImage = image
        self.memedImage = memedImage
    }
    
    //Note that arrays get returned by value so this is a read-only copy
    static func getMemeCopy() -> [Meme] {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
}
