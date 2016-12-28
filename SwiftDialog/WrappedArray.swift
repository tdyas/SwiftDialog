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

extension WrappedArray : ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: T...) {
        self.init(Array(elements))
    }
}

extension WrappedArray : Sequence {
    public typealias Iterator = Array<T>.Iterator
    public typealias SubSequence = Array<T>.SubSequence
    
    public func makeIterator() -> Iterator {
        return self.elements.makeIterator()
    }
}

extension WrappedArray : Collection, MutableCollection {
    public subscript(bounds: Range<Int>) -> ArraySlice<T> {
        get {
            return self.elements[bounds]
        }
        set(newValue) {
            self.elements[bounds] = newValue
        }
    }

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

    public func index(after i: Int) -> Int {
        return self.elements.index(after: i)
    }
}

extension WrappedArray : RangeReplaceableCollection {
    public func reserveCapacity(n: WrappedArray.IndexDistance) {
        self.elements.reserveCapacity(n)
    }
    
    public func append(_ x: Iterator.Element) {
        self.elements.append(x)
    }
    
    public func extend<S : Sequence>(_ newElements: S) where Iterator.Element == S.Iterator.Element {
        self.elements.append(contentsOf: newElements)
    }

    public func replaceSubrange<C : Collection>(_ subRange: Range<Index>, with newElements: C) where Iterator.Element == C.Iterator.Element {
        self.elements.replaceSubrange(subRange, with: newElements)
    }
    
    public func insert(newElement: Iterator.Element, at i: Index) {
        self.elements.insert(newElement, at: i)
    }
    
//    public func insert<S: Collection>(contentsOf xs: S, at i: Index) where S.Iterator.Element == T {
//        self.elements.insert(xs, at: i)
//    }
    
    public func remove(at i: Index) -> Iterator.Element {
        return self.elements.remove(at: i)
    }
    
    public func removeSubrange(_ subRange: Range<Index>) {
        self.elements.removeSubrange(subRange)
    }
    
    public func removeAll(keepingCapacity: Bool) {
        self.elements.removeAll(keepingCapacity: keepingCapacity)
    }
}
