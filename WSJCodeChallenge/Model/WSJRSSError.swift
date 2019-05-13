//
//  WSJRSSError.swift
//  WSJCodeChallenge
//
//  Created by Edmund Holderbaum on 5/13/19.
//  Copyright © 2019 Dawn Trigger Enterprises. All rights reserved.
//

import Foundation

struct WSJRSSError: Error {
    let description: String
    
    var localizedDescription: String {
        return description
    }
    
}
