//
//  PopAnimator.swift
//  BeginnerCook
//
//  Created by cm on 16/3/9.
//  Copyright © 2016年 Razeware LLC. All rights reserved.
//

import UIKit

class PopAnimator: NSObject,UIViewControllerAnimatedTransitioning {
    let duration = 1.0
    var presenting = true
    var originFrame = CGRect.zero
    var dismissCompletion: (()->())?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
            return duration
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        let containerView = transitionContext.containerView()
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        //fade效果
//        containerView?.addSubview(toView)
//        toView.alpha = 0.0
//        
//        UIView.animateWithDuration(duration, animations: {
//            toView.alpha = 1.0
//            }, completion:{_ in
//            transitionContext.completeTransition(true)
//        })
        
        //pop
        let herView = presenting ? toView :transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        let initialFrame = presenting ? originFrame : herView?.frame
        let finalFrame = presenting ? herView?.frame : originFrame
        
        let xScaleFactor = presenting ? initialFrame!.width / finalFrame!.width : finalFrame!.width / initialFrame!.width
        let yScaleFactor = presenting ? initialFrame!.height / finalFrame!.height : finalFrame!.height / initialFrame!.height
        
        let scalTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
        if presenting {
            herView?.transform = scalTransform
            herView!.center = CGPoint(x: CGRectGetMidX(initialFrame!), y: CGRectGetMidY(initialFrame!))
            herView?.clipsToBounds = true
        }
        
        containerView?.addSubview(toView)
        containerView?.bringSubviewToFront(herView!)
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [], animations: {
            herView?.transform = self.presenting ?
                CGAffineTransformIdentity : scalTransform
            herView?.center = CGPoint(x: CGRectGetMidX(finalFrame!), y: CGRectGetMidY(finalFrame!))
            }, completion: {_ in
                transitionContext.completeTransition(true)
                if !self.presenting {
                    self.dismissCompletion?()
                }
        })
        
    }
    
    
}
