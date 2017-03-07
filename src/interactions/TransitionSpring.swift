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

import Foundation

/** Attaches a position to a destination on either side of a transition using a spring. */
public class TransitionSpring<T: Zeroable>: Spring<T> {

  public let backwardDestination: T
  public let forwardDestination: T

  /**
   - parameter value: The property to be updated by the value stream.
   - parameter back: The destination to which the spring will pull the view when transitioning
                     backward.
   - parameter fore: The destination to which the spring will pull the view when transitioning
                     forward.
   - parameter direction: The spring will change its destination in reaction to this property's
                          changes.
   - parameter system A function capable of creating a spring source.
   */
  public init(back backwardDestination: T,
              fore forwardDestination: T,
              direction: ReactiveProperty<TransitionContext.Direction>,
              threshold: CGFloat,
              system: @escaping SpringToStream<T>) {
    self.backwardDestination = backwardDestination
    self.forwardDestination = forwardDestination
    self.initialValue = direction == .forward ? backwardDestination : forwardDestination

    self.toggledDestination = direction.rewrite([.backward: backwardDestination, .forward: forwardDestination])
    super.init(threshold: threshold, system: system)
  }

  public override func add(to property: ReactiveProperty<T>, withRuntime runtime: MotionRuntime) {
    property.value = initialValue

    runtime.add(toggledDestination, to: destination)
    super.add(to: property, withRuntime: runtime)
  }

  private let initialValue: T
  private let toggledDestination: MotionObservable<T>
}
