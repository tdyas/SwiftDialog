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

import UIKit

//
// Unfortunately, a bug in how Swift handles UITableViewController makes
// this reimplementation of UITableViewController necessary. Specifically,
// even though UITableViewController.init(style:) is the supposedly the designated
// initializer for UITableViewController, Swift does not like the fact that
// init(style:) calls UIViewController.init() which in turn calls the subclass
// implementation of init(nibName, bundle). This causes all variables to be 
// reinitialized to default values which makes for "fun" when subclassing
// UITableViewController in Swift.
//
// This basic reimplementation of UITableViewController fixes the issue.
//
public class SwiftTableViewController : UIViewController {
    public let style: UITableViewStyle
    public var tableView: UITableView!
    public var clearsSelectionOnViewWillAppear: Bool = true
    public var refreshControl: UIRefreshControl? {
        willSet {
            if let control = refreshControl {
                control.removeFromSuperview()
            }
        }

        didSet {
            if let control = refreshControl {
                tableView.addSubview(control)
            }
        }
    }
    
    var hasBeenShownOnce: Bool = false
    var keyboardRectOpt: CGRect?
    var isVisible: Bool = false
    
    public init(style: UITableViewStyle) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        let screenBounds = UIScreen.mainScreen().bounds
        
        self.view = UIView(frame: screenBounds)
        self.view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]

        self.tableView = UITableView(frame: screenBounds, style: style)
        self.tableView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.view.addSubview(tableView)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "willShowKeyboard:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "willHideKeyboard:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    public override func viewWillLayoutSubviews() {
        var bounds = view.bounds
        
        if let keyboardRect = self.keyboardRectOpt {
            bounds.size.height = keyboardRect.minY - bounds.origin.y
        }
        
        tableView.frame = bounds
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if !hasBeenShownOnce {
            tableView.reloadData()
            hasBeenShownOnce = true
        }
        
        if clearsSelectionOnViewWillAppear {
            if let indexPaths = tableView.indexPathsForSelectedRows {
                for indexPath in indexPaths {
                    tableView.deselectRowAtIndexPath(indexPath, animated: animated)
                }
            }
        }
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.flashScrollIndicators()
        isVisible = true
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        isVisible = false
    }
    
    public override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    func willShowKeyboard(notification: NSNotification!) {
        let userInfo = notification.userInfo
        
        if let keyboardRectValue = userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            keyboardRectOpt = self.view.convertRect(keyboardRectValue.CGRectValue(), fromView: nil)
            
            if isVisible {
                let animationDurationOpt = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
                let animationDuration = animationDurationOpt?.doubleValue ?? 1.0
                
                UIView.animateWithDuration(animationDuration, animations: {
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                })
            } else {
                self.view.setNeedsLayout()
            }
        }
    }
    
    func willHideKeyboard(notification: NSNotification!) {
        keyboardRectOpt = nil
        
        if isVisible {
            let userInfo = notification.userInfo
            let animationDurationOpt = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
            let animationDuration = animationDurationOpt?.doubleValue ?? 1.0
            
            UIView.animateWithDuration(animationDuration, animations: {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            })
        } else {
            self.view.setNeedsLayout()
        }
    }
}
