import Testing
@testable import PrismCalc

@Suite("ContentView tabs tests")
struct ContentViewTabsTests {

    @Test("Tab identifiers contain required tabs")
    func testRequiredTabsPresent() throws {
        let all = Set(ContentView.TabIdentifier.allCases)
        // Verify core tabs exist
        #expect(all.contains(.calculator))
        #expect(all.contains(.tip))
        #expect(all.contains(.split))
        #expect(all.contains(.discount))
        #expect(all.contains(.more))
    }

    @Test("Pro flags are correct for tabs")
    func testProFlags() throws {
        #expect(ContentView.TabIdentifier.calculator.isPro == false)
        #expect(ContentView.TabIdentifier.tip.isPro == true)
        #expect(ContentView.TabIdentifier.split.isPro == true)
        #expect(ContentView.TabIdentifier.discount.isPro == true)
        #expect(ContentView.TabIdentifier.more.isPro == false)
    }

    @Test("Icon mapping returns non-empty values")
    func testIconMapping() throws {
        for tab in ContentView.TabIdentifier.allCases {
            let icon = tab.icon
            #expect(!icon.isEmpty, "Icon should not be empty for \(tab)")
        }
    }
}
