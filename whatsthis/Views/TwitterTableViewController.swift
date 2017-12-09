//
//  TwitterTableViewController.swift
//  whatsthis
//
//  Created by Edwin Abraham on 12/8/17.
//  Copyright © 2017 Edwin Abraham. All rights reserved.
//

import UIKit
import TwitterKit

class TwitterTableViewController: TWTRTimelineViewController {
    
    convenience init(searchString: String) {
        let client = TWTRAPIClient()
        let dataSource = TWTRSearchTimelineDataSource(searchQuery: searchString, apiClient: client)
        self.init(dataSource: dataSource)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
