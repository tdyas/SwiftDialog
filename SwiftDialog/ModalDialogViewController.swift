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
    func dismissModalDialogViewController(_ modalDialogViewController: ModalDialogViewController) -> Void
}

open class ModalDialogViewController : UIViewController {
    open let dialogViewController: DialogViewController
    open let childNavigationController: UINavigationController
    open var doneButtonItem: UIBarButtonItem

    open weak var delegate: ModalDialogViewControllerDelegate?
    
    public init(
        root: RootElement,
        style: UITableViewStyle = .grouped,
        doneButtonItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    ) {
        dialogViewController = DialogViewController(root: root, style: style)
        childNavigationController = UINavigationController(rootViewController: self.dialogViewController)
        self.doneButtonItem = doneButtonItem
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func dismiss() {
        self.delegate?.dismissModalDialogViewController(self)
    }
    
    open override func loadView() {
        self.view = UIView(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.white
        self.view.isOpaque = true
        self.view.autoresizesSubviews = true
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addChildViewController(self.childNavigationController)
        self.view.addSubview(self.childNavigationController.view)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        doneButtonItem.target = self
        doneButtonItem.action = #selector(ModalDialogViewController.dismiss as (ModalDialogViewController) -> () -> ())
        dialogViewController.navigationItem.rightBarButtonItem = doneButtonItem
    }
}
