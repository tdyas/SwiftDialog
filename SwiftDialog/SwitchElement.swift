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

public class SwitchElement : Element, BooleanValuedElement {
    private var switchControl: UISwitch!
    
    public var text: String = ""
    public var value: Bool = false
    
    public init(text: String = "", value: Bool = false) {
        super.init()
        self.text = text
        self.value = value
    }
    
    func valueChanged() {
        self.value = self.switchControl.on
    }
    
    public override func getCell(tableView: UITableView) -> UITableViewCell! {
        let cellKey = "switch"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellKey) as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellKey)
            cell.selectionStyle = .None
        }
        
        if self.switchControl == nil {
            self.switchControl = UISwitch()
            self.switchControl.backgroundColor = UIColor.clearColor()
            self.switchControl.addTarget(self, action: "valueChanged", forControlEvents: .ValueChanged)
        }
        
        if !self.switchControl.isDescendantOfView(cell)  {
            switchControl.removeFromSuperview()
        }
        cell.accessoryView = switchControl
        
        cell.textLabel!.text = self.text
        self.switchControl.on = self.value
        
        return cell
    }
}
