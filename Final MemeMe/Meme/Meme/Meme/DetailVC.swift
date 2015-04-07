//
//  DetailVC.swift
//  Meme
//
//  Created by Gary Wang on 4/2/15.
//  Copyright (c) 2015 self. All rights reserved.
//


import UIKit


class DetailVC: UIViewController
    {
    
    var Totalmemes :[Meme]!
   // @IBOutlet weak var selectedIndex

     var meme: Meme!
    @IBOutlet weak var imageView: UIImageView!
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
   
    override func viewDidLoad() {
        //setup image view load image
        Totalmemes = appDelegate.memes
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        var myimage = meme?.memeimage
        imageView.image = myimage
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        self.view.addSubview(imageView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //setup navi
         self.navigationController?.navigationBar
         self.navigationItem.title = "DetailMeme"
           }

    
    deinit {
        println("deinit DetailVC")
    }
}



    
    
    
