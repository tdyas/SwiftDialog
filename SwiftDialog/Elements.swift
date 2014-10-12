import UIKit

class Element : NSObject {
    var parent: Element? = nil
    
    var root: RootElement? {
        get {
            var elementOpt = self.parent
            
            while (elementOpt != nil) {
                if let element = elementOpt {
                    if let elementAsRoot = element as? RootElement {
                        return elementAsRoot
                    }

                    elementOpt = element.parent
                }
            }
            
            return nil
        }
    }
    
    func getCell(tableView: UITableView) -> UITableViewCell! {
        fatalError("This method must be overridden")
    }
    
    func elementSelected(dialogController: DialogController, tableView: UITableView, atPath indexPath: NSIndexPath) {
    }

    func elementDeselected(dialogController: DialogController, tableView: UITableView, atPath indexPath: NSIndexPath) {
    }
}

class RootElement : Element {
    var sections: [SectionElement]
    var title: String = ""
    var dialogController: DialogController?
    
    init(title: String, sections: [SectionElement]) {
        self.title = title
        self.sections = sections
        
        super.init()
        
        for section in self.sections {
            section.parent = self
        }
    }
}

class SectionElement : Element {
    var elements: [Element]
    var header: String?
    var footer: String?
    
    init(elements: [Element], withHeader header: String?, withFooter footer: String?) {
        self.elements = elements
        self.header = header
        self.footer = footer

        super.init()
        
        for element in self.elements {
            element.parent = self
        }
    }
    
    convenience init(elements: [Element]) {
        self.init(elements: elements, withHeader: nil, withFooter: nil)
    }
}

class LabelElement : Element {
    var text: String?
    
    init(_ text: String) {
        self.text = text
    }
    
    override func getCell(tableView: UITableView) -> UITableViewCell! {
        let cellKey = "label"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellKey) as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellKey)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        
        cell.textLabel?.text = self.text
        
        return cell
    }
}

class TextEntryCell : UITableViewCell {
    weak var tableView: UITableView!
    var textField: UITextField?
    
    init(tableView: UITableView, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        self.tableView = tableView
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame = self.contentView.bounds
        let inset = self.tableView.separatorInset
        frame.origin.x += inset.left
        frame.size.width -= inset.left
        frame.size.width -= inset.right

        self.textField?.frame = frame
    }
}

class TextEntryElement : Element, UITextFieldDelegate {
    private var cachedText: String = ""
    private var textField: UITextField?

    var text: String {
        get {
            switch (self.textField) {
            case .Some(let textField):
                let text = textField.text
                self.cachedText = text
                return text
                
            case .None:
                return self.cachedText
            }
        }
        set {
            self.cachedText = newValue
            if let textField = self.textField {
                textField.text = newValue
            }
        }
    }
    
    init(_ text: String) {
        super.init()
        self.text = text
    }
    
    func valueChanged(textField: UITextField!) {
        self.text = textField.text
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        self.text = textField.text
    }
    
    override func getCell(tableView: UITableView) -> UITableViewCell! {
        let cellKey = "textEntry"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellKey) as TextEntryCell!
        if cell == nil {
            cell = TextEntryCell(tableView: tableView, reuseIdentifier: cellKey)
            cell.selectionStyle = .None
        }
        
        if let textField = self.textField {
            if textField.superview != cell {
                textField.removeFromSuperview()
                cell.contentView.addSubview(textField)
                cell.textField = textField
            }
        } else {
            let textField = UITextField(frame: CGRect.zeroRect)
            textField.text = self.text
            cell.contentView.addSubview(textField)
            cell.textField = textField
            self.textField = textField
        }
        
        self.textField!.text = self.text

        return cell
    }
}

class BoolElement : Element {
    private var switchControl: UISwitch!
    
    var caption: String = ""
    var value: Bool = false
    
    init(caption: String = "", value: Bool = false) {
        super.init()
        self.caption = caption
        self.value = value
    }
    
    func valueChanged() {
        self.value = self.switchControl.on
    }
    
    override func getCell(tableView: UITableView) -> UITableViewCell! {
        let cellKey = "BoolElement"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellKey) as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellKey)
            cell.selectionStyle = .None
        }
        
        if self.switchControl == nil {
            self.switchControl = UISwitch()
            self.switchControl.backgroundColor = UIColor.clearColor()
            self.switchControl.addTarget(self, action: "valueChanged", forControlEvents: .ValueChanged)
        }
        
        if !self.switchControl.isDescendantOfView(cell)  {
            switchControl.removeFromSuperview()
        }
        cell.accessoryView = switchControl

        cell.textLabel?.text = self.caption
        self.switchControl.on = self.value
        
        return cell
    }
}
