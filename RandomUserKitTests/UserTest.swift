//
//  RandomUserKitTests.swift
//  RandomUserKitTests
//
//  Created by Romain Pouclet on 2017-11-21.
//  Copyright © 2017 Buddybuild. All rights reserved.
//

import XCTest
@testable import RandomUserKit

class RandomUserKitTests: XCTestCase {
    
    func testUserIsDecoded() throws {
        guard let path = Bundle(for: type(of: self)).path(forResource: "random-response", ofType: "json") else {
            XCTFail("Unable to find path to fixture")
            return
        }

        guard let content = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            XCTFail("Unable to load fixtures")
            return
        }

        let expected = Response(
            results: [
                User(
                    name: .init(
                        first: "romain",
                        last: "hoogmoed"
                    ),
                    email: "romain.hoogmoed@example.com"
                )
            ]
        )

        let decoder = JSONDecoder()
        let actual = try decoder.decode(Response<User>.self, from: content)

        XCTAssertEqual(expected, actual)
    }
}
