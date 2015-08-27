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

import Foundation

// Arrays are passed by value but the dialog view needs to be able to modify
// models in place to support changing the table view without invalidating.
// every row. The WrappedArray collection allows Arrays to be used as
// pass-by-reference.

public final class WrappedArray<T> {
    internal var elements: Array<T>
    
    public init(_ elements: Array<T>) {
        self.elements = elements
    }
    
    public convenience init() {
        self.init([])
    }
}

extension WrappedArray : ArrayLiteralConvertible {
    public convenience init(arrayLiteral elements: T...) {
        self.init(Array(elements))
    }
}

extension WrappedArray : SequenceType {
    public typealias Generator = Array<T>.Generator
    
    public func generate() -> Generator {
        return self.elements.generate()
    }
}

extension WrappedArray : CollectionType, MutableCollectionType {
    public typealias Index = Array<T>.Index
    
    public var startIndex: Index {
        return self.elements.startIndex
    }

    public var endIndex: Index {
        return self.elements.endIndex
    }
    
    public var count: Int {
        return self.elements.count
    }
    
    public subscript(i: Index) -> T {
        get {
            return self.elements[i]
        }
        set {
            self.elements[i] = newValue
        }
    }
}

extension WrappedArray : RangeReplaceableCollectionType {
    public func reserveCapacity(n: Index.Distance) {
        self.elements.reserveCapacity(n)
    }
    
    public func append(x: Generator.Element) {
        self.elements.append(x)
    }
    
    public func extend<S : SequenceType where Generator.Element == S.Generator.Element>(newElements: S) {
        self.elements.appendContentsOf(newElements)
    }

    public func replaceRange<C : CollectionType where Generator.Element == C.Generator.Element>(subRange: Range<Index>, with newElements: C) {
        self.elements.replaceRange(subRange, with: newElements)
    }
    
    public func insert(newElement: Generator.Element, atIndex i: Index) {
        self.elements.insert(newElement, atIndex: i)
    }
    
    public func splice<S : CollectionType where Generator.Element == S.Generator.Element>(newElements: S, atIndex i: Index) {
        self.elements.insertContentsOf(newElements, at: i)
    }
    
    public func removeAtIndex(i: Index) -> Generator.Element {
        return self.elements.removeAtIndex(i)
    }
    
    public func removeRange(subRange: Range<Index>) {
        self.elements.removeRange(subRange)
    }
    
    public func removeAll(keepCapacity keepCapacity: Bool) {
        self.elements.removeAll(keepCapacity: keepCapacity)
    }
}
