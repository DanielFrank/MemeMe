//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Daniel Frank on 5/8/15.
//  Copyright (c) 2015 Daniel Frank. All rights reserved.
//

import UIKit

class MemeDetailViewController : UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var meme: Meme!
    var index: Int!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit

        self.imageView!.image = self.meme.memedImage
        
        self.tabBarController?.tabBar.hidden = true
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    
    @IBAction func deleteMeme(sender: UIBarButtonItem) {
        print("DELETE")
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.removeAtIndex(self.index)

        self.navigationController!.popViewControllerAnimated(true)
        
    }

    
    
    
}
