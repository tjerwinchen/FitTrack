//
//  ViewAdditions.swift
//  YALFitnessConcept
//
//  Created by Roman Scherbakov on 22.03.16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundSpecificCorners(_ corners: UIRectCorner, cornerRadius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    func xibSetup(_ subview: inout UIView?, nibName: String) {
        subview = loadViewFromNib(nibName)
        subview!.frame = bounds
        subview!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(subview!)
    }
    
    private func loadViewFromNib(_ nibName: String) -> UIView {
        let bundle = Bundle(for: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

    
}
