//
//  RSSCell.swift
//  WSJCodeChallenge
//
//  Created by Edmund Holderbaum on 5/10/19.
//  Copyright © 2019 Dawn Trigger Enterprises. All rights reserved.
//

import UIKit

class RSSCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var url: URL?
    
    func setup(for story: RSSStory) {
        self.gestureRecognizers = nil
        self.titleLabel.text = story.title
        self.dateLabel.text = story.date
        self.descriptionLabel.text = story.description
        
        if let storyURL = URL(string: story.storyUrl) {
            self.url = storyURL
        }
    }
}
