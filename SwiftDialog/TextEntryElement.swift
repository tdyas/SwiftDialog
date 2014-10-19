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

class TextEntryCell : UITableViewCell {
    weak var tableView: UITableView!
    var textField: UITextField?
    
    init?(tableView: UITableView, reuseIdentifier: String!) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
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

public class TextEntryElement : Element, UITextFieldDelegate {
    private var cachedText: String = ""
    private var textField: UITextField?
    
    public var text: String {
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
    
    public init(_ text: String = "") {
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
    
    public override func getCell(tableView: UITableView) -> UITableViewCell! {
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
