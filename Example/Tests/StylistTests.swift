//
//  StylistTests.swift
//  StylableSwiftUI_Tests
//
//  Created by Kerr Marin Miller on 09/04/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import SwiftUI

@testable import StylableSwiftUI

final class StylistTests: XCTestCase {

    func testStylist() throws {
        let stylist = Stylist()

        var didApplyGeneral = false
        var didApplySpecific = false

        stylist.addStyle(identifier: "element/atom") { view -> AnyView in
            didApplySpecific = true
            return AnyView(view.foregroundColor(.red))
        }

        stylist.addStyle(identifier: "organism/atom") { view -> AnyView in
            didApplyGeneral = true
            return AnyView(view.foregroundColor(.blue))
        }

        let stylable = Stylable(AnyView(Text("Test")), identifier: "element/atom")
        _ = stylist.style(view: stylable, identifier: "element/atom")

        XCTAssertFalse(didApplyGeneral)
        XCTAssertTrue(didApplySpecific)
    }

    func testStylistPerformance() {
        let stylist = Stylist()
        let styles = largeNumberOfStyles()
        stylist.addStyles(styles: { return styles })

        measure {
            let id1 = styles.randomElement()?.identifier
            let id2 = styles.randomElement()!.identifier
            for _ in  0..<10_000 {
                _ = stylist.style(view: Stylable(Text("Test"),
                                                 identifier: id1),
                                  identifier: id2)
            }
        }
    }

    func testThemeing() {
        let stylist = Stylist()

        var didApplyGeneric = false
        var didApplyThemed = false

        stylist.addStyle(identifier: "element/atom") { view -> AnyView in
            didApplyGeneric = true
            return AnyView(view.foregroundColor(.red))
        }

        stylist.addStyle(identifier: "@dark/element/atom") { view -> AnyView in
            didApplyThemed = true
            return AnyView(view.foregroundColor(.blue))
        }

        stylist.currentTheme = Stylist.Theme(name: "@dark")

        let stylable = Stylable(AnyView(Text("Test")), identifier: "element/atom")
        _ = stylist.style(view: stylable, identifier: "element/atom")

        XCTAssertFalse(didApplyGeneric)
        XCTAssertTrue(didApplyThemed)
    }
}

private var largeNumberOfStyles: () -> [Style] = {
    return (0..<100).map { _ -> Style in
        Style(StylistIdentifier(UUID().uuidString), apply: {
            $0.background(Color.red)
        })
    }
}
