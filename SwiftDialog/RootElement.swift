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
    public var sections: ArrayRef<SectionElement>
    public var title: String
    public var groups: [String: Int]
    public var onRefresh: ((RootElement) -> ())?
    public var summary: SummarizeBy
    public var style: UITableViewStyle

    public weak var dialogController: DialogController?

    public init(
        title: String,
        sections: ArrayRef<SectionElement>,
        groups: [String: Int] = [:],
        onRefresh: ((RootElement) -> ())? = nil,
        summary: SummarizeBy = .none,
        style: UITableViewStyle = .grouped
    ) {
        self.title = title
        self.sections = sections
        self.groups = groups
        self.onRefresh = onRefresh
        self.summary = summary
        self.style = style
        
        super.init()
        
        for section in self.sections {
            section.parent = self
        }
    }
    
    public convenience init(
        title: String,
        elements: ArrayRef<Element>,
        groups: [String: Int] = [:],
        onRefresh: ((RootElement) -> ())? = nil,
        summary: SummarizeBy = .none,
        style: UITableViewStyle = .grouped
    ) {
        self.init(
            title: title,
            sections: [SectionElement(elements: elements)],
            groups: groups,
            onRefresh: onRefresh,
            summary: summary,
            style: style
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
        let vc = DialogViewController(root: self)
        dialogController.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func invalidateAll() {
        self.dialogController?.viewController?.tableView.reloadData()
    }
    
    func invalidateElements(_ invalidatedElements: [Element]) {
        var rowsToReload: [IndexPath] = []
        
        outer: for invalidatedElement in invalidatedElements {
            guard let sectionOfInvalidatedElement = invalidatedElement.parent as? SectionElement else { continue }
            guard let rootOfInvalidatedElement = sectionOfInvalidatedElement.parent as? RootElement else { continue }
            if rootOfInvalidatedElement !== self { continue }
            
            for (sectionIndex, section) in sections.enumerated() {
                if section !== sectionOfInvalidatedElement { continue }
                for (elementIndex, element) in section.elements.enumerated() {
                    if element === invalidatedElement {
                        rowsToReload.append(IndexPath(row: elementIndex, section: sectionIndex))
                        continue outer;
                    }
                }
            }
        }
        
        self.dialogController?.viewController?.tableView.reloadRows(at: rowsToReload, with: .none)
    }
    
    public func sectionIndexForElement(_ element: Element) -> Int? {
        guard let sectionOfElement = element.parent as? SectionElement else { return nil }
        guard let rootOfElement = sectionOfElement.parent as? RootElement else { return nil }
        if rootOfElement !== self { return nil }
        
        for (sectionIndex, section) in sections.enumerated() {
            if section === sectionOfElement {
                return sectionIndex
            }
        }
        
        return nil
    }
    
    func insert(section: SectionElement, at index: Int) {
        sections.insert(newElement: section, at: index)
        dialogController?.viewController?.tableView.insertSections(IndexSet(integer: index), with: .none)
    }
    
    func remove(section: SectionElement) {
        guard let index = sections.index(of: section) else { return }
        let _ = sections.remove(at: index)
        dialogController?.viewController?.tableView.deleteSections(IndexSet(integer: index), with: .none)
    }
}

extension RootElement {
    public static func invalidateSummarizedRootOf(element: Element) {
        guard let root = element.root else { return }
        switch (root.summary) {
        case .none:
            return
        default:
            root.root?.invalidateElements([root])
        }
    }
}

public protocol RootElementBuilder {
    func title(_ title: String) -> RootElementBuilder
    func sections(_ sections: ArrayRef<SectionElement>) -> RootElementBuilder
    func section(_ section: SectionElement) -> RootElementBuilder
    func groups(_ groups: [String: Int]) -> RootElementBuilder
    func onRefresh(_ closure: @escaping (RootElement) -> ()) -> RootElementBuilder
    func summary(_ summary: SummarizeBy) -> RootElementBuilder
    func style(_ style: UITableViewStyle) -> RootElementBuilder
    func build() -> RootElement
}

extension RootElement {
    public static func builder() -> RootElementBuilder {
        return BuilderImpl()
    }

    class BuilderImpl : RootElementBuilder {
        private var _title: String = ""
        private var _sections: ArrayRef<SectionElement> = ArrayRef<SectionElement>()
        private var _groups: [String: Int] = [:]
        private var _onRefresh: ((RootElement) -> ())?
        private var _summary: SummarizeBy = .none
        private var _style: UITableViewStyle = .grouped
        
        func title(_ title: String) -> RootElementBuilder {
            _title = title
            return self
        }
        
        func sections(_ sections: ArrayRef<SectionElement>) -> RootElementBuilder {
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
        
        func style(_ style: UITableViewStyle) -> RootElementBuilder {
            _style = style
            return self
        }
        
        func build() -> RootElement {
            return RootElement(
                title: _title,
                sections: _sections,
                groups: _groups,
                onRefresh: _onRefresh,
                summary: _summary,
                style: _style
            )
        }
    }
}

