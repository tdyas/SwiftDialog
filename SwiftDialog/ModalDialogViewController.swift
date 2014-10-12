import Foundation
import UIKit

protocol ModalDialogViewControllerDelegate {
    func dismissModalDialogViewController(modalDialogViewController: ModalDialogViewController) -> Void
}

class ModalDialogViewController : UIViewController {
    var style: UITableViewStyle = .Grouped
    var delegate: ModalDialogViewControllerDelegate?
    var dialogViewController: DialogViewController!
    var childNavigationController: UINavigationController!
    
    var context: AnyObject?
    
    init(root: RootElement!, style: UITableViewStyle) {
        super.init(nibName: nil, bundle: nil)
        self.style = style
        self.dialogViewController = DialogViewController(root: root, style: self.style)
        self.childNavigationController = UINavigationController(rootViewController: self.dialogViewController)
    }
    
    convenience init(root: RootElement!) {
        self.init(root: root, style: .Grouped)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func doneTapped() {
        self.delegate?.dismissModalDialogViewController(self)
    }
    
    override func loadView() {
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
