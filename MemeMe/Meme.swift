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
        self.memedImage = image
    }
    
}
