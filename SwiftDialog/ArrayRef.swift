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

public final class ArrayRef<T> {
    internal var array: Array<T>
    
    public init(_ array: Array<T>) {
        self.array = array
    }
    
    public convenience init() {
        self.init([])
    }
}

extension ArrayRef : ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: T...) {
        self.init(Array(elements))
    }
}

extension ArrayRef : Sequence {
    public typealias Iterator = Array<T>.Iterator
    public typealias SubSequence = Array<T>.SubSequence
    
    public func makeIterator() -> Iterator {
        return self.array.makeIterator()
    }
}

extension ArrayRef : Collection, MutableCollection {
    public subscript(bounds: Range<Int>) -> ArraySlice<T> {
        get {
            return self.array[bounds]
        }
        set(newValue) {
            self.array[bounds] = newValue
        }
    }

    public typealias Index = Array<T>.Index
    
    public var startIndex: Index {
        return self.array.startIndex
    }

    public var endIndex: Index {
        return self.array.endIndex
    }
    
    public var count: Int {
        return self.array.count
    }
    
    public subscript(i: Index) -> T {
        get {
            return self.array[i]
        }
        set {
            self.array[i] = newValue
        }
    }

    public func index(after i: Int) -> Int {
        return self.array.index(after: i)
    }
}

extension ArrayRef : RangeReplaceableCollection {
    public func reserveCapacity(n: ArrayRef.IndexDistance) {
        self.array.reserveCapacity(n)
    }
    
    public func append(_ x: Iterator.Element) {
        self.array.append(x)
    }
    
    public func extend<S : Sequence>(_ newElements: S) where Iterator.Element == S.Iterator.Element {
        self.array.append(contentsOf: newElements)
    }

    public func replaceSubrange<C : Collection>(_ subRange: Range<Index>, with newElements: C) where Iterator.Element == C.Iterator.Element {
        self.array.replaceSubrange(subRange, with: newElements)
    }
    
    public func insert(newElement: Iterator.Element, at i: Index) {
        self.array.insert(newElement, at: i)
    }
    
//    public func insert<S: Collection>(contentsOf xs: S, at i: Index) where S.Iterator.Element == T {
//        self.elements.insert(xs, at: i)
//    }
    
    public func remove(at i: Index) -> Iterator.Element {
        return self.array.remove(at: i)
    }
    
    public func removeSubrange(_ subRange: Range<Index>) {
        self.array.removeSubrange(subRange)
    }
    
    public func removeAll(keepingCapacity: Bool) {
        self.array.removeAll(keepingCapacity: keepingCapacity)
    }
}
