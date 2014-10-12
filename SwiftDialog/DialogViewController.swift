import Foundation
import UIKit

public class DialogViewController : UITableViewController {
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
    
    public convenience init(root: RootElement!) {
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
