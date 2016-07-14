//
//  ActivityContainerView.swift
//  YALFitnessConcept
//
//  Created by Roman on 16.03.16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

private let flipAnimationDuration: TimeInterval = 0.2

private let animateTransformScaleX: CGFloat = 0.98
private let animateStateDuration: TimeInterval = 1
private let animateSpringDamping: CGFloat = 0.3
private let animateSpringVelocity: CGFloat = 0.7

class ActivityContainerView: UIView, CAAnimationDelegate {
        
    @IBOutlet
    private weak var containerView: UIView!
    
    @IBOutlet
    private var progressGradientImageView: UIImageView!
        
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet
    private weak var currentProgressLabel: UILabel!
    
    @IBOutlet
    private weak var goalLabel: UILabel!
    
    @IBOutlet
    private weak var containerGradientView: UIView!
    
    @IBOutlet private
    weak var helperViewBottomConstraint: NSLayoutConstraint!
    
    private var subview: UIView?
    
    // MARK - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup(&subview, nibName: "ActivityContainerView")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)!
        xibSetup(&subview, nibName: "ActivityContainerView")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutIfNeeded()
        setCornerRadiuses()
    }
    
    // MARK - Public methods
    func flipView(_ activity: Activity) {
        self.containerView.transform = CGAffineTransform.identity
        configureViewsBeforeFlip(activity)
        let transform :CATransform3D = CATransform3DMakeRotation(CGFloat(M_PI), 0, 1, 0) // rotate around Y
        let flipAnimation = CABasicAnimation(keyPath: "transform")
        flipAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        flipAnimation.toValue = NSValue(caTransform3D: transform)
        flipAnimation.duration = flipAnimationDuration
        flipAnimation.fillMode = kCAFillModeBoth
        flipAnimation.isRemovedOnCompletion = true
        flipAnimation.delegate = self
        subview!.layer.add(flipAnimation, forKey: "transform")
    }
    
    func animationDidStop(_ animation: CAAnimation, finished flag: Bool) {
        if flag == true {
            configureViewsAfterFlip()
            UIView.animate(withDuration: animateStateDuration,
                delay: 0,
                usingSpringWithDamping: animateSpringDamping,
                initialSpringVelocity: animateSpringVelocity,
                options: .curveLinear,
                animations: {
                    self.containerView.transform = CGAffineTransform(scaleX: animateTransformScaleX, y: 1)
                }, completion: nil)
        }
    }
    
    // MARK - Private methods
    private func setCornerRadiuses() {
        layer.cornerRadius = frame.height / 2
        subview!.layer.cornerRadius = subview!.frame.height / 2
        progressGradientImageView.layer.cornerRadius = progressGradientImageView.frame.height / 2
        containerView.layer.cornerRadius = containerView.frame.height / 2
        containerGradientView.layer.cornerRadius = containerGradientView.frame.height / 2
    }
    
    private func configureViewsBeforeFlip(_ activity: Activity) {
        titleLabel.isHidden = true
        currentProgressLabel.isHidden = true
        goalLabel.isHidden = true
        
        titleLabel.text = activity.title
        currentProgressLabel.text = String(activity.currentProgress.cleanValue)
        goalLabel.text = "Your goal is \(activity.goal.cleanValue)"
        
        titleLabel.textColor = activity.activityResource.labelConfigurator?.textColor
        if let fontName = activity.activityResource.labelConfigurator?.titleFontName, let fontSize = activity.activityResource.labelConfigurator?.titleFontSize {
            titleLabel.font = UIFont(name: fontName, size: fontSize)
        }
        
        currentProgressLabel.textColor = activity.activityResource.labelConfigurator?.textColor
        if let fontName = activity.activityResource.labelConfigurator?.currentProgressFontName, let fontSize = activity.activityResource.labelConfigurator?.currentProgressFontSize {
            currentProgressLabel.font = UIFont(name: fontName, size: fontSize)
        }
        
        goalLabel.textColor = activity.activityResource.labelConfigurator?.textColor
        if let fontName = activity.activityResource.labelConfigurator?.goalFontName, let fontSize = activity.activityResource.labelConfigurator?.goalLabelFontSize {
            goalLabel.font = UIFont(name: fontName, size: fontSize)
        }
        
        progressGradientImageView.image = activity.activityResource.gradientImage
        
        helperViewBottomConstraint.constant = min(CGFloat(activity.currentProgress / activity.goal) * frame.height, frame.height)
    }
    
    private func configureViewsAfterFlip() {
        titleLabel.isHidden = false
        currentProgressLabel.isHidden = false
        goalLabel.isHidden = false
    }
    
}
