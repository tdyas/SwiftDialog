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

public protocol ModalDialogViewControllerDelegate : class {
    func dismissModalDialogViewController(modalDialogViewController: ModalDialogViewController) -> Void
}

public class ModalDialogViewController : UIViewController {
    public let dialogViewController: DialogViewController
    public let childNavigationController: UINavigationController

    public weak var delegate: ModalDialogViewControllerDelegate?
    
    public init(root: RootElement, style: UITableViewStyle) {
        self.dialogViewController = DialogViewController(root: root, style: style)!
        self.childNavigationController = UINavigationController(rootViewController: self.dialogViewController)
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init(root: RootElement) {
        self.init(root: root, style: .Grouped)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func doneTapped() {
        self.delegate?.dismissModalDialogViewController(self)
    }
    
    public override func loadView() {
        self.view = UIView(frame: UIScreen.mainScreen().bounds)
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
