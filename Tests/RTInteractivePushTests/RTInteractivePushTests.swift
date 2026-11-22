import RTInteractivePush
import UIKit
import XCTest

final class RTInteractivePushTests: XCTestCase {
    func testPackageExposesAndLinksCategories() {
        let finished = expectation(description: "Exercise the Objective-C categories")

        DispatchQueue.main.async {
            let rootViewController = UIViewController()
            XCTAssertNil(rootViewController.rt_nextSibling())

            let navigationController = UINavigationController(rootViewController: rootViewController)
            navigationController.loadViewIfNeeded()

            XCTAssertFalse(navigationController.rt_isInteractivePushEnabled)
            XCTAssertNil(navigationController.rt_interactivePushGestureRecognizer)

            navigationController.rt_isInteractivePushEnabled = true
            XCTAssertTrue(navigationController.rt_isInteractivePushEnabled)
            XCTAssertTrue(
                navigationController.rt_interactivePushGestureRecognizer?.view === navigationController.view
            )

            navigationController.rt_isInteractivePushEnabled = false
            XCTAssertFalse(navigationController.rt_isInteractivePushEnabled)
            XCTAssertNil(navigationController.rt_interactivePushGestureRecognizer)
            finished.fulfill()
        }

        wait(for: [finished], timeout: 10)
    }
}
