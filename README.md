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
Or you can search in a `String` for a `Character`:

```
let firstWord: Substring = str[..<(.first(of:" "))]
let lastWord: Substring = str[(.last(of: " ")+1)...]
```
All subscript operators have setters defined so you can modify
string contents. There are also subscripts prefixed by the label
`safe:` that can return nil if offseting results in an invalid index.

```
XCTAssertNil(str[safe: .start-1])
XCTAssertNil(str[safe: .end+1])
```
Attempting to assign to an invalid index is still a fatal error.
