//
//  MemeEditViewController.swift
//  Meme
//
//  Created by Gary Wang on 3/28/15.
//  Copyright (c) 2015 self. All rights reserved.
//

import Foundation
import UIKit

class MemeEditViewController : NSObject {
    var topTextField: UITextField!
    var bottomTextField: UITextField!
    init(topTextField: UITextField!
        , bottomTextField: UITextField!)
    {   topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
    }
}

