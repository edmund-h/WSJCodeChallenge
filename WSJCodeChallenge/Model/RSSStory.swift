//
//  RSSStory.swift
//  WSJCodeChallenge
//
//  Created by Edmund Holderbaum on 5/10/19.
//  Copyright © 2019 Dawn Trigger Enterprises. All rights reserved.
//

import Foundation

struct RSSStory {
    let title: String
    let date: String
    let description: String
    let storyUrl: String
    
    init(title: String, date: String, description: String, storyUrl: String) {
        self.title = title
        self.description = description
        self.storyUrl = storyUrl
        
        //Since the date was already formatted I decided to just operate on the string. Date formatters are annoying but I would use one if we were going to be adding other feeds or wanted a specific date format. I really enjoy using chained string methods.
        self.date = date.split(separator: " ").dropLast().joined(separator: " ")
    }
}
