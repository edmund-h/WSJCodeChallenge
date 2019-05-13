//
//  ViewController.swift
//  WSJCodeChallenge
//
//  Created by Edmund Holderbaum on 5/10/19.
//  Copyright © 2019 Dawn Trigger Enterprises. All rights reserved.
//

import UIKit

class RSSViewController: UIViewController {
    
    @IBOutlet weak var feedSelector: UISegmentedControl!
    @IBOutlet weak var storyTable: UITableView!
    
    var stories: [RSSStory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storyTable.rowHeight = UITableView.automaticDimension
        
        let swipeLeft = UIPanGestureRecognizer(target: self, action: #selector(swipeDetected(sender:)))
        swipeLeft.delegate = self
        self.view.addGestureRecognizer(swipeLeft)
        
        fetchStories()
        checkFirstUse()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sender = sender as? RSSCell, let destination = segue.destination as? WebViewController {
            destination.url = sender.url
        }
    }
    
    @IBAction func feedSelectorChangedValue() {
        if stories.count > 0 {
            let indexPath =  IndexPath(row: 0, section: 0)
            storyTable.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        //reset the data to let the user know that their action did something when they swiped. this comes after scrolling to prevent crashes
        stories = []
        storyTable.reloadData()
        fetchStories()
    }
    
    @objc func swipeDetected(sender: UIPanGestureRecognizer) {
        //I find this easier than implementing a complicated and memory-costly page control to allow swiping between categories
        var newIndex: Int
        let translation = sender.translation(in: self.view)
        
        guard abs(translation.x) > abs(translation.y) * 3,
            sender.state == .ended else {return}
        
        if translation.x > 0 {
            newIndex = feedSelector.selectedSegmentIndex + (feedSelector.numberOfSegments - 1)
        } else {
            newIndex = feedSelector.selectedSegmentIndex + 1
        }
        
        let newSelection = newIndex % feedSelector.numberOfSegments
        feedSelector.selectedSegmentIndex = newSelection
        feedSelectorChangedValue()
    }
    
    func fetchStories() {
        let feedType = RSSFeed(rawValue: feedSelector.selectedSegmentIndex)!
        RSSWebClient.getStories(for: feedType, completion: { stories, error in 
            if let error = error { self.displayError(error) }
            self.stories = stories
            DispatchQueue.main.async {
                self.storyTable.reloadData()
            }
        })
    }
    
    func checkFirstUse() {
        // this is to let the user know that they can swipe back and forth, something that wouldn't be immediately obvious otherwise
        let firstUseKey = "firstUse"
        if let _ = UserDefaults.standard.string(forKey: firstUseKey) {
            return
        }
        let alert = UIAlertController(title: "Welcome!", message: "Swipe left or right to navigate between RSS Categories.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            _ in alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: {
            let date = ISO8601DateFormatter().string(from: Date())
            UserDefaults.standard.set(date, forKey: firstUseKey)
        })
    }
    
    func displayError(_ error: Error) {
        
        let alert = UIAlertController(title: "An error occurred!", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: {
            _ in alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension RSSViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RSSCell
        let story = stories[indexPath.row]
        cell.setup(for: story)
        return cell
    }

    
}

extension RSSViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
