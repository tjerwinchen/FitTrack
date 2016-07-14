//
//  Animations.swift
//  YALFitnessConcept
//
//  Created by Roman Scherbakov on 17.03.16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

private let animateDropDuration: TimeInterval = 0.3
private let animateDropDumping: CGFloat = 0.7
private let animateDropVelocity: CGFloat = 0.5

private let animateExtendDistanceDuration: TimeInterval = 0.2
private let animateExtendDistanceDelay: TimeInterval = 0.0

private let animateCollectActivitiesDuration: TimeInterval = 0.25
private let animateCollectActivitiesDelay: TimeInterval = 0.0

private let animateScaleFirstButtonDuration: TimeInterval = 0.2
private let animateScalFirsteButtonDelay: TimeInterval = 0.0
internal let animateScalFirsteButtonCoefficient: CGFloat = 1.33

private let animateMoveDuration: TimeInterval = 0.4
private let animateMoveDelay: TimeInterval = 0.0

private let animateScaleDuration: TimeInterval = 1.0
private let animateScaleDelay: TimeInterval = 0.0
private let animatScaleDumping: CGFloat = 0.3
private let animateScaleVelocity: CGFloat = 0.7

private let animateMoveFinalPositionDuration: TimeInterval = 0.3
private let animateMoveFinalPositionDelay: TimeInterval = 0.1

extension AnimationView {
    
    internal func aimateDrop() {
        struct Counter {
            static var index = 0
        }
        if Counter.index == roundActivityButtons.count {
            animateExtendDistance()
            
            return
        }
        let roundActivityButton = roundActivityButtons[Counter.index]
        let delay: TimeInterval = Counter.index == 0 ? 1 : 0
        UIView.animate(withDuration: animateDropDuration,
            delay: delay,
            usingSpringWithDamping: animateDropDumping,
            initialSpringVelocity: animateDropVelocity,
            options: .curveLinear,
            animations: {
                let changedFrame = CGRect(x: roundActivityButton.frame.origin.x, y: (self.bounds.height / 2) / dropButtonsPositionCoefficient - roundActivityButton.frame.height / 2, width: roundActivityButton.frame.width, height: roundActivityButton.frame.height)
                roundActivityButton.frame = changedFrame
            }) { finished in
                if finished == true {
                    Counter.index += 1
                    self.aimateDrop()
                }
        }
    }
    
    private func animateExtendDistance() {
        UIView.animate(withDuration: animateExtendDistanceDuration,
            delay: animateExtendDistanceDelay,
            options: .curveLinear,
            animations: {
                for index in 0..<self.activitiesCount {
                    if index == self.centerActivityRoundButtonIndex { // the number is odd then the central position of the index does not change
                        continue
                    }
                    let roundActivityButton = self.roundActivityButtons[index]
                    let originDeltaX: CGFloat = (self.activitiesCount / (index + 1)) < 2 ? -self.gapBetweenActivityButtons / 2 : self.gapBetweenActivityButtons / 2
                    let changedFrame = CGRect(x: roundActivityButton.frame.origin.x - originDeltaX, y: roundActivityButton.frame.origin.y, width: roundActivityButton.frame.width, height: roundActivityButton.frame.height)
                    roundActivityButton.frame = changedFrame
                }
            }) { finished in
                if finished == true {
                    self.animateCollect()
                }
        }
    }
    
    private func animateCollect() {
        UIView.animate(withDuration: animateCollectActivitiesDuration,
            delay: animateCollectActivitiesDelay,
            options: .curveEaseIn,
            animations: {
                for index in 0..<self.activitiesCount {
                    if index == self.centerActivityRoundButtonIndex { // the number is odd then the central position of the index does not change
                        continue
                    }
                    let roundActivityButton = self.roundActivityButtons[index]
                    roundActivityButton.center = self.centerActivityRoundButton!.center
                }
            }) { finished in
                if finished == true {
                    self.animationScaleFirstButton()
                }
        }
    }
    
    private func animationScaleFirstButton() {
        UIView.animate(withDuration: animateScaleFirstButtonDuration,
            delay: animateScalFirsteButtonDelay,
            options: .curveLinear,
            animations: {
                // scale first item
                let roundActivityButton = self.roundActivityButtons[0]
                roundActivityButton.transform = CGAffineTransform(scaleX: animateScalFirsteButtonCoefficient, y: animateScalFirsteButtonCoefficient)
            }) { finished in
                if finished == true {
                    self.animateMoveToTop()
                }
        }
    }
    
    private func animateMoveToTop() {
        UIView.animate(withDuration: animateMoveDuration,
            delay: animateMoveDelay,
            options: .curveEaseIn,
            animations: {
                for index in 0..<self.activitiesCount {
                    let roundActivityButton = self.roundActivityButtons[index]
                    roundActivityButton.center = self.activityContainerView.center
                }
            }) { finished in
                if finished == true {
                    for index in 0..<self.activitiesCount {
                        let roundActivityButton = self.roundActivityButtons[index]
                        roundActivityButton.isHidden = true
                    }
                    // make first button frame as other buttons
                    self.roundActivityButtons[0].frame = self.roundActivityButtons[1].frame
                    self.animateScaleVeiw()
                    self.animateMoveToFinalPosition()
                }
        }
    }
    
    private func animateScaleVeiw() {
        let currentActiveRoundButton = roundActivityButtons[0]
        currentActiveRoundButton.isSelected = true
        UIView.animate(withDuration: animateScaleDuration,
            delay: animateScaleDelay,
            usingSpringWithDamping: animatScaleDumping,
            initialSpringVelocity: animateScaleVelocity,
            options: .curveEaseOut,
            animations: {
                self.activityContainerView.alpha = 1
                self.activityContainerView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { finished in
                if finished == true {
                    self.animationFirstPhaseDidFinish?()
                }
        }
    }
    
    private func animateMoveToFinalPosition() {
        UIView.animate(withDuration: animateMoveFinalPositionDuration,
            delay: animateMoveFinalPositionDelay,
            options: UIViewAnimationOptions(),
            animations: {
                for index in 0..<self.activitiesCount {
                    let roundActivityButton = self.roundActivityButtons[index]
                    roundActivityButton.isHidden = false
                    roundActivityButton.isUserInteractionEnabled = true
                    let finalFrame = CGRect(x: self.gapBetweenActivityButtons + (self.gapBetweenActivityButtons + self.realActivityButtonWidth) * CGFloat(index), y: self.bounds.height / 2 * finalButtonsPositionCoefficient - roundActivityButton.frame.height / 2, width: self.realActivityButtonWidth, height: self.realActivityButtonWidth)
                    roundActivityButton.frame = finalFrame
                }
            }, completion:nil)
    }
    
}
