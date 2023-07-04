//
//  NicePresentAnimationController.swift
//

import UIKit

class NicePresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView

        let initialFrame = originFrame
        let finalFrame = toView.frame

        let xScaleFactor = initialFrame.width / finalFrame.width

        let yScaleFactor = initialFrame.height / finalFrame.height

        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

        toView.transform = scaleTransform
        toView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
        toView.clipsToBounds = true
        toView.layer.masksToBounds = true

        containerView.addSubview(toView)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.2,
            animations: {
                toView.transform = .identity
                toView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            },
            completion: { _ in
                transitionContext.completeTransition(true)
            })
    }

    var originFrame: CGRect = .zero
}
