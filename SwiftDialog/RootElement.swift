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

public class RootElement : Element {
    public var sections: [SectionElement]
    public var title: String
    public var groups: [String: Int]
    public var onRefresh: ((RootElement) -> ())?

    public weak var dialogController: DialogController?
    
    public init(
        title: String,
        sections: [SectionElement],
        groups: [String: Int] = [:],
        onRefresh: ((RootElement) -> ())? = nil
    ) {
        self.title = title
        self.sections = sections
        self.groups = groups
        self.onRefresh = onRefresh
        
        super.init()
        
        for section in self.sections {
            section.parent = self
        }
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
}
