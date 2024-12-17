//
//  OffsetIndex.swift
//  StringIndex
//
//  Created by John Holdsworth on 17/12/2024.
//
//  A few operators simplifying offsettting a String index
//
//  Repo: https://github.com/johnno1962/StringIndex.git
//
//  $Id: //depot/StringIndex/Sources/StringIndex/OffsetIndex.swift#1 $
//

import Foundation

extension String {
    /// Represents an index to be offset
    public enum OffsetImpl<IndexType: Offsetable>: Comparable {
        
        case offsetIndex(index: IndexType?, offset: Int), start, end,
            first(of: String, regex: Bool = false, end: Bool = false),
            last(of: String, regex: Bool = false, end: Bool = false)
        indirect case either(_ index: OffsetImpl, or: OffsetImpl),
            // can chain either an OffsetIndex or an integer offset
            chained(previous: OffsetImpl, next: OffsetImpl?, offset: Int)
        /// Required by Comparable to check when creating ranges
        public static func < (lhs: OffsetImpl, rhs: OffsetImpl) -> Bool {
            return false // slight cheat here as we don't know the string
        }

        // Chaining offsets in expressions
        public static func + (index: OffsetImpl, offset: Int) -> OffsetImpl {
            return .chained(previous: index, next: nil, offset: offset)
        }
        public static func - (index: OffsetImpl, offset: Int) -> OffsetImpl {
            return index + -offset
        }
        public static func + (index: OffsetImpl,
                              offset: OffsetImpl) -> OffsetImpl {
            return .chained(previous: index, next: offset, offset: 0)
        }
        public static func || (either: OffsetImpl,
                               or: OffsetImpl) -> OffsetImpl {
            return .either(either, or: or)
        }

        /// nilable version of index(_ i: Self.Index, offsetBy: Int)
        public func safeIndex(_ from: IndexType, offsetBy: Int,
                              in string: IndexType.StringType)
            -> IndexType? {
            let start = IndexType.start(in: string),
                end = IndexType.end(in: string)
            var from = from, offset = offsetBy
                while offset < 0 && from > start {
                from = from.indexBefore(in: string)
                offset += 1
            }
            while offset > 0 && from < end {
                from = from.indexAfter(in: string)
                offset -= 1
            }
            return offset == 0 ? from : nil
        }
        /// realise index from OffsetIndex
        public func index(in string: IndexType.StringType, from: IndexType? = nil) -> IndexType? {
            switch self {
            case .offsetIndex(let index, let offset):
                guard let index = index else { return nil }
                return safeIndex(index, offsetBy: offset, in: string)

            // Public interface
            case .start:
                return IndexType.start(in: string)
            case .end:
                return IndexType.end(in: string)
            case .first(let target, let regex, let end):
                return locate(in: string, target: target, from: from,
                              last: false, regex: regex, end: end)
            case .last(let target, let regex, let end):
                return locate(in: string, target: target, from: from,
                              last: true, regex: regex, end: end)
            case .either(let first, let second):
                return first.index(in: string) ?? second.index(in: string)

            case .chained(let previous, let next, let offset):
                guard let from = previous.index(in: string, from: from) else { return nil }
                return next != nil ? next!.index(in: string, from: from) :
                    safeIndex(from, offsetBy: offset, in: string)
            }
        }
        public func locate(in string: IndexType.StringType, target: String, from: IndexType?,
                           last: Bool, regex: Bool, end: Bool) -> IndexType? {
            let bounds = last ?
                IndexType.start(in: string)..<(from ?? IndexType.end(in: string)) :
                (from ?? IndexType.start(in: string))..<IndexType.end(in: string)
            let string = IndexType.string(in: string)
            if regex {
                do {
                    let regex = try NSRegularExpression(pattern: target, options: [])
                    if let match = (last ? regex.matches(in: string,
                            range: IndexType.nsRange(bounds, in: string)).last :
                        regex.firstMatch(in: string,
                            range: IndexType.nsRange(bounds, in: string)))?.range {
                        if #available(OSX 10.15, iOS 13.0, tvOS 13.0, *) {
                            return Range(match, in: string).flatMap {
                                let r = IndexType.myRange(from: $0, in: string)
                                return (end ? r.upperBound : r.lowerBound)
                            }
                        } else {
                            // Fallback on earlier versions
                            let loc = end ? NSMaxRange(match) : match.location
                            let r = NSString(string: string).substring(to: loc).endIndex
                            return IndexType.myRange(from: r..<r, in: string).lowerBound
                        }
                    }
                } catch {
                    fatalError("StringIndex: Invalid regular expression: \(error)")
                }
            } else if let bounds = Range<String.Index>(
                        IndexType.nsRange(bounds, in: string), in: string),
                      let match = string.range(of: target,
                           options: last ? .backwards : [], range: bounds) {
                let match = IndexType.myRange(from: match, in: string)
                return end ? match.upperBound : match.lowerBound
            }
            return nil
        }
    }
}
