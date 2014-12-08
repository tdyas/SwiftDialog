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
        let toolbar = UIToolbar(frame: CGRect.zeroRect)
        toolbar.autoresizingMask = .FlexibleWidth
        let toolbarIntrinsicSize = toolbar.intrinsicContentSize()

        var titleForSetCurrentButton = ""
        switch element.datePickerMode() {
        case .DateAndTime:
            titleForSetCurrentButton = "Now"
        case .Date:
            titleForSetCurrentButton = "Today"
        case .Time:
            titleForSetCurrentButton = "Now"
        default:
            fatalError("Unsupported date picker mode.")
        }
        
        toolbar.items = [
            UIBarButtonItem(title: titleForSetCurrentButton, style: .Plain, target: self, action: "setCurrent"),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismissPicker")
        ]

        picker = UIDatePicker(frame: CGRect.zeroRect)
        let pickerIntrinsicSize = picker.intrinsicContentSize()
        
        picker.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        picker.datePickerMode = element.datePickerMode()
        picker.date = element.value ?? NSDate()
        
        picker.addTarget(self, action: "dateTimeChanged:", forControlEvents: .ValueChanged)
        
        let viewFrame = CGRect(
            x: 0,
            y: 0,
            width: pickerIntrinsicSize.width,
            height: toolbarIntrinsicSize.height + pickerIntrinsicSize.height
        )
        
        let view = UIView(frame: viewFrame)
        view.backgroundColor = UIColor.whiteColor()
        view.opaque = true
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        toolbar.frame = CGRect(x: 0, y: 0, width: viewFrame.width, height: toolbarIntrinsicSize.height)
        view.addSubview(toolbar)
        
        picker.frame = CGRect(x: 0, y: toolbarIntrinsicSize.height, width: viewFrame.width, height: pickerIntrinsicSize.height)
        view.addSubview(picker)
        
        return view
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func dateTimeChanged(picker: UIDatePicker) {
        element.value = picker.date
        detailTextLabel!.text = element.formatDateTime()
    }
    
    func setCurrent() {
        let now = NSDate()
        picker.setDate(now, animated: true)
        element.value = now
        detailTextLabel!.text = element.formatDateTime()
    }
    
    func dismissPicker() {
        resignFirstResponder()
    }
}

public class DateTimeElement : Element {
    var text: String
    var value: NSDate

    lazy var formatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        
        switch self.datePickerMode() {
        case .Date:
            formatter.dateStyle = .ShortStyle
            formatter.timeStyle = .NoStyle
            
        case .Time:
            formatter.dateStyle = .NoStyle
            formatter.timeStyle = .ShortStyle
            
        case .DateAndTime:
            formatter.dateStyle = .ShortStyle
            formatter.timeStyle = .ShortStyle
           
        default:
            fatalError("Unsupported date picker mode.")
        }
        
        return formatter
    }()
    
    public init(
        text: String = "",
        value: NSDate
    ) {
        self.text = text
        self.value = value
    }
    
    func datePickerMode() -> UIDatePickerMode {
        return .DateAndTime
    }
    
    func formatDateTime() -> String {
        return formatter.stringFromDate(value)
    }
    
    public override func getCell(tableView: UITableView) -> UITableViewCell! {
        let cellKey = "datetime"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellKey) as UITableViewCell!
        if cell == nil {
            cell = DateTimePickerCell(element: self, style: .Value1, reuseIdentifier: cellKey)
            cell.selectionStyle = .Default
            cell.accessoryType = .DisclosureIndicator
        }
        
        cell.textLabel!.text = text
        cell.detailTextLabel!.text = formatDateTime()
        
        return cell
    }
    

    public override func elementSelected(dialogController: DialogController, tableView: UITableView, atPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as DateTimePickerCell!
        cell.becomeFirstResponder()
    }
}

public class DateElement : DateTimeElement {
    override func datePickerMode() -> UIDatePickerMode {
        return .Date
    }
}

public class TimeElement : DateTimeElement {
    override func datePickerMode() -> UIDatePickerMode {
        return .Time
    }
}
