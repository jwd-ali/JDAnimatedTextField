//
//  CALayer+Extension.swift
//  WifiAnimation
//
//  Created by Jawad Ali on 24/09/2021.
//

import UIKit
extension CGFloat {
  var deg2rad: CGFloat {
    return self * .pi / 180
  }
}

extension Int {
  var deg2rad: CGFloat {
    return CGFloat(self) * .pi / 180
  }
}


extension CALayer {
  typealias AnimationCompletion = (() -> Void)?
  func animateRotateFrames(values: [CGFloat], times: [Double], duration: Double, delay: Double = 0, repeatCount: Float = 0, completion: AnimationCompletion = nil) {
    CATransaction.begin()
    let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
    animation.values = values
    animation.keyTimes = times.map { NSNumber(value: $0) }
    animation.duration = CFTimeInterval(duration)
    animation.fillMode = .forwards
    animation.beginTime = CACurrentMediaTime() + delay
    CATransaction.setCompletionBlock(completion)
    animation.isRemovedOnCompletion = false
    animation.repeatCount = repeatCount
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    self.add(animation, forKey: nil)
    CATransaction.commit()
  }

  func animatePosition(fromPoint: CGFloat = 0, yPoint: CGFloat, duration: Double) {
    let animation = CABasicAnimation(keyPath: "position.y")
    animation.fromValue = fromPoint            // animate from current position ...
    animation.toValue = yPoint                         // ... to whereever the new position is
    animation.duration = duration
    animation.fillMode = .forwards
    animation.isRemovedOnCompletion = false
    self.add(animation, forKey: nil)
  }
}
extension CAShapeLayer {
  func strokeAnimation( duration: Double, from: CGFloat, to: CGFloat, completion: AnimationCompletion = nil) {
    CATransaction.begin()
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = from
    animation.toValue = to
    animation.duration = duration
    animation.fillMode = .forwards
    animation.isRemovedOnCompletion = false
    CATransaction.setCompletionBlock(completion)
    self.add(animation, forKey: "line")
    CATransaction.commit()
  }
}
