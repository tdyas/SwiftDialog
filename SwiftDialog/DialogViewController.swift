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

public class DialogViewController : UITableViewController {
    var rootElement: RootElement!
    var dialogController: DialogController!

    init?(root: RootElement, style: UITableViewStyle) {
        super.init(style: style)
        self.rootElement = root
        self.dialogController = DialogController(self.rootElement)
        self.rootElement.dialogController = self.dialogController
    }
    
    public convenience init?(root: RootElement) {
        self.init(root: root, style: .Grouped)
    }
    
    public override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dialogController
        self.tableView.delegate = self.dialogController
        
        self.navigationItem.title = self.rootElement.title
    }
}
