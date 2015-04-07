//
//  Meme.swift
//  Meme
//
//  Created by Gary Wang on 3/28/15.
//  Copyright (c) 2015 self. All rights reserved.
//

import Foundation
import UIKit


//define meme class
class Meme : NSObject {
    var topText : String
    var bottomText : String
    var image : UIImage
    var memeimage : UIImage
    //var selectedIndex: String
    
    init(topT : String, bottomT : String, img : UIImage, memeimage : UIImage)
    {
        self.topText = topT
        self.bottomText = bottomT
        self.image = img
        self.memeimage = memeimage
    }

   
}
