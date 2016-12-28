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
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
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
                let infiniteSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
                textRect = text.boundingRect(with: infiniteSize, options: .truncatesLastVisibleLine, attributes: nil, context: context)
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

open class TextEntryElement : Element, UITextFieldDelegate {
    fileprivate var cachedText: String = ""
    fileprivate var textField: UITextField!
    
    open var text: String {
        get {
            switch (self.textField) {
            case .some(let textField):
                let text = textField.text
                self.cachedText = text!
                return text!
                
            case .none:
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
    
    open var title: String?
    open var placeholder: String?
    
    open var autocapitalizationType: UITextAutocapitalizationType
    open var autocorrectionType: UITextAutocorrectionType
    open var spellCheckingType: UITextSpellCheckingType
    open var keyboardType: UIKeyboardType
    open var keyboardAppearance: UIKeyboardAppearance
    open var secureTextEntry: Bool
    
    public init(
        text: String = "",
        title: String? = nil,
        placeholder: String? = nil,
        autocapitalizationType: UITextAutocapitalizationType = .sentences,
        autocorrectionType: UITextAutocorrectionType = .default,
        spellCheckingType: UITextSpellCheckingType = .default,
        keyboardType: UIKeyboardType = .default,
        keyboardAppearance: UIKeyboardAppearance = .default,
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
    
    func valueChanged(_ textField: UITextField!) {
        self.text = textField.text!
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        self.text = textField.text!
    }
    
    open override func getCell(_ tableView: UITableView) -> UITableViewCell! {
        let cellKey = "textEntry"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellKey) as! TextEntryCell!
        if cell == nil {
            cell = TextEntryCell(tableView: tableView, reuseIdentifier: cellKey)
            cell?.selectionStyle = .none
        }

        cell?.textLabel!.text = title
        
        if let textField = self.textField {
            if textField.superview != cell {
                textField.removeFromSuperview()
                cell?.contentView.addSubview(textField)
                cell?.textField = textField
            }
        } else {
            let textField = UITextField(frame: CGRect.zero)
            textField.delegate = self
            textField.text = self.text

            cell?.contentView.addSubview(textField)
            cell?.textField = textField
            self.textField = textField
        }
        
        self.textField.text = self.text
        self.textField.placeholder = placeholder
        
        self.textField.autocapitalizationType = autocapitalizationType
        self.textField.autocorrectionType = autocorrectionType
        self.textField.spellCheckingType = spellCheckingType
        self.textField.keyboardType = keyboardType
        self.textField.keyboardAppearance = keyboardAppearance
        self.textField.isSecureTextEntry = secureTextEntry

        self.textField.returnKeyType = .done
        self.textField.enablesReturnKeyAutomatically = false
        
        return cell
    }
}
