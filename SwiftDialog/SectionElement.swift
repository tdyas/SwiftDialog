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

public class SectionElement : BaseElement {
    public var elements: ArrayRef<Element>
    public var header: String?
    public var footer: String?
    public var headerView: UIView?
    public var footerView: UIView?
    
    public init(
        elements: ArrayRef<Element> = [],
        header: String? = nil,
        footer: String? = nil,
        headerView: UIView? = nil,
        footerView: UIView? = nil
    ) {
        self.elements = elements
        self.header = header
        self.footer = footer
        self.headerView = headerView
        self.footerView = footerView

        super.init()
        
        for element in self.elements {
            element.parent = self
        }
    }
}

public protocol SectionElementBuilder {
    func elements(_ elements: ArrayRef<Element>) -> SectionElementBuilder
    func element(_ element: Element) -> SectionElementBuilder
    func header(_ header: String) -> SectionElementBuilder
    func headerView(_ headerView: UIView) -> SectionElementBuilder
    func footer(_ footer: String) -> SectionElementBuilder
    func footerView(_ footerView: UIView) -> SectionElementBuilder
    func build() -> SectionElement
}

extension SectionElement {
    public static func builder() -> SectionElementBuilder {
        return BuilderImpl()
    }
    
    class BuilderImpl : SectionElementBuilder {
        var elements: ArrayRef<Element> = []
        var header: String?
        var footer: String?
        var headerView: UIView?
        var footerView: UIView?
        
        func elements(_ elements: ArrayRef<Element>) -> SectionElementBuilder {
            self.elements = elements
            return self
        }
        
        func element(_ element: Element) -> SectionElementBuilder {
            self.elements.append(element)
            return self
        }
        
        func header(_ header: String) -> SectionElementBuilder {
            self.header = header
            return self
        }
        
        func headerView(_ headerView: UIView) -> SectionElementBuilder {
            self.headerView = headerView
            return self
        }
        
        func footer(_ footer: String) -> SectionElementBuilder {
            self.footer = footer
            return self
        }
        
        func footerView(_ footerView: UIView) -> SectionElementBuilder {
            self.footerView = footerView
            return self
        }
        
        func build() -> SectionElement {
            return SectionElement(
                elements: elements,
                header: header,
                footer: footer,
                headerView: headerView,
                footerView: footerView
            )
        }
    }
}
