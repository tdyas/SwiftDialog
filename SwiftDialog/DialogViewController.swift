import Foundation
import UIKit

class DialogViewController : UITableViewController {
    let style: UITableViewStyle = .Grouped
    var rootElement: RootElement!
    var dialogController: DialogController!

    init(root: RootElement!, style: UITableViewStyle) {
        self.style = style
        super.init(style: style)
        self.rootElement = root
        self.dialogController = DialogController(self.rootElement)
        self.rootElement.dialogController = self.dialogController
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dialogController
        self.tableView.delegate = self.dialogController
        
        self.navigationItem.title = self.rootElement.title
    }
}
