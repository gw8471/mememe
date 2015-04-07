//
//  MemeCollectionController.swift
//  Meme
//
//  Created by Gary Wang on 3/28/15.
//  Copyright (c) 2015 self. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController : UICollectionViewController {
    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    var memes: [Meme]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        memes = applicationDelegate.memes
    }
}
