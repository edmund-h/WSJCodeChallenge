//
//  RSSFeed.swift
//  WSJCodeChallenge
//
//  Created by Edmund Holderbaum on 5/10/19.
//  Copyright © 2019 Dawn Trigger Enterprises. All rights reserved.
//

import Foundation

enum RSSFeed: Int {
    case world = 0, business, markets, tech, opinion, lifestyle
    
    ///WARNING: Add new path along with new case in proper order!
    private static let paths = ["RSSWorldNews.xml", "WSJcomUSBusiness.xml", "RSSMarketsMain.xml", "RSSWSJD.xml", "RSSOpinion.xml", "RSSLifestyle.xml"]
    
    var htmlPath: String {
        return RSSFeed.paths[self.rawValue]
    }
}
