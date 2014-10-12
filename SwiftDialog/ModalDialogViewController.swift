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

public protocol ModalDialogViewControllerDelegate {
    func dismissModalDialogViewController(modalDialogViewController: ModalDialogViewController) -> Void
}

public class ModalDialogViewController : UIViewController {
    var style: UITableViewStyle = .Grouped
    var delegate: ModalDialogViewControllerDelegate?
    var dialogViewController: DialogViewController!
    var childNavigationController: UINavigationController!
    
    var context: AnyObject?
    
    public init(root: RootElement!, style: UITableViewStyle) {
        super.init(nibName: nil, bundle: nil)
        self.style = style
        self.dialogViewController = DialogViewController(root: root, style: self.style)
        self.childNavigationController = UINavigationController(rootViewController: self.dialogViewController)
    }
    
    public convenience init(root: RootElement!) {
        self.init(root: root, style: .Grouped)
    }
    
    public override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func doneTapped() {
        self.delegate?.dismissModalDialogViewController(self)
    }
    
    public override func loadView() {
        let bounds = UIScreen.mainScreen().bounds
        
        self.view = UIView(frame: bounds)
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.opaque = true
        self.view.autoresizesSubviews = true
        self.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        self.addChildViewController(self.childNavigationController)
        self.view.addSubview(self.childNavigationController.view)
        
        let doneItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Done,
            target: self,
            action: "doneTapped"
        )
        self.dialogViewController.navigationItem.rightBarButtonItem = doneItem
    }
}
