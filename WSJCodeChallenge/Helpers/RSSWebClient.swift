//
//  RSSWebClient.swift
//  WSJCodeChallenge
//
//  Created by Edmund Holderbaum on 5/10/19.
//  Copyright © 2019 Dawn Trigger Enterprises. All rights reserved.
//

import Foundation

typealias RSSStoryCompletion = ([RSSStory], Error?) -> ()

final class RSSWebClient {
    
    static func getStories(for feed: RSSFeed, completion: @escaping RSSStoryCompletion) {
        let urlSession = URLSession(configuration: .default)
        
        var dataTask: URLSessionDataTask
        let urlStr = "https://feeds.a.dj.com/rss/"
        let query = feed.htmlPath
        
        guard let url = URL(string: urlStr + query) else {
            completion([], WSJRSSError(description: "Bad URL"))
            return
        }
        
        dataTask = urlSession.dataTask(with: url) { data, urlResponse, error in
            guard error == nil,
                let response = urlResponse as? HTTPURLResponse,
                response.statusCode == 200, let data = data else {
                    let error: Error = error ?? WSJRSSError(description: "RedditClient: No Response")
                    completion([], error)
                    return
            }
            
            let _ = RSSXMLParser(data: data, completion: completion)
        }
        dataTask.resume()
    }
    
}
