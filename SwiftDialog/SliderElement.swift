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

public class SliderElement : Element {
    var text: String
    var value: Float
    
    public init(text: String = "", value: Float = 0.0) {
        self.text = text
        self.value = value
    }
    
    public override func getCell(tableView: UITableView) -> UITableViewCell! {
        let cellKey = "slider"
        let sliderTag = 500
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellKey) as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellKey)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        
        if self.text != "" {
            cell.textLabel?.text = self.text
        }
        
        var sliderOpt = cell.viewWithTag(sliderTag) as? UISlider
        if sliderOpt == nil {
            let insets = tableView.separatorInset
            let frame = cell.contentView.bounds.rectByInsetting(dx: insets.left, dy: 0)
            
            var slideFrame = CGRect.zeroRect
            if self.text != "" {
                let textSize = cell.textLabel!.intrinsicContentSize()
                slideFrame = CGRect(
                    x: frame.minX + textSize.width + 10.0,
                    y: frame.minY,
                    width: frame.width - textSize.width - 10.0,
                    height: frame.height
                )
            } else {
                slideFrame = frame
            }

            let slider = UISlider(frame: slideFrame)
            slider.tag = sliderTag
            slider.autoresizingMask = .FlexibleWidth
            sliderOpt = slider
            
            cell.contentView.addSubview(slider)
        }
        
        if let slider = sliderOpt {
            slider.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
            slider.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
            slider.value = self.value
        }
        
        return cell
    }
    
    func valueChanged(slider: UISlider!) {
        self.value = slider.value
    }
}
