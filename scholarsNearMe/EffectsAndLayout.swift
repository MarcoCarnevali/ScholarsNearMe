//
//  EffectsAndLayout.swift
//  scholarsNearMe
//
//  Created by Niklas Balazs on 09/05/16.
//  Copyright © 2016 Niklas Balazs. All rights reserved.
//

import UIKit

func fadeInView(view: UIView, duration: NSTimeInterval, delay: NSTimeInterval) {
    UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: {
        view.alpha = 1.0
        }, completion: nil)
}

func fadeOutView(view: UIView, duration: NSTimeInterval, delay: NSTimeInterval) {
    UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: {
        view.alpha = 0.0
        }, completion: nil)
}

func scaleView(view: UIView, scaleX: CGFloat, scaleY: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval) {
    UIView.animateWithDuration(duration, delay: delay, options: .CurveEaseOut, animations: {
        view.transform = CGAffineTransformMakeScale(scaleX, scaleY)
        view.alpha = 0.0
        }, completion: { (b: Bool) in
            view.removeFromSuperview()
    })
}

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
}
