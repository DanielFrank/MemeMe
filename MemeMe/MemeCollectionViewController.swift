//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Daniel Frank on 5/8/15.
//  Copyright (c) 2015 Daniel Frank. All rights reserved.
//

import UIKit

class MemeCollectionViewController: MemesSuperViewController, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        self.collectionView.reloadData()
    }
    
    
    @IBAction func add(sender: UIBarButtonItem) {
        self.editMeme()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the image
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        self.openDetailVC(indexPath)
    }
    
}