//
//  MemesSuperViewController.swift
//  MemeMe
//
//  Created by Daniel Frank on 5/10/15.
//  Copyright (c) 2015 Daniel Frank. All rights reserved.
//
//MemeCollectionViewController and MemeTableViewController repeat code. So set up super class to contain this code

import UIKit

class MemesSuperViewController: UIViewController {
    
    
    var memes = [Meme]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.memes = Meme.getMemeCopy() //update in case new memes created
        if self.memes.count == 0 {
            editMeme()
        }
    }
    
    //Open editor modually
    func editMeme() {
        let storyboard = self.storyboard
        let vc = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    //open detailViewController given indexPath
    func openDetailVC (indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        detailController.index = indexPath.row
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    
}