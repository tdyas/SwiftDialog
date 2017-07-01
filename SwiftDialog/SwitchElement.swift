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

public class SwitchElement : BaseElement, BooleanValuedElement {
    fileprivate var switchControl: UISwitch!
    
    public var text: String = ""
    public var value: Bool = false
    
    public init(text: String = "", value: Bool = false) {
        super.init()
        self.text = text
        self.value = value
    }
    
    @objc
    func valueChanged() {
        self.value = self.switchControl.isOn
    }
    
    public override func getCell(_ tableView: UITableView) -> UITableViewCell! {
        let cellKey = "switch"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellKey) as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellKey)
            cell?.selectionStyle = .none
        }
        
        if self.switchControl == nil {
            self.switchControl = UISwitch()
            self.switchControl.backgroundColor = UIColor.clear
            self.switchControl.addTarget(self, action: #selector(SwitchElement.valueChanged), for: .valueChanged)
        }
        
        if !self.switchControl.isDescendant(of: cell!)  {
            switchControl.removeFromSuperview()
        }
        cell?.accessoryView = switchControl
        
        cell?.textLabel!.text = self.text
        self.switchControl.isOn = self.value
        
        return cell
    }
}
