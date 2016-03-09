//
//  RevealAnimator.swift
//  LogoReveal
//
//  Created by cm on 16/3/9.
//  Copyright © 2016年 Razeware LLC. All rights reserved.
//

import UIKit

class RevealAnimator: UIPercentDrivenInteractiveTransition,UIViewControllerAnimatedTransitioning {
    let animationDuration = 2.0
    var operation : UINavigationControllerOperation = .Push
    weak var storedContext: UIViewControllerContextTransitioning?
    var interactive = false

    func handlePan(recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translationInView( recognizer.view!.superview!)
        var progress: CGFloat = abs(translation.x / 200.0)
        progress = min(max(progress, 0.01), 0.99)
        
        switch recognizer.state {
        case .Changed:
            updateInteractiveTransition(progress)
        case .Cancelled, .Ended:
            let transitionLayer = storedContext!.containerView()!.layer
        transitionLayer.beginTime = CACurrentMediaTime()
        if progress < 0.5 {
            completionSpeed = -1.0
            cancelInteractiveTransition()
        } else {
            completionSpeed = 1.0
            finishInteractiveTransition()
            }
        default:
            break
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return animationDuration
    }
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        if operation == .Push {
        storedContext = transitionContext
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MasterViewController
        
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! DetailViewController
        
        transitionContext.containerView()?.addSubview(toVC.view)
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(CATransform3D:CATransform3DIdentity)
        animation.toValue = NSValue(CATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(0.0, -10.0, 0.0), CATransform3DMakeScale(150.0, 150.0, 1.0)))
        animation.duration = animationDuration
        animation.delegate = self
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        toVC.maskLayer.addAnimation(animation, forKey: nil)
        fromVC.logo.addAnimation(animation, forKey: nil)
        }
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let context = storedContext {
            context.completeTransition(!context.transitionWasCancelled())
            
            let fromVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MasterViewController
            fromVC.logo.removeAllAnimations()
        }
        storedContext = nil
    }

}
