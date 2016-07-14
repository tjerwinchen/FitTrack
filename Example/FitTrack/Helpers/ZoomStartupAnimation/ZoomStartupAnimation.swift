//
//  ZoomStartupAnimation.swift
//  YALFitnessConcept
//
//  Created by Roman Scherbakov on 22.03.16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

private let startAnimationImageWidth: CGFloat = 172.0
private let finishAnimationImageWidth: CGFloat = 2000.0

private let transformAnimationDuration: TimeInterval = 0.3
private let transformAnimationDelay: TimeInterval = 1
private let maskBackgroundImageViewAnimationDuration: TimeInterval = 0.1
private let maskBackgroundImageViewAnimationDelay: TimeInterval = 1.1

class ZoomStartupAnimation {
    
    static func performAnimation(_ window: UIWindow, navControllerIdentifier: String, backgroundImage: UIImage, animationImage: UIImage) {
        let backgroundImageView = UIImageView(frame: UIScreen.main().bounds)
        backgroundImageView.image = backgroundImage

        window.addSubview(backgroundImageView)
        window.makeKeyAndVisible()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navController = mainStoryboard.instantiateViewController(withIdentifier: navControllerIdentifier) as! UINavigationController
        window.rootViewController = navController
        
        navController.view.layer.mask = CALayer()
        navController.view.layer.mask!.contents = animationImage.cgImage
        navController.view.layer.mask!.bounds = CGRect(x: 0, y: 0, width: startAnimationImageWidth, height: startAnimationImageWidth)
        navController.view.layer.mask!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        navController.view.layer.mask!.position = CGPoint(x: navController.view.frame.width / 2, y: navController.view.frame.height / 2)
        
        let maskBackgroundImageView = UIImageView(frame: navController.view.layer.mask!.frame)
        maskBackgroundImageView.image = animationImage
        navController.view.addSubview(maskBackgroundImageView)
        navController.view.bringSubview(toFront: maskBackgroundImageView)
        
        createTransformAnimation(navController, maskBackgroundImageView: maskBackgroundImageView)
        maskBackgroundImageViewAnimation(maskBackgroundImageView, navController: navController)
    }
    
    private static func createTransformAnimation(_ navController: UINavigationController, maskBackgroundImageView: UIImageView) {
        let transformAnimation = CAKeyframeAnimation(keyPath: "bounds")
        transformAnimation.duration = transformAnimationDuration
        transformAnimation.beginTime = CACurrentMediaTime() + transformAnimationDelay
        let initalBounds = NSValue(cgRect: navController.view.layer.mask!.bounds)
        let finalBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: finishAnimationImageWidth, height: finishAnimationImageWidth))
        transformAnimation.values = [initalBounds, finalBounds]
        transformAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)]
        transformAnimation.isRemovedOnCompletion = false
        transformAnimation.fillMode = kCAFillModeForwards
        navController.view.layer.mask!.add(transformAnimation, forKey: "maskAnimation")
        maskBackgroundImageView.layer.add(transformAnimation, forKey: "maskAnimation")
    }
    
    private static func maskBackgroundImageViewAnimation(_ maskBackgroundImageView: UIImageView, navController: UINavigationController) {
        UIView.animate(withDuration: maskBackgroundImageViewAnimationDuration,
            delay: maskBackgroundImageViewAnimationDelay,
            options: .curveEaseIn,
            animations: {
                maskBackgroundImageView.alpha = 0.0
            },
            completion: { finished in
                if finished == true {
                    maskBackgroundImageView.removeFromSuperview()
                    navController.view.layer.mask = nil
                }
        })
    }
    
}
