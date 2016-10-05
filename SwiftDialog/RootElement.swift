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
    case none
    case radioGroup(group: String)
    case count
}

open class RootElement : Element {
    open var sections: WrappedArray<SectionElement>
    open var title: String
    open var groups: [String: Int]
    open var onRefresh: ((RootElement) -> ())?
    open var summary: SummarizeBy
    open var childStyle: UITableViewStyle

    open weak var dialogController: DialogController?
    
    public init(
        title: String,
        sections: WrappedArray<SectionElement>,
        groups: [String: Int] = [:],
        onRefresh: ((RootElement) -> ())? = nil,
        summary: SummarizeBy = .none,
        childStyle: UITableViewStyle = .grouped
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
        summary: SummarizeBy = .none,
        childStyle: UITableViewStyle = .grouped
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
    
    func indexForRadioElement(_ radioElement: RadioElement) -> Int? {
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
    
    open override func getCell(_ tableView: UITableView) -> UITableViewCell! {
        let cellKey = "root"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellKey) as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellKey)
            cell?.selectionStyle = .default
            cell?.accessoryType = .disclosureIndicator
        }
        
        cell?.textLabel!.text = title
        
        switch summary {
        case .radioGroup(let group):
            if let selectedIndex = groups[group] {
                var currentIndex = 0
                for section in sections {
                    for element in section.elements {
                        if let currentRadioElement = element as? RadioElement {
                            if currentRadioElement.group == group {
                                if currentIndex == selectedIndex {
                                    cell?.detailTextLabel?.text = currentRadioElement.text
                                }
                                
                                currentIndex += 1
                            }
                        }

                    }
                }
            }
            
        case .count:
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
            cell?.detailTextLabel?.text = count.description
            
        case .none:
            cell?.detailTextLabel?.text = ""
        }
        
        return cell
    }

    
    open override func elementSelected(_ dialogController: DialogController, tableView: UITableView, atPath indexPath: IndexPath) {
        let vc = DialogViewController(root: self, style: childStyle)
        dialogController.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
