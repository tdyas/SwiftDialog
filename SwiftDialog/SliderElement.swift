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

open class SliderElement : Element {
    var text: String
    var value: Float
    var slider: UISlider?
    
    public init(text: String = "", value: Float = 0.0) {
        self.text = text
        self.value = value
    }
    
    open override func getCell(_ tableView: UITableView) -> UITableViewCell! {
        let cellKey = "slider"
        let sliderTag = 500
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellKey) as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellKey)
            cell?.selectionStyle = .none
        }

        // Setup the text label.
        cell?.textLabel!.text = self.text

        // Remove any existing slider from the content view.
        if let view = cell?.contentView.viewWithTag(sliderTag) {
            view.removeFromSuperview()
        }
        
        if let slider = self.slider {
            cell?.contentView.addSubview(slider)
        } else {
            let slider = UISlider(frame: CGRect.zero)
            slider.tag = sliderTag
            slider.autoresizingMask = .flexibleWidth
            slider.addTarget(self, action: #selector(SliderElement.valueChanged(_:)), for: .valueChanged)
            cell!.contentView.addSubview(slider)
            self.slider = slider
        }
        
        let insets = tableView.separatorInset
        let contentFrame = cell?.contentView.bounds.insetBy(dx: insets.left, dy: 0)
        
        var sliderFrame = contentFrame
        if self.text != "" {
            let textSize = cell?.textLabel!.intrinsicContentSize
            sliderFrame = CGRect(
                x: (contentFrame?.minX)! + (textSize?.width)! + 10.0,
                y: (contentFrame?.minY)!,
                width: (contentFrame?.width)! - (textSize?.width)! - 10.0,
                height: (contentFrame?.height)!
            )
        }
        
        self.slider?.frame = sliderFrame!
        self.slider?.value = self.value
        
        return cell
    }
    
    func valueChanged(_ slider: UISlider!) {
        self.value = slider.value
    }
}
