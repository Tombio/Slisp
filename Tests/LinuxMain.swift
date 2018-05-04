import XCTest

import SlispTests

var tests = [XCTestCaseEntry]()
tests += SlispTests.allTests()
XCTMain(tests)