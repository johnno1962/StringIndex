//
//  Subscripts.swift
//  StringIndex
//
//  Created by John Holdsworth on 17/12/2024.
//
//  A few operators simplifying offsettting a String index
//
//  Repo: https://github.com/johnno1962/StringIndex.git
//
//  $Id: //depot/StringIndex/Sources/StringIndex/Subscripts.swift#5 $
//

import Foundation

extension StringProtocol {
    public typealias IndexType = String.Index
    public typealias OffsetIndex = IndexType.OffsetType
    public typealias OISubstring = String // Can/should? be Substring
    public typealias OOISubstring = OISubstring? // "safe:" prefixed subscripts
    
    public func index(of: OffsetIndex) -> IndexType? {
        return of.index(in: String(self))
    }
    /// Subscripts on StringProtocol for OffsetIndex type
    public subscript (offset: OffsetIndex) -> Character {
        get {
            guard let result = self[safe: offset] else {
                fatalError("Invalid offset index \(offset), \(#function)")
            }
            return result
        }
        set (newValue) {
            guard let start = offset.index(in: String(self)) else {
                fatalError("Invalid offset index \(offset), \(#function)")
            }
            // Assigning Chacater to endIndex is an append.
            let end = start + (start < IndexType.end(in: String(self)) ? 1 : 0)
            self[start ..< end] = OISubstring(String(newValue))
        }
    }

    // lhs ..< rhs operator
    public subscript (range: Range<OffsetIndex>) -> OISubstring {
        get {
            guard let result = self[safe: range] else {
                fatalError("Invalid range of offset index \(range), \(#function)")
            }
            return result
        }
        set (newValue) {
            guard let from = range.lowerBound.index(in: String(self)),
                  let to = range.upperBound.index(in: String(self)) else {
                fatalError("Invalid range of offset index \(range), \(#function)")
            }
            let before = self[..<from], after = self[to...]
            self = Self(String(before) + String(newValue) + String(after))!
        }
    }
    // ..<rhs operator
    public subscript (range: PartialRangeUpTo<OffsetIndex>) -> OISubstring {
        get { return self[.start ..< range.upperBound] }
        set (newValue) { self[.start ..< range.upperBound] = newValue }
    }
    // lhs... operator
    public subscript (range: PartialRangeFrom<OffsetIndex>) -> OISubstring {
        get { return self[range.lowerBound ..< .end] }
        set (newValue) { self[range.lowerBound ..< .end] = newValue }
    }

    // =================================================================
    // "safe" nil returning subscripts on StringProtocol for OffsetIndex
    // from:  https://forums.swift.org/t/optional-safe-subscripting-for-arrays
    public subscript (safe offset: OffsetIndex) -> Character? {
        get { return offset.index(in: String(self)).flatMap { self[$0] } }
        set (newValue) { self[offset] = newValue! }
    }
    // lhs ..< rhs operator
    public subscript (safe range: Range<OffsetIndex>) -> OOISubstring {
        get {
            guard let from = range.lowerBound.index(in: String(self)),
                  let to = range.upperBound.index(in: String(self)),
                from <= to else { return nil }
            return OISubstring(self[from ..< to])
        }
        set (newValue) { self[range] = newValue! }
    }
    // ..<rhs operator
    public subscript (safe range: PartialRangeUpTo<OffsetIndex>) -> OOISubstring {
        get { return self[safe: .start ..< range.upperBound] }
        set (newValue) { self[range] = newValue! }
    }
    // lhs... operator
    public subscript (safe range: PartialRangeFrom<OffsetIndex>) -> OOISubstring {
        get { return self[safe: range.lowerBound ..< .end] }
        set (newValue) { self[range] = newValue! }
    }

    // =================================================================
    // Misc.
    public mutating func replaceSubrange<C>(_ bounds: Range<OffsetIndex>,
        with newElements: C) where C : Collection, C.Element == Character {
        self[bounds] = OISubstring(newElements)
    }
    public mutating func insert<S>(contentsOf newElements: S, at i: OffsetIndex)
        where S : Collection, S.Element == Character {
        replaceSubrange(i ..< i, with: newElements)
    }
    public mutating func insert(_ newElement: Character, at i: OffsetIndex) {
        insert(contentsOf: String(newElement), at: i)
    }
}

#if false // V. slow to compile
public protocol OffsetIndexable {
    associatedtype IndexType: Offsetable
    func index(of: IndexType.OffsetType) -> IndexType?
}

extension String: OffsetIndexable {
    public func index(of: IndexType.OffsetType) -> IndexType? {
        return of.index(in: String(self))
    }

}
extension Substring: OffsetIndexable {
    public typealias IndexType = String.IndexType
    public func index(of: IndexType.OffsetType) -> IndexType? {
        return of.index(in: String(self))
    }
}
#endif
