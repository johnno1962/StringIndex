## StringIndex - Reasonable indexing into Swift Strings

An experimental package to explore what can be done about Swift's
dystopian string indexing. At the moment, you have to perform this
memorable dance to get the 5th character of a `String`:

```
let fifthChar: Character = str[str.index(str.startIndex, offsetBy: 4)]
```
This package defines addition, and subtraction operators for the
`String.Index` type returning a temporary enum which conveys
the offset and index to subscript operators on `StringProtocol` which
iadvances by the offset lazilly (when it knows the String being indexed).
The result of this is you can now get the same result by typing:

```
let fifthChar: Character = str[.start+4]
```
There are also range operators and subscripts defined so you can
use the following to remove the leading and trailing characters of
a string for example:

```
let trimmed: Substring = str[.start+1 ..< .end-1]
```
Or you can search in a `String` for another `String` and
use the index of the start or the end of the match:

```
let firstWord: Substring = str[..<(.first(of:" "))]
let lastWord: Substring = str[(.last(of: " ", end: true))...]
```
You can search for regular expression patterns:

```
let firstWord: Substring = str[..<(.first(of:#"\w+"#, regex: true, end: true))]
let lastWord: Substring = str[(.last(of: #"\w+"#, regex: true))...]
```
Movements around the string can be chained together using the `+` opertator:

```
let firstTwoWords = str[..<(.first(of:#"\w+"#, regex: true, end: true) +
                            .first(of:#"\w+"#, regex: true, end: true))]
```
To realise a String.Index from these expressions use the 
index(of:) method on String from the package.

```
XCTAssertEqual(str.index(of: .start), str.startIndex)
XCTAssertEqual(str.index(of: .first(of: " ")), str.firstIndex(of: " "))
```
All subscript operators have setters defined so you can modify
string contents. There are also subscripts prefixed by the label
`safe:` that can return nil if offseting results in an invalid index.

```
XCTAssertNil(str[safe: .start-1])
XCTAssertNil(str[safe: .end+1])
```
Attempting to assign to an invalid index is still a fatal error.
Have a look through the tests to see what else you can do.

$Date: 2020/12/10 $
