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

open class SectionElement : Element {
    open var elements: WrappedArray<Element>
    open var header: String?
    open var footer: String?
    open var headerView: UIView?
    open var footerView: UIView?
    
    public init(
        elements: WrappedArray<Element> = [],
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
