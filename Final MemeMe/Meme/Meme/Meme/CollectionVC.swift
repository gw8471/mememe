//
//  CollectionVC.swift
//  Meme
//
//  Created by Gary Wang on 4/2/15.
//  Copyright (c) 2015 self. All rights reserved.
//
//http://www.appcoda.com/use-storyboards-to-build-navigation-controller-and-table-view/
import Foundation
import UIKit


let reuseIdentifier = "mycell"

class CollectionVC : UIViewController,  UITableViewDelegate ,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,
     UICollectionViewDelegate
{
    //global variable
    @IBOutlet weak var myCollectionView: UICollectionView!
    var imageview :UIImageView!
    var Totalmemes :[Meme]!
    let appDelegate  = UIApplication.sharedApplication().delegate as AppDelegate
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup background color
        self.view.backgroundColor = UIColor.whiteColor()
        Totalmemes = appDelegate.memes
        imageview = UIImageView()
        myCollectionView?.delegate = self
        myCollectionView?.dataSource = self
        
        //setup collection Layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(50, 50)
        layout.sectionInset = UIEdgeInsetsMake(16, 16, 32, 16)
        layout.headerReferenceSize = CGSizeMake(100,30)
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "mycell")
    }
    
    override func viewWillAppear(animated: Bool) {
        //add navigationbar
        self.navigationItem.title = "Sent Meme"
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "Add:")
        self.navigationItem.rightBarButtonItem = addButton
    }

    //add new picture
    func Add(sender: UIButton){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var nextVC = mainStoryboard.instantiateViewControllerWithIdentifier("EditorVC") as EditorVC
        self.navigationController?.pushViewController(nextVC, animated: true)
     
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //push image to detailview
        let detailCtlr = self.storyboard!.instantiateViewControllerWithIdentifier("DetailVC")! as DetailVC
        detailCtlr.meme = self.Totalmemes[indexPath.row]
        self.navigationController!.pushViewController(detailCtlr, animated: true)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return total meme count
        return Totalmemes.count
    }
    
    //Cell value setup
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:  MyCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("mycell", forIndexPath: indexPath) as MyCollectionViewCell
        let cellElm = self.Totalmemes[indexPath.row]
        cell.imageView.image = cellElm.memeimage
        cell.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
    
    
    deinit {
        println("deinit collectionVC")
    }

    
    }