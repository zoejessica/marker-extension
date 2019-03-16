# Marker Extension

Sample code to accompany blog post on Xcode extensions:
implements an Xcode Source Editor extension to format Swift code.

This extension uses regular expressions to reformat malformed code marks (`TODO`, `FIXME` and `MARK`)
to be uppercased with a trailing colon,
enabling Xcode to recognize and add them to quick navigation links.

This formatting rule was inspired by one of the many rules provided by the
[SwiftFormat](https://www.github.com/nicklockwood/SwiftFormat) project.
A fuller implementation like SwiftFormat's which also recognizes code marks inside `/* */` comments
is left as an exercise for the reader 😇.
