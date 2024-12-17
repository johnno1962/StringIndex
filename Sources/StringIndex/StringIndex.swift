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
//  $Id: //depot/StringIndex/Sources/StringIndex/StringIndex.swift#39 $
//

import Foundation

extension Optional where Wrapped: OffsetIndexable {
    public typealias OffsetIndex = String.OffsetImpl<Wrapped>
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

public protocol OffsetIndexable: Comparable {
    associatedtype OffsetType: Comparable
    associatedtype StringType
    static func nsRange(_ range: Range<Self>,
                        in: String) -> NSRange
    static func myRange(from: Range<String.Index>,
                        in: String) -> Range<Self>
    static func toRange(from: Range<Self>,
                        in: String) -> Range<String.Index>?
    static func string(in: StringType) -> String
    static func start(in: StringType) -> Self
    static func end(in: StringType) -> Self
    func safeIndex(offsetBy: Int, in string: Self.StringType) -> Self?
}

extension String.Index: OffsetIndexable {
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
    public static func toRange(from: Range<Self>,
                               in: String) -> Range<String.Index>? {
        return from
    }
    public static func string(in string: StringType) -> String {
        return string
    }
    public static func start(in string: StringType) -> Self {
        return string.startIndex
    }
    public static func end(in string: StringType) -> Self {
        return string.endIndex
    }
    /// nilable version of index(_ i: Self.Index, offsetBy: Int)
    public func safeIndex(offsetBy: Int, in string: Self.StringType) -> Self? {
        let start = string.startIndex, end = string.endIndex
        var from = self, offset = offsetBy
        while offset < 0 && from > start {
            from = string.index(before: from)
            offset += 1
        }
        while offset > 0 && from < end {
            from = string.index(after: from)
            offset -= 1
        }
        return offset == 0 ? from : nil
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
