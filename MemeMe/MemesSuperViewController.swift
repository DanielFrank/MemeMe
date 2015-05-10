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
    var editLabel = "Edit"
    var doneLabel = "Done"
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.memes = Meme.getMemeCopy() //update in case new memes created
        self.checkCount()
    }
    
    //Open editor modually
    func editMeme() {
        let storyboard = self.storyboard
        let vc = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    //delete meme given indexPath
    func deleteMeme (indexPath: NSIndexPath) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.removeAtIndex(indexPath.row)
        self.memes = appDelegate.memes
        self.checkCount()
    }
    
    //open detailViewController given indexPath
    func openDetailVC (indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        detailController.index = indexPath.row
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    //If no memes, open editor
    func checkCount() {
        if self.memes.count == 0 {
            editMeme()
        }
        
    }
    
    //toggle the edit button when clicked
    func toggleEditButton (sender: UIBarButtonItem) {
        if sender.title == self.editLabel {
            sender.title = self.doneLabel
        } else { //assuming set to done
            sender.title = self.editLabel
        }
    }
    
    func allowEditing (editButton: UIBarButtonItem) -> Bool {
        return editButton.title == self.doneLabel
    }
    
    
}