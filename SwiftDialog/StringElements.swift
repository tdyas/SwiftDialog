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

public class StringElement : Element {
    public var text: String
    public var detailText: String?
    public var onSelect: ((StringElement) -> ())?
    public var onInfo: ((StringElement) -> ())?
    
    public init(
        _ text: String = "",
        detailText: String? = nil,
        onSelect: ((StringElement) -> ())? = nil,
        onInfo: ((StringElement) -> ())? = nil
    ) {
        self.text = text
        self.detailText = detailText
        self.onSelect = onSelect
        self.onInfo = onInfo
    }

    func detailCellStyle() -> UITableViewCellStyle {
        return .Value1
    }
    
    public override func getCell(tableView: UITableView) -> UITableViewCell! {
        let cellKey = detailText == nil ? "string" : "value1"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellKey) as UITableViewCell!
        if cell == nil {
            let cellStyle = detailText == nil ? UITableViewCellStyle.Default : detailCellStyle()
            cell = UITableViewCell(style: cellStyle, reuseIdentifier: cellKey)
        }

        if onSelect != nil {
            cell.selectionStyle = .Default
            if onInfo != nil {
                cell.accessoryType = .DetailDisclosureButton
            } else {
                cell.accessoryType = .DisclosureIndicator
            }
        } else {
            cell.selectionStyle = .None
            if onInfo != nil {
                cell.accessoryType = .DetailButton
            } else {
                cell.accessoryType = .None
            }
        }
        
        cell.textLabel.text = text
        if let t = detailText {
            cell.detailTextLabel?.text = t
        }
        
        return cell
    }
    
    public override func elementSelected(dialogController: DialogController, tableView: UITableView, atPath indexPath: NSIndexPath) {
        if let callback = onSelect {
            callback(self)
        }
    }
    
    public override func accessoryButtonTapped(dialogController: DialogController, tableView: UITableView, atPath indexPath: NSIndexPath) {
        if let callback = onInfo {
            callback(self)
        }
    }
}

public class Value2StringElement : StringElement {
    public override init(
        _ text: String = "",
        detailText: String? = nil,
        onSelect: ((StringElement) -> ())? = nil,
        onInfo: ((StringElement) -> ())? = nil
    ) {
        super.init(text, detailText: detailText, onSelect: onSelect, onInfo: onInfo)
    }
    
    override func detailCellStyle() -> UITableViewCellStyle {
        return .Value2
    }
}

public class SubtitleStringElement : StringElement {
    public override init(
        _ text: String = "",
        detailText: String? = nil,
        onSelect: ((StringElement) -> ())? = nil,
        onInfo: ((StringElement) -> ())? = nil
    ) {
        super.init(text, detailText: detailText, onSelect: onSelect, onInfo: onInfo)
    }
    
    override func detailCellStyle() -> UITableViewCellStyle {
        return .Subtitle
    }
}
