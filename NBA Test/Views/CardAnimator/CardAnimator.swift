//
//  CardAnimator.swift
//  NBA Test
//
//  Created by Marco Falanga on 18/02/21.
//

import UIKit

/// Handles the custom transition when presenting a card in the sytle of a popup.
///
/// The presented view is animated from the bottom.
/// The animator adds a visual effect view below the presented view in order to add a blur effect (animated).
final class CardAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    enum TransitionMode: Int {
        case present, dismiss
    }
    
    private var blurView: UIVisualEffectView
    
    private var transitionMode: TransitionMode
    private let duration: Double
    
    init(mode: TransitionMode, duration: Double) {
        self.transitionMode = mode
        self.duration = duration
        
        blurView = UIVisualEffectView()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        self.blurView.frame = transitionContext.containerView.frame
        
        switch transitionMode {
        case .dismiss:
            if let returningView = transitionContext.view(forKey: UITransitionContextViewKey.from) {
                
                UIView.animate(withDuration: duration, animations: {
                    self.blurView.effect = nil
                    returningView.transform = .init(translationX: 0, y: containerView.frame.height)
                    returningView.alpha = 0
                }, completion: { success in
                    self.blurView.removeFromSuperview()
                    transitionContext.completeTransition(success)
                })
            }
        case .present:
            if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                self.blurView.effect = nil
                containerView.addSubview(self.blurView)
                blurView.translatesAutoresizingMaskIntoConstraints = false
                blurView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
                blurView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
                blurView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
                blurView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
                
                presentedView.center = containerView.center
                presentedView.transform = .init(translationX: 0, y: transitionContext.containerView.frame.height)
                presentedView.alpha = 0
                containerView.addSubview(presentedView)
                
                UIView.animate(withDuration: duration, animations: {
                    self.blurView.effect = UIBlurEffect(style: .systemThinMaterialDark)
                    presentedView.alpha = 1
                    presentedView.transform = .identity
                }, completion: { success in
                    transitionContext.completeTransition(success)
                })
            }
        }
    }
}
