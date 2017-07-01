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

public class StringElement : BaseElement {
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
        return .value1
    }
    
    public override func getCell(_ tableView: UITableView) -> UITableViewCell! {
        let cellKey = detailText == nil ? "string" : "value1"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellKey) as UITableViewCell!
        if cell == nil {
            let cellStyle = detailText == nil ? UITableViewCellStyle.default : detailCellStyle()
            cell = UITableViewCell(style: cellStyle, reuseIdentifier: cellKey)
        }

        if onSelect != nil {
            cell?.selectionStyle = .default
            if onInfo != nil {
                cell?.accessoryType = .detailDisclosureButton
            } else {
                cell?.accessoryType = .disclosureIndicator
            }
        } else {
            cell?.selectionStyle = .none
            if onInfo != nil {
                cell?.accessoryType = .detailButton
            } else {
                cell?.accessoryType = .none
            }
        }
        
        cell?.textLabel!.text = text
        if let t = detailText {
            cell?.detailTextLabel?.text = t
        }
        
        return cell
    }
    
     public override func elementSelected(_ dialogController: DialogController, tableView: UITableView, atPath indexPath: IndexPath) {
        if let callback = onSelect {
            callback(self)
        }
    }
    
    public override func accessoryButtonTapped(_ dialogController: DialogController, tableView: UITableView, atPath indexPath: IndexPath) {
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
        return .value2
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
        return .subtitle
    }
}
