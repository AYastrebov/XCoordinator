//
//  UINavigationController+Transition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 27.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func push(_ viewController: UIViewController,
              with options: TransitionOptions,
              animation: Animation?,
              completion: PresentationHandler?) {

        if let animation = animation {
            viewController.transitioningDelegate = animation
        }
        assert(animation == nil || animationDelegate != nil, """
        Animations do not work, if the navigation controller's delegate is not a NavigationAnimationDelegate.
        This assertion might fail, if the rootViewController specified in the NavigationCoordinator's
        initializer already had a delegate when initializing the NavigationCoordinator.
        To set another delegate of a rootViewController in a NavigationCoordinator, have a look at `NavigationCoordinator.delegate`.
        """)

        CATransaction.perform(completion: completion) {
            pushViewController(viewController, animated: options.animated)
        }
    }

    func pop(toRoot: Bool, with options: TransitionOptions, animation: Animation?, completion: PresentationHandler?) {

        if let animation = animation {
            topViewController?.transitioningDelegate = animation
        }
        assert(animation == nil || animationDelegate != nil, """
        Animations do not work, if the navigation controller's delegate is not a NavigationAnimationDelegate.
        This assertion might fail, if the rootViewController specified in the NavigationCoordinator's
        initializer already had a delegate when initializing the NavigationCoordinator.
        To set another delegate of a rootViewController in a NavigationCoordinator, have a look at `NavigationCoordinator.delegate`.
        """)

        CATransaction.perform(completion: completion) {
            if toRoot {
                popToRootViewController(animated: options.animated)
            } else {
                popViewController(animated: options.animated)
            }
        }
    }

    func set(_ viewControllers: [UIViewController],
             with options: TransitionOptions,
             animation: Animation?,
             completion: PresentationHandler?) {

        if let animation = animation {
            viewControllers.last?.transitioningDelegate = animation
        }
        assert(animation == nil || animationDelegate != nil, """
        Animations do not work, if the navigation controller's delegate is not a NavigationAnimationDelegate.
        This assertion might fail, if the rootViewController specified in the NavigationCoordinator's
        initializer already had a delegate when initializing the NavigationCoordinator.
        To set another delegate of a rootViewController in a NavigationCoordinator, have a look at `NavigationCoordinator.delegate`.
        """)

        CATransaction.perform(completion: {
            if let animation = animation {
                viewControllers.forEach { $0.transitioningDelegate = animation }
            }
            completion?()
        }) { setViewControllers(viewControllers, animated: options.animated) }
    }

    func pop(to viewController: UIViewController,
             options: TransitionOptions,
             animation: Animation?,
             completion: PresentationHandler?) {

        if let animation = animation {
            topViewController?.transitioningDelegate = animation
            viewController.transitioningDelegate = animation
        }

        assert(animation == nil || animationDelegate != nil, """
        Animations do not work, if the navigation controller's delegate is not a NavigationAnimationDelegate.
        This assertion might fail, if the rootViewController specified in the NavigationCoordinator's
        initializer already had a delegate when initializing the NavigationCoordinator.
        To set another delegate of a rootViewController in a NavigationCoordinator, have a look at `NavigationCoordinator.delegate`.
        """)

        CATransaction.perform(completion: completion) {
            popToViewController(viewController, animated: options.animated)
        }
    }
    
}
