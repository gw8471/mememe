//
//  TableVC.swift
//  Meme
//
//  Created by Gary Wang on 4/2/15.
//  Copyright (c) 2015 self. All rights reserved.
//


import Foundation
import UIKit

class TableVC: UIViewController, UITableViewDataSource, UITableViewDelegate , UINavigationControllerDelegate {
    // define global variable
    var Totalmemes :[Meme]!
    let appDelegate  = UIApplication.sharedApplication().delegate as AppDelegate

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        Totalmemes = appDelegate.memes
        
        //add navigation bar item standard way
        let myBarButton_1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "AddRecords:")
        let myRightButtons: NSArray = [myBarButton_1]
        self.navigationController?.navigationBar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem
        self.navigationItem.title = "Sent Meme"
        self.navigationItem.setRightBarButtonItems(myRightButtons, animated: true)

    }

 
    override func viewWillAppear(animated: Bool) {
    }
    
    
    //add new picture
    func AddRecords(sender: UIButton){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var nextVC = mainStoryboard.instantiateViewControllerWithIdentifier("EditorVC") as EditorVC
        //push to editorVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // return total meme for tableview display
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Totalmemes.count
    }
    
    //load table view cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableList : Meme = self.Totalmemes[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell")as UITableViewCell
        cell.textLabel?.text = tableList.topText + " " + tableList.bottomText
        cell.detailTextLabel?.text =  tableList.bottomText
        cell.imageView?.image = tableList.memeimage
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        return cell as UITableViewCell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //send selected image to detail view
        let detailCtlr = self.storyboard!.instantiateViewControllerWithIdentifier("DetailVC")! as DetailVC
        detailCtlr.meme = self.Totalmemes[indexPath.row]
        self.navigationController!.pushViewController(detailCtlr, animated: true)
    }

    deinit {
        
        println("deinit tableVC")
        
    }

}