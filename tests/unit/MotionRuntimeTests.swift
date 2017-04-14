/*
 Copyright 2016-present The Material Motion Authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import XCTest
import MaterialMotion

class MotionRuntimeTests: XCTestCase {

  func testReactiveObjectCacheSupportsSubclassing() {
    let shapeLayer = CAShapeLayer()
    let castedLayer: CALayer = shapeLayer

    let runtime = MotionRuntime(containerView: UIView())

    let reactiveShapeLayer = runtime.get(shapeLayer)
    let reactiveCastedLayer = runtime.get(castedLayer)

    XCTAssertTrue(reactiveShapeLayer === reactiveCastedLayer)
  }

  func testInteractionsReturnsEmptyArrayWithoutAnyAddedInteractions() {
    let runtime = MotionRuntime(containerView: UIView())

    let results = runtime.interactions(for: UIView()) { $0 as? Draggable }
    XCTAssertEqual(results.count, 0)
  }

  func testOnlyReturnsInteractionsOfTheCorrectType() {
    let runtime = MotionRuntime(containerView: UIView())

    let view = UIView()
    runtime.add(Draggable(), to: view)
    runtime.add(Rotatable(), to: view)

    let results = runtime.interactions(for: view) { $0 as? Draggable }
    XCTAssertEqual(results.count, 1)
  }
}
