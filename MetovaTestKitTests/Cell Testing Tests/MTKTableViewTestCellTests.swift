//
//  MTKTableViewTestCellTests.swift
//  MetovaTestKit
//
//  Created by Nick Griffith on 11/29/18.
//  Copyright © 2016 Metova. All rights reserved.
//
//  MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import XCTest

@testable import MetovaTestKit

class TableViewTestCellTests: MTKBaseTestCase {

    func testGoodCell() {
        let dataSource = TableDataSource(rows: 1)
        let tableView = UITableView()
        let indexPath = IndexPath(row: 0, section: 0)
        
        tableView.dataSource = dataSource
        
        let testExecutedExpectation = expectation(description: "Test block should be executed!")
        tableView.testCell(at: indexPath) { (testCell: MockCellTypeA) in
            testExecutedExpectation.fulfill()
        }
        wait(for: [testExecutedExpectation], timeout: 0)
    }
    
    func testNoDataSource() {
        let tableView = UITableView()
        let indexPath = IndexPath(row: 0, section: 0)
        
        let description = "failed - \(tableView) does not have a dataSource"
        expectTestFailure(TestFailureExpectation(description: description, lineNumber: #line+1)) {
            tableView.testCell(at: indexPath) { (testCell: UITableViewCell) in
                XCTFail("Test closure should not be called when cell can not be properly instantiated and cast.")
            }
        }
    }
    
    func testNoCellFailure() {
        let dataSource = TableDataSource()
        let tableView = UITableView()
        let indexPath = IndexPath(row: 0, section: 0)
        
        tableView.dataSource = dataSource
        
        let description = "failed - \(tableView) does not have a cell at \(indexPath)"
        expectTestFailure(TestFailureExpectation(description: description, lineNumber: #line+1)) {
            tableView.testCell(at: indexPath) { (testCell: UITableViewCell) in
                XCTFail("Test closure should not be called when cell can not be properly instantiated and cast.")
            }
        }
    }
    
    func testWrongCellTypeFailure() {
        let dataSource = TableDataSource(rows: 3)
        let tableView = UITableView()
        let indexPath = IndexPath(row: 1, section: 0)

        tableView.dataSource = dataSource
        
        let description = "failed - Cell at \(indexPath) expected to be \(MockCellTypeA.self) was actually \(MockCellTypeB.self)"
        expectTestFailure(TestFailureExpectation(description: description, lineNumber: #line+1)) {
            tableView.testCell(at: indexPath) { (testCell: MockCellTypeA) in
                XCTFail("Test closure should not be called when cell can not be properly instantiated and cast.")
            }
        }
    }
}

class MockCellTypeA: UITableViewCell {}
class MockCellTypeB: UITableViewCell {}

class TableDataSource: NSObject, UITableViewDataSource {
    
    let rows: Int
    
    init(rows: Int = 0) {
        self.rows = rows
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return tableView.dequeueReusableCell(withIdentifier: "A") ?? MockCellTypeA()
        case 1: return tableView.dequeueReusableCell(withIdentifier: "B") ?? MockCellTypeB()
        default: return UITableViewCell()
        }
    }
}
