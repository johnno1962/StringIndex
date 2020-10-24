## StringIndex - Resonable indexing into Swift Strings

An experimental package to explore what can be done about Swift's
dystopian string indexing. At the moment, you have to perform this
memorable dance to get the 5th character of a `String`:

```
    str[str.index(str.startIndex, offsetBy: 5)]
```
This package defines addition, and subtraction operators for the
`String.Index` type returning a temporary struct which conveys
the offset and index to a new subscript operator on `String` which
indexes by the offset late (when it knows the String being indexed).
The result of this is you can now get the same result by typing:

```
    let c: Character = str[str.startIndex+5]
```
There are also range operators and subscripts defined so you can
use the following to remove the leading and trailing characters of
a string for example:

```
    str[str.startIndex+1 ..< str.endIndex-1]
```
You get the idea.
