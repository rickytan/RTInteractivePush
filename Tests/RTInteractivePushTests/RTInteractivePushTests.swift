import RTInteractivePush
import UIKit
import XCTest

final class RTInteractivePushTests: XCTestCase {
    func testPackageExposesAndLinksCategories() {
        let finished = expectation(description: "Exercise the Objective-C categories")

        DispatchQueue.main.async {
            let rootViewController = UIViewController()
            XCTAssertNil(rootViewController.rt_nextSiblingController())

            let navigationController = UINavigationController(rootViewController: rootViewController)
            navigationController.loadViewIfNeeded()

            XCTAssertFalse(navigationController.rt_enableInteractivePush)
            XCTAssertNil(navigationController.rt_interactivePushGestureRecognizer)

            navigationController.rt_enableInteractivePush = true
            XCTAssertTrue(navigationController.rt_enableInteractivePush)
            XCTAssertTrue(
                navigationController.rt_interactivePushGestureRecognizer?.view === navigationController.view
            )

            navigationController.rt_enableInteractivePush = false
            XCTAssertFalse(navigationController.rt_enableInteractivePush)
            XCTAssertNil(navigationController.rt_interactivePushGestureRecognizer)
            finished.fulfill()
        }

        wait(for: [finished], timeout: 10)
    }
}
