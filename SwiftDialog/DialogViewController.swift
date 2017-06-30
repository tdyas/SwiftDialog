// Copyright 2014 Thomas K. Dyas
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import UIKit

open class DialogViewController : SwiftTableViewController {
    open var root: RootElement
    open var dialogController: DialogController

    public init(root: RootElement, style: UITableViewStyle = .grouped) {
        self.root = root
        self.dialogController = DialogController(self.root)
        self.root.dialogController = self.dialogController
        
        super.init(style: style)

        self.dialogController.viewController = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self.dialogController
        self.tableView.delegate = self.dialogController
        
        self.navigationItem.title = self.root.title
        
        if self.root.onRefresh != nil {
            self.refreshControl = UIRefreshControl(frame: CGRect.zero)
            self.refreshControl!.addTarget(self, action: #selector(DialogViewController.triggerRefresh), for: .valueChanged)
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @objc func triggerRefresh() {
        if let callback = self.root.onRefresh {
            callback(self.root)
        }
    }

    open func beginRefreshing() {
        self.refreshControl!.beginRefreshing()
    }
    
    open func endRefreshing() {
        self.refreshControl!.endRefreshing()
    }
}
