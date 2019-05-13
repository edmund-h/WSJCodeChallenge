//
//  RSSXMLParser.swift
//  WSJCodeChallenge
//
//  Created by Edmund Holderbaum on 5/10/19.
//  Copyright © 2019 Dawn Trigger Enterprises. All rights reserved.
//

import Foundation

class RSSXMLParser: NSObject, XMLParserDelegate {
    
    var currentTitle = String()
    var currentDescription = String()
    var currentDate = String()
    var currentStoryUrl = String()
    var currentElement = String()
    
    var rssStories = [RSSStory]()
    var callback: RSSStoryCompletion = { _, _ in }
    
    //the implementation with the callback seems a little sketchy to me but I feel that having a notification would overcomplicate things and setting a delegate would be even worse.
    init(data: Data, completion: @escaping RSSStoryCompletion) {
        super.init()
        self.callback = completion
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "item" {
            currentTitle = String()
            currentDescription = String()
            currentDate = String()
            currentStoryUrl = String()
        }
        
        self.currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let story = RSSStory(
                title: currentTitle,
                date: currentDate,
                description: currentDescription,
                storyUrl: currentStoryUrl
            )
            rssStories.append(story)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        //there really should be a way to turn this into a dictionary...
        if (!data.isEmpty) {
            switch self.currentElement {
                case "title": currentTitle = data
                case "description": currentDescription = data
                case "pubDate": currentDate = data
                case "link": currentStoryUrl = data
                default: break
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        var error: WSJRSSError?
        if rssStories.count == 0 {
            error = WSJRSSError(description: "Problem parsing XML")
        }
        callback(rssStories, error)
    }
}
