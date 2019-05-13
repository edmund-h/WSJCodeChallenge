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
        self.date = date.split(separator: " ").dropLast().joined(separator: " ")
    }
}
