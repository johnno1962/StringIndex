//
//  StringIndex.swift
//  StringIndex
//
//  Created by John Holdsworth on 25/10/2020.
//  Copyright © 2020 John Holdsworth. All rights reserved.
//
//  A few operators simplifying offsettting a String index
//
//  Repo: https://github.com/johnno1962/StringIndex.git
//
//  $Id: //depot/StringIndex/Sources/StringIndex/StringIndex.swift#36 $
//

import Foundation

extension Optional where Wrapped == String.Index {
    public typealias OffsetIndex = String.Index.OffsetType
    // Basic operators to offset String.Index when used in a subscript
    public static func + (index: Self, offset: Int) -> OffsetIndex {
        return OffsetIndex.offsetIndex(index: index, offset: offset)
    }
    public static func - (index: Self, offset: Int) -> OffsetIndex {
        return index + -offset
    }
    public static func + (index: Self, offset: OffsetIndex)
        -> OffsetIndex {
        return OffsetIndex.offsetIndex(index: index, offset: 0) + offset
    }
    
    // Mixed String.Index and OffsetIndex in range
    public static func ..< (lhs: OffsetIndex, rhs: Self)
        -> Range<OffsetIndex> {
        return lhs ..< rhs+0
    }
    public static func ..< (lhs: Self, rhs: OffsetIndex)
        -> Range<OffsetIndex> {
        return lhs+0 ..< rhs
    }
}

extension Range where Bound == String.Index {
    public init?<S: StringProtocol>(_ range: Range<String.Index.OffsetType>, in string: S) {
        guard let lower = range.lowerBound.index(in: String(string)),
              let upper = range.upperBound.index(in: String(string)),
            lower <= upper else {
            return nil
        }
        self = lower ..< upper
    }
}

extension NSRange {
    public init?<S: StringProtocol>(_ range: Range<String.Index.OffsetType>, in string: S) {
        guard let lower = range.lowerBound.index(in: String(string)),
              let upper = range.upperBound.index(in: String(string)),
            lower <= upper else {
            return nil
        }
        self.init(lower ..< upper, in: string)
    }
}

public protocol Offsetable: Comparable {
    associatedtype OffsetType: Comparable
    associatedtype StringType
    static func nsRange(_ range: Range<Self>,
          in: String) -> NSRange
    static func myRange(from: Range<String.Index>,
          in: String) -> Range<Self>
    static func string(in: StringType) -> String
    static func start(in: StringType) -> Self
    static func end(in: StringType) -> Self
    func indexBefore(in: StringType) -> Self
    func indexAfter(in: StringType) -> Self
}

extension String.Index: Offsetable {
    public typealias OffsetType = String.OffsetImpl<Self>
    public typealias StringType = String
    public static func nsRange(_ range: Range<Self>,
        in string: String) -> NSRange {
        return NSRange(range, in: string)
    }
    public static func myRange(from: Range<String.Index>,
                in: String) -> Range<Self> {
        return from
    }
    public static func string(in string: StringType) -> String {
        return String(string)
    }
    public static func start(in string: StringType) -> Self {
        return string.startIndex
    }
    public static func end(in string: StringType) -> Self {
        return string.endIndex
    }
    public func indexBefore(in string: StringType) -> Self {
        return string.index(before: self)
    }
    public func indexAfter(in string: StringType) -> Self {
        return string.index(after: self)
    }
}
