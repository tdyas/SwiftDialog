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

protocol BooleanValuedElement {
    var value: Bool { get }
}

public enum SummarizeBy {
    case none
    case radioGroup(group: String)
    case count
}

public class RootElement : BaseElement {
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
    
    public override func getCell(_ tableView: UITableView) -> UITableViewCell! {
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

    public override func elementSelected(_ dialogController: DialogController, tableView: UITableView, atPath indexPath: IndexPath) {
        let vc = DialogViewController(root: self, style: childStyle)
        dialogController.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

public protocol RootElementBuilder {
    func title(_ title: String) -> RootElementBuilder
    func sections(_ sections: WrappedArray<SectionElement>) -> RootElementBuilder
    func section(_ section: SectionElement) -> RootElementBuilder
    func groups(_ groups: [String: Int]) -> RootElementBuilder
    func onRefresh(_ closure: @escaping (RootElement) -> ()) -> RootElementBuilder
    func summary(_ summary: SummarizeBy) -> RootElementBuilder
    func childStyle(_ childStyle: UITableViewStyle) -> RootElementBuilder
    func build() -> RootElement
}

extension RootElement {
    public static func builder() -> RootElementBuilder {
        return BuilderImpl()
    }

    class BuilderImpl : RootElementBuilder {
        private var _title: String = ""
        private var _sections: WrappedArray<SectionElement> = WrappedArray<SectionElement>()
        private var _groups: [String: Int] = [:]
        private var _onRefresh: ((RootElement) -> ())?
        private var _summary: SummarizeBy = .none
        private var _childStyle: UITableViewStyle = .grouped
        
        func title(_ title: String) -> RootElementBuilder {
            _title = title
            return self
        }
        
        func sections(_ sections: WrappedArray<SectionElement>) -> RootElementBuilder {
            _sections = sections
            return self
        }
        
        func section(_ section: SectionElement) -> RootElementBuilder {
            _sections.append(section)
            return self
        }
        
        func groups(_ groups: [String: Int]) -> RootElementBuilder {
            _groups = groups
            return self
        }
        
        func onRefresh(_ closure: @escaping (RootElement) -> ()) -> RootElementBuilder {
            _onRefresh = closure
            return self
        }
        
        func summary(_ summary: SummarizeBy) -> RootElementBuilder {
            _summary = summary
            return self
        }
        
        func childStyle(_ childStyle: UITableViewStyle) -> RootElementBuilder {
            _childStyle = childStyle
            return self
        }
        
        func build() -> RootElement {
            return RootElement(
                title: _title,
                sections: _sections,
                groups: _groups,
                onRefresh: _onRefresh,
                summary: _summary,
                childStyle: _childStyle
            )
        }
    }
}

