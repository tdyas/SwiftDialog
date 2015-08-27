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
    var textField: UITextField!
    
    init(tableView: UITableView, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        self.tableView = tableView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        let inset = self.tableView.separatorInset
        let contentFrame = self.contentView.bounds.insetBy(dx: inset.left, dy: 0)
        
        super.layoutSubviews()
        
        var textRect = CGRect.zero
        if let text = self.textLabel!.text {
            if text != "" {
                let context = NSStringDrawingContext()
                let infiniteSize = CGSize(width: CGFloat.max, height: CGFloat.max)
                textRect = text.boundingRectWithSize(infiniteSize, options: .TruncatesLastVisibleLine, attributes: nil, context: context)
            }

            let textFieldMinX = contentFrame.minX + textRect.size.width + 20
            let textFieldFrame = CGRect(
                x: textFieldMinX,
                y: contentFrame.origin.y,
                width: contentFrame.maxX - textFieldMinX,
                height: contentFrame.size.height
            )
            textField.frame = textFieldFrame
        } else {
            textField.frame = contentFrame
        }
    }
}

public class TextEntryElement : Element, UITextFieldDelegate {
    private var cachedText: String = ""
    private var textField: UITextField!
    
    public var text: String {
        get {
            switch (self.textField) {
            case .Some(let textField):
                let text = textField.text
                self.cachedText = text!
                return text!
                
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
    
    public var title: String?
    public var placeholder: String?
    
    public var autocapitalizationType: UITextAutocapitalizationType
    public var autocorrectionType: UITextAutocorrectionType
    public var spellCheckingType: UITextSpellCheckingType
    public var keyboardType: UIKeyboardType
    public var keyboardAppearance: UIKeyboardAppearance
    public var secureTextEntry: Bool
    
    public init(
        text: String = "",
        title: String? = nil,
        placeholder: String? = nil,
        autocapitalizationType: UITextAutocapitalizationType = .Sentences,
        autocorrectionType: UITextAutocorrectionType = .Default,
        spellCheckingType: UITextSpellCheckingType = .Default,
        keyboardType: UIKeyboardType = .Default,
        keyboardAppearance: UIKeyboardAppearance = .Default,
        secureTextEntry: Bool = false
    ) {
        self.title = title
        self.placeholder = placeholder
        
        self.autocapitalizationType = autocapitalizationType
        self.autocorrectionType = autocorrectionType
        self.spellCheckingType = spellCheckingType
        self.keyboardType = keyboardType
        self.keyboardAppearance = keyboardAppearance
        self.secureTextEntry = secureTextEntry
        
        super.init()
        
        self.text = text
    }
    
    func valueChanged(textField: UITextField!) {
        self.text = textField.text!
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        self.text = textField.text!
    }
    
    public override func getCell(tableView: UITableView) -> UITableViewCell! {
        let cellKey = "textEntry"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellKey) as! TextEntryCell!
        if cell == nil {
            cell = TextEntryCell(tableView: tableView, reuseIdentifier: cellKey)
            cell.selectionStyle = .None
        }

        cell.textLabel!.text = title
        
        if let textField = self.textField {
            if textField.superview != cell {
                textField.removeFromSuperview()
                cell.contentView.addSubview(textField)
                cell.textField = textField
            }
        } else {
            let textField = UITextField(frame: CGRect.zero)
            textField.delegate = self
            textField.text = self.text

            cell.contentView.addSubview(textField)
            cell.textField = textField
            self.textField = textField
        }
        
        self.textField.text = self.text
        self.textField.placeholder = placeholder
        
        self.textField.autocapitalizationType = autocapitalizationType
        self.textField.autocorrectionType = autocorrectionType
        self.textField.spellCheckingType = spellCheckingType
        self.textField.keyboardType = keyboardType
        self.textField.keyboardAppearance = keyboardAppearance
        self.textField.secureTextEntry = secureTextEntry

        self.textField.returnKeyType = .Done
        self.textField.enablesReturnKeyAutomatically = false
        
        return cell
    }
}
