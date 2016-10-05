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

class DateTimePickerCell : UITableViewCell {
    weak var element: DateTimeElement!
    var _inputView: UIView?
    var picker: UIDatePicker!

    init(element: DateTimeElement, style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.element = element
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var inputView: UIView? {
        get {
            if (_inputView == nil) {
                _inputView = makeInputView()
            }
            return _inputView
        }
    }
    
    func makeInputView() -> UIView {
        let toolbar = UIToolbar(frame: CGRect.zero)
        toolbar.autoresizingMask = .flexibleWidth
        let toolbarIntrinsicSize = toolbar.intrinsicContentSize

        var titleForSetCurrentButton = ""
        switch element.datePickerMode() {
        case .dateAndTime:
            titleForSetCurrentButton = "Now"
        case .date:
            titleForSetCurrentButton = "Today"
        case .time:
            titleForSetCurrentButton = "Now"
        default:
            fatalError("Unsupported date picker mode.")
        }
        
        toolbar.items = [
            UIBarButtonItem(title: titleForSetCurrentButton, style: .plain, target: self, action: #selector(DateTimePickerCell.setCurrent)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(DateTimePickerCell.dismissPicker))
        ]

        picker = UIDatePicker(frame: CGRect.zero)
        let pickerIntrinsicSize = picker.intrinsicContentSize
        
        picker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        picker.datePickerMode = element.datePickerMode()
        picker.date = element.value
        picker.addTarget(self, action: #selector(DateTimePickerCell.dateTimeChanged(_:)), for: .valueChanged)
        
        let viewFrame = CGRect(
            x: 0,
            y: 0,
            width: pickerIntrinsicSize.width,
            height: toolbarIntrinsicSize.height + pickerIntrinsicSize.height
        )
        
        let view = UIView(frame: viewFrame)
        view.backgroundColor = UIColor.white
        view.isOpaque = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        toolbar.frame = CGRect(x: 0, y: 0, width: viewFrame.width, height: toolbarIntrinsicSize.height)
        view.addSubview(toolbar)
        
        picker.frame = CGRect(x: 0, y: toolbarIntrinsicSize.height, width: viewFrame.width, height: pickerIntrinsicSize.height)
        view.addSubview(picker)
        
        return view
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    func dateTimeChanged(_ picker: UIDatePicker) {
        element.value = picker.date
        detailTextLabel!.text = element.formatDateTime()
    }
    
    func setCurrent() {
        let now = Date()
        picker.setDate(now, animated: true)
        element.value = now
        detailTextLabel!.text = element.formatDateTime()
    }
    
    func dismissPicker() {
        resignFirstResponder()
    }
}

open class DateTimeElement : Element {
    var text: String
    var value: Date

    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        
        switch self.datePickerMode() {
        case .date:
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            
        case .time:
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            
        case .dateAndTime:
            formatter.dateStyle = .short
            formatter.timeStyle = .short
           
        default:
            fatalError("Unsupported date picker mode.")
        }
        
        return formatter
    }()
    
    public init(
        text: String = "",
        value: Date
    ) {
        self.text = text
        self.value = value
    }
    
    func datePickerMode() -> UIDatePickerMode {
        return .dateAndTime
    }
    
    func formatDateTime() -> String {
        return formatter.string(from: value)
    }
    
    open override func getCell(_ tableView: UITableView) -> UITableViewCell! {
        let cellKey = "datetime"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellKey) as UITableViewCell!
        if cell == nil {
            cell = DateTimePickerCell(element: self, style: .value1, reuseIdentifier: cellKey)
            cell?.selectionStyle = .default
            cell?.accessoryType = .disclosureIndicator
        }
        
        cell?.textLabel!.text = text
        cell?.detailTextLabel!.text = formatDateTime()
        
        return cell
    }
    

    open override func elementSelected(_ dialogController: DialogController, tableView: UITableView, atPath indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! DateTimePickerCell!
        cell?.becomeFirstResponder()
    }
}

open class DateElement : DateTimeElement {
    override func datePickerMode() -> UIDatePickerMode {
        return .date
    }
}

open class TimeElement : DateTimeElement {
    override func datePickerMode() -> UIDatePickerMode {
        return .time
    }
}
