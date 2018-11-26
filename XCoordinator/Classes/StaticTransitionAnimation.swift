//
//  StaticTransitionAnimation.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

open class StaticTransitionAnimation: NSObject, TransitionAnimation {

    // MARK: - Stored properties

    internal let duration: TimeInterval
    public let performAnimation: (_ transitionContext: UIViewControllerContextTransitioning) -> Void

    // MARK: - Computed properties

    public var interactionController: UIViewControllerInteractiveTransitioning? {
        return self as? UIViewControllerInteractiveTransitioning
    }

    public var percentDrivenTransition: UIPercentDrivenInteractiveTransition? {
        return nil
    }

    // MARK: - Init

    public init(duration: TimeInterval, performAnimation: @escaping (UIViewControllerContextTransitioning) -> Void) {
        self.duration = duration
        self.performAnimation = performAnimation
    }

    // MARK: - Methods

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        performAnimation(transitionContext)
    }
}

