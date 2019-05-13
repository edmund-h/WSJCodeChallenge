//
//  WebViewController.swift
//  WSJCodeChallenge
//
//  Created by Edmund Holderbaum on 5/10/19.
//  Copyright © 2019 Dawn Trigger Enterprises. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    //MARK: Properties and Outlets
    @IBOutlet weak var webView: WKWebView!
    
    var url: URL?
    
    //MARK: Overrides and Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
