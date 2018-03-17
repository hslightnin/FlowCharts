//
//  BuildLinkDirectionZonesPresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 04/12/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import PresenterKit

class BuildLinkDirectionZonesPresenter: FreePresenter {
    
    let presentingView: UIView
    let highlightedPath: CGPath
    
    init(presentingView: UIView, highlightedPath: CGPath) {
        self.presentingView = presentingView
        self.highlightedPath = highlightedPath
    }
    
    // MARK: - Properties
    
    private var highlightedZonesColor: UIColor {
        return UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 0.1)
    }
    
    private var notHighlightedZonesColor: UIColor {
        return UIColor.clear
    }
    
    // MARK: - Presenter items
    
    private lazy var directionZonesLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.strokeColor = self.notHighlightedZonesColor.cgColor
        layer.path = self.highlightedPath
        return layer
    }()
    
    // MARK: - Lifecycle
    
    override func setUpPresentation(withIn transition: Transition) {
        super.setUpPresentation(withIn: transition)
        
        directionZonesLayer.frame = presentingView.layer.bounds
        presentingView.layer.insertSublayer(directionZonesLayer, at: 0)
        
        directionZonesLayer.fillColor = highlightedZonesColor.cgColor
        transition.addLayerAnimation(
            layer: directionZonesLayer,
            keyPath: "fillColor",
            from: notHighlightedZonesColor.cgColor,
            to: highlightedZonesColor.cgColor)
    }
    
    override func setUpDismission(withIn transition: Transition) {
        super.setUpDismission(withIn: transition)
        
        transition.addLayerAnimation(
            layer: directionZonesLayer,
            keyPath: "fillColor",
            from: highlightedZonesColor.cgColor,
            to: notHighlightedZonesColor.cgColor)
        
        transition.add(completion: {
            self.directionZonesLayer.removeFromSuperlayer()
        })
        
        directionZonesLayer.fillColor = notHighlightedZonesColor.cgColor
    }
}
