//
//  AnimationView.swift
//  YALFitnessConcept
//
//  Created by Roman Scherbakov on 17.03.16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

internal let ratioItemWidthToGap: CGFloat = 3.42
internal let dropButtonsPositionCoefficient: CGFloat = 1.08
internal let finalButtonsPositionCoefficient: CGFloat = 1.06
private let transformScale: CGFloat = 0.3

public class AnimationView: UIView {
    
    @IBOutlet
    internal weak var activityContainerView: ActivityContainerView!
        
    // fake button which determines the final position
    internal var centerActivityRoundButton: RoundActivityButton?
    internal var centerActivityRoundButtonIndex: Int = 0
    internal var activitiesCount: Int!
    internal var roundActivityButtons = [RoundActivityButton]()
    internal var gapBetweenActivityButtons: CGFloat = 0.0
    internal var realActivityButtonWidth: CGFloat = 0.0
    public var animationFirstPhaseDidFinish: ((Void) -> Void)?
    public var animationDidFinish: ((Void) -> Void)?
    
    private var activities: [Activity]?
    private var currentActiveRoundButtonTag = 0
    private var subview: UIView?
    
    // MARK - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup(&subview, nibName: "AnimationView")
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)!
        xibSetup(&subview, nibName: "AnimationView")
    }
    
    // MARK - Actions
    func roundButtonPressed(_ roundButton: RoundActivityButton!) {
        if roundButton.isSelected == false {
            roundButton.isSelected = true
            let currentActiveRoundButton = roundActivityButtons[currentActiveRoundButtonTag]
            currentActiveRoundButton.isSelected = false
            currentActiveRoundButtonTag = roundButton.tag
            activityContainerView.flipView(activities![currentActiveRoundButtonTag])
        }
    }
    
    // MARK - Public methods
    public func configureSubviews(_ activitiesCount: Int, activities: [Activity]) {
        self.activitiesCount = activitiesCount
        self.activities = activities
        createAndSetStartPositionRoundActivityButtons()
        activityContainerView.flipView(activities[0])
    }
    
    public func performAnimation() {
        aimateDrop()
    }
        
    // MARK: Private methods
    private func createAndSetStartPositionRoundActivityButtons() {
        let allContentWidth = bounds.width
        let buttonWidth = allContentWidth / CGFloat(activitiesCount)
        gapBetweenActivityButtons = (buttonWidth / ratioItemWidthToGap)
        let deltaWidth = gapBetweenActivityButtons / CGFloat(activitiesCount)
        realActivityButtonWidth = (buttonWidth - deltaWidth - gapBetweenActivityButtons)
        
        centerActivityRoundButton = RoundActivityButton.init(frame: CGRect(x: 0, y: 0, width: realActivityButtonWidth * animateScalFirsteButtonCoefficient, height: realActivityButtonWidth * animateScalFirsteButtonCoefficient))
        centerActivityRoundButton!.backgroundColor = UIColor.clear()
        centerActivityRoundButton!.center = CGPoint(x: bounds.width / 2, y: (bounds.height / 2) / dropButtonsPositionCoefficient)
        
        centerActivityRoundButtonIndex = activitiesCount%2 == 0 ? -1 : activitiesCount / 2
        
        currentActiveRoundButtonTag = 0
        
        addSubview(centerActivityRoundButton!)
        for index in 0..<activitiesCount {
            let startFrame = CGRect(x: gapBetweenActivityButtons + (gapBetweenActivityButtons + realActivityButtonWidth) * CGFloat(index), y: -realActivityButtonWidth, width: realActivityButtonWidth, height: realActivityButtonWidth)
            let roundButton = RoundActivityButton.init(frame: startFrame)
            let activity = activities![index]
            let normalStateImage = activity.activityResource.normalActivityButtonImage
            let selectStateImage = activity.activityResource.selectedActivityButtonImage
            roundButton.setBackgroundImage(normalStateImage, for: UIControlState())
            roundButton.setBackgroundImage(selectStateImage, for: .selected)
            roundButton.setBackgroundImage(selectStateImage, for: [.highlighted, .selected])
            roundButton.isUserInteractionEnabled = false
            roundButton.tag = index
            roundButton.addTarget(self, action: #selector(AnimationView.roundButtonPressed(_:)), for: .touchUpInside)
            roundActivityButtons.append(roundButton)
            subview?.addSubview(roundButton)
        }
        
        // it's necessary when collecting all items. First item should be always bring to front
        subview?.bringSubview(toFront: roundActivityButtons[0])
        
        activityContainerView.transform = CGAffineTransform(scaleX: transformScale, y: transformScale)
        subview?.bringSubview(toFront: activityContainerView)
    }
    
}
