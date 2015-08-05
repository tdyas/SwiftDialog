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

public class CheckboxElement : Element, BooleanValuedElement {
    public var text: String
    public var value: Bool
    
    public init(text: String = "", value: Bool = false) {
        self.text = text
        self.value = value
    }
    
    public override func getCell(tableView: UITableView) -> UITableViewCell! {
        let cellKey = "checkbox"

        var cell = tableView.dequeueReusableCellWithIdentifier(cellKey) as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellKey)
            cell.selectionStyle = .Default
        }
        
        cell.textLabel!.text = self.text
        cell.accessoryType = self.value ? .Checkmark : .None
        
        return cell
    }
    
    public override func elementSelected(dialogController: DialogController, tableView: UITableView, atPath indexPath: NSIndexPath) {
        self.value = !self.value
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            cell.accessoryType = self.value ? .Checkmark : .None
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
