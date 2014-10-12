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

public class BaseLabelElement : Element {
    public let cellStyle: UITableViewCellStyle
    public var text: String = ""
    public var detailText: String = ""

    let cellStyleToCellKey: [UITableViewCellStyle: String] = [
        .Default: "label-default",
        .Value1: "label-value1",
        .Value2: "label-value2",
        .Subtitle: "label-subtitle"
    ]
    
    public init(cellStyle: UITableViewCellStyle) {
        self.cellStyle = cellStyle
    }

    public override func getCell(tableView: UITableView) -> UITableViewCell! {
        let cellKey = cellStyleToCellKey[self.cellStyle]!
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellKey) as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: self.cellStyle, reuseIdentifier: cellKey)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        
        cell.textLabel?.text = self.text
        cell.detailTextLabel?.text = self.detailText
        
        return cell
    }
}

public class LabelElement : BaseLabelElement {
    public init(_ text: String) {
        super.init(cellStyle: .Default)
        self.text = text
    }
}

public class Value1LabelElement : BaseLabelElement {
    public init(text: String, detailText: String) {
        super.init(cellStyle: .Value1)
        self.text = text
        self.detailText = detailText
    }
}

public class Value2LabelElement : BaseLabelElement {
    public init(text: String, detailText: String) {
        super.init(cellStyle: .Value2)
        self.text = text
        self.detailText = detailText
    }
}

public class SubtitleLabelElement : BaseLabelElement {
    public init(text: String, detailText: String) {
        super.init(cellStyle: .Subtitle)
        self.text = text
        self.detailText = detailText
    }
}
