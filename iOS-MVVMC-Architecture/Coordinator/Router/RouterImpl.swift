//
//  RouterImpl.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/10.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

final class RouterImpl: Router {
    
    private weak var rootController: UINavigationController?
    private var completions: [UIViewController: () -> Void]
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
        self.completions = [:]
    }
    
    func toPresent() -> UIViewController? {
        return rootController
    }
    
    func present(presentable: Presentable?, animated: Bool = true) {
        guard let controller = presentable?.toPresent() else {
            return
        }
        rootController?.present(controller, animated: animated, completion: nil)
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        rootController?.dismiss(animated: animated, completion: completion)
    }
    
    func push(presentable: Presentable?, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let controller = presentable?.toPresent(), (controller as? UINavigationController) == nil else {
            return
        }
        
        if let completion = completion {
            completions[controller] = completion
        }
        rootController?.pushViewController(controller, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        guard let controller = rootController?.popViewController(animated: animated) else {
            return
        }
        runCompletion(controller: controller)
    }
    
    func setRoot(presentable: Presentable?, hideBar: Bool = false) {
        guard let controller = presentable?.toPresent() else {
            return
        }
        rootController?.setViewControllers([controller], animated: false)
        rootController?.isNavigationBarHidden = hideBar
    }
    
    func popToRoot(animated: Bool) {
        guard let controllers = rootController?.popToRootViewController(animated: animated) else {
            return
        }
        controllers.forEach { runCompletion(controller: $0) }
    }
    
    private func runCompletion(controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
    
}
