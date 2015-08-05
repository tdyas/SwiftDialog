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

@objc
protocol BooleanValuedElement {
    var value: Bool { get }
}

public enum SummarizeBy {
    case None
    case RadioGroup(group: String)
    case Count
}

public class RootElement : Element {
    public var sections: WrappedArray<SectionElement>
    public var title: String
    public var groups: [String: Int]
    public var onRefresh: ((RootElement) -> ())?
    public var summary: SummarizeBy
    public var childStyle: UITableViewStyle

    public weak var dialogController: DialogController?
    
    public init(
        title: String,
        sections: WrappedArray<SectionElement>,
        groups: [String: Int] = [:],
        onRefresh: ((RootElement) -> ())? = nil,
        summary: SummarizeBy = .None,
        childStyle: UITableViewStyle = .Grouped
    ) {
        self.title = title
        self.sections = sections
        self.groups = groups
        self.onRefresh = onRefresh
        self.summary = summary
        self.childStyle = childStyle
        
        super.init()
        
        for section in self.sections {
            section.parent = self
        }
    }
    
    public convenience init(
        title: String,
        elements: WrappedArray<Element>,
        groups: [String: Int] = [:],
        onRefresh: ((RootElement) -> ())? = nil,
        summary: SummarizeBy = .None,
        childStyle: UITableViewStyle = .Grouped
    ) {
        self.init(
            title: title,
            sections: [SectionElement(elements: elements)],
            groups: groups,
            onRefresh: onRefresh,
            summary: summary,
            childStyle: childStyle
        )
    }
    
    func indexForRadioElement(radioElement: RadioElement) -> Int? {
        var index = 0
        
        for section in sections {
            for element in section.elements {
                if let currentRadioElement = element as? RadioElement {
                    if currentRadioElement.group == radioElement.group {
                        if currentRadioElement == radioElement {
                            return index
                        }

                        index += 1
                    }
                }
            }
        }
        
        return nil
    }
    
    public override func getCell(tableView: UITableView) -> UITableViewCell! {
        let cellKey = "root"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellKey) as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: cellKey)
            cell.selectionStyle = .Default
            cell.accessoryType = .DisclosureIndicator
        }
        
        cell.textLabel!.text = title
        
        switch summary {
        case .RadioGroup(let group):
            if let selectedIndex = groups[group] {
                var currentIndex = 0
                for section in sections {
                    for element in section.elements {
                        if let currentRadioElement = element as? RadioElement {
                            if currentRadioElement.group == group {
                                if currentIndex == selectedIndex {
                                    cell.detailTextLabel?.text = currentRadioElement.text
                                }
                                
                                currentIndex += 1
                            }
                        }

                    }
                }
            }
            
        case .Count:
            var count = 0
            for section in sections {
                for element in section.elements {
                    if let boolElement = element as? BooleanValuedElement {
                        if boolElement.value {
                            count += 1
                        }
                    }
                }
            }
            cell.detailTextLabel?.text = count.description
            
        case .None:
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }

    
    public override func elementSelected(dialogController: DialogController, tableView: UITableView, atPath indexPath: NSIndexPath) {
        let vc = DialogViewController(root: self, style: childStyle)
        dialogController.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
