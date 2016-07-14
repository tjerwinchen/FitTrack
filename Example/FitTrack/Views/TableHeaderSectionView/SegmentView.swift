//
//  SegmentView.swift
//  YALFitnessConcept
//
//  Created by Roman on 22.03.16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

private let segmentViewCornerRadius: CGFloat = 13.0
private let segmentViewBoederWidth: CGFloat = 1.0

class SegmentView: UIView {

    private let buttonOvalLayer = CAShapeLayer()

    // MARK - Lifecycle
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        configureSegmentView()
        createButtonOvalLayer()
    }
    
    // MARK - Private methods
    private func configureSegmentView() {
        layer.cornerRadius = segmentViewCornerRadius
        layer.borderWidth = segmentViewBoederWidth
        layer.borderColor = UIColor.white().cgColor
    }
    
    private func createButtonOvalLayer() {
        let buttonOvalLayerHeight = bounds.height
        let buttonOvalLayerWidth = bounds.width / 2
        let buttonOvalPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: buttonOvalLayerWidth, height: buttonOvalLayerHeight), cornerRadius: segmentViewCornerRadius)
        buttonOvalLayer.path = buttonOvalPath.cgPath
        buttonOvalLayer.fillColor = UIColor.white().cgColor
        layer.addSublayer(buttonOvalLayer)
    }
    
    // MARK - Public methods
    func setIndicatorPosition(_ position: CGFloat) {
        buttonOvalLayer.position = CGPoint(x: position, y: bounds.origin.y)
    }
}
