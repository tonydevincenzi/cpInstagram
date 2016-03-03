//
//  ViewController.swift
//  cpInstagram
//
//  Created by Anthony Devincenzi on 3/3/16.
//  Copyright © 2016 Tony DeVincenzi. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var photos:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let accesstoken = "5110686.1677ed0.8c9da04f25c84047ad73df70e0071713"
        let url = NSURL(string: "https://api.instagram.com/v1/tags/nofilter/media/recent?access_token=\(accesstoken)")!
        let request = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            do {
                let responseDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                self.photos = responseDictionary["data"] as! NSArray
                self.tableView.reloadData()
                //print("response: \(self.photos)")
            } catch {
                print("Fetch failed: \((error as NSError).localizedDescription)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return photos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("photoCell") as! PhotoCell
        
        //We switched this to indexPath.section from indexPath.row b/c of the 1:1 row to section relationship
        let photo = photos[indexPath.section] as! NSDictionary
        
        let photoURL = photo.valueForKeyPath("images.standard_resolution.url") as! String
        cell.photoImageView.setImageWithURL(NSURL(string: photoURL)!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let photo = photos[section] as! NSDictionary
        let user = photo["user"] as! NSDictionary
        let username = user["username"] as! String
        let profileUrl = NSURL(string: user["profile_picture"] as! String)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1
        profileView.setImageWithURL(profileUrl!)
        headerView.addSubview(profileView)
        
        let usernameLabel = UILabel(frame: CGRect(x: 50, y: 10, width: 250, height: 30))
        usernameLabel.text = username
        usernameLabel.font = UIFont.boldSystemFontOfSize(16)
        usernameLabel.textColor = UIColor(red: 8/255.0, green: 64/255.0, blue: 127/255.0, alpha: 1)
        headerView.addSubview(usernameLabel)
        
        return headerView
    }
}

