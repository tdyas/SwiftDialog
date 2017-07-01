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

public class RadioElement : BaseElement {
    public var text: String
    public let group: String
    
    public init(text: String, group: String) {
        self.text = text
        self.group = group
    }
    
    public override func getCell(_ tableView: UITableView) -> UITableViewCell! {
        let cellKey = "radio"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellKey) as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellKey)
            cell?.selectionStyle = .default
        }
        
        cell?.textLabel!.text = self.text

        if let root = self.root {
            let index = root.indexForRadioElement(self)
            if let selectedIndex = root.groups[group] {
                if index == selectedIndex {
                    cell?.accessoryType = .checkmark
                } else {
                    cell?.accessoryType = .none
                }
            }
        }
        
        return cell
    }
    
    public override func elementSelected(_ dialogController: DialogController, tableView: UITableView, atPath indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }

        if let root = self.root {
            let index = root.indexForRadioElement(self)
            root.groups[group] = index

            var sectionIndex = 0
            for section in root.sections {
                var elementIndex = 0
                for element in section.elements {
                    if let radioElement = element as? RadioElement {
                        if radioElement.group == self.group {
                            let otherIndexPath = IndexPath(row: elementIndex, section: sectionIndex)
                            if otherIndexPath != indexPath {
                                if let otherCell = tableView.cellForRow(at: otherIndexPath) {
                                    otherCell.accessoryType = .none
                                }
                            }
                        }
                    }
                    elementIndex += 1
                }
                sectionIndex += 1
            }

        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
