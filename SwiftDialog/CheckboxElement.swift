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

open class CheckboxElement : Element, BooleanValuedElement {
    open var text: String
    open var value: Bool
    
    public init(text: String = "", value: Bool = false) {
        self.text = text
        self.value = value
    }
    
    open override func getCell(_ tableView: UITableView) -> UITableViewCell! {
        let cellKey = "checkbox"

        var cell = tableView.dequeueReusableCell(withIdentifier: cellKey) as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellKey)
            cell?.selectionStyle = .default
        }
        
        cell?.textLabel!.text = self.text
        cell?.accessoryType = self.value ? .checkmark : .none
        
        return cell
    }
    
    open override func elementSelected(_ dialogController: DialogController, tableView: UITableView, atPath indexPath: IndexPath) {
        self.value = !self.value
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = self.value ? .checkmark : .none
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
