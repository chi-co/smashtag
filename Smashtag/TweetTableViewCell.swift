//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Danila Bustamante on 10/04/16.
//  Copyright © 2016 Francisco Aso. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    var tweet : Tweet? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    func updateUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📸"
                 }
            }
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet user description
            
            if let profileImageURL = tweet.user.profileImageURL {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if let imageData = NSData(contentsOfURL: profileImageURL) { // blocks main thread!
                        self.tweetProfileImageView?.image = UIImage(data: imageData)
                    }
                }
                
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
    }
}
