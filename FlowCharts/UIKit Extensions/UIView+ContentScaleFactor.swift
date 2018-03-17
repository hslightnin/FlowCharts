//
//  UIView+ContentScaleFactor.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 13/02/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit

extension UIView {
    
    func setContentScaleFactorHierarchically(_ contentScaleFactor: CGFloat) {
        setContentScaleFactor(contentScaleFactor, hierarchicallyForView: self)
    }
    
    private func setContentScaleFactor(_ contentScaleFactor: CGFloat, hierarchicallyForView view: UIView) {
        view.contentScaleFactor = contentScaleFactor
        view.layer.contentsScale = contentScaleFactor
        for subview in view.subviews {
            setContentScaleFactor(contentScaleFactor, hierarchicallyForView: subview)
        }
    }
}
