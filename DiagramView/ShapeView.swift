//
//  ShapeView.swift
//  DiagramView
//
//  Created by Alexander Kozlov on 13/02/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit

public class ShapeView: UIView {
    
    public override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    var shapeLayer: CAShapeLayer {
        return super.layer as! CAShapeLayer
    }
    
    public override func action(for layer: CALayer, forKey event: String) -> CAAction? {
        if layer === shapeLayer && event == "strokeColor" {
            if let backgroundColorAnimation = action(for: layer, forKey: "backgroundColor") as? CABasicAnimation {
                let animation = backgroundColorAnimation.copy() as! CABasicAnimation
                animation.keyPath = "strokeColor"
                animation.fromValue = nil
                animation.toValue = nil
                return animation
            }
            return nil
        } else if layer === shapeLayer && event == "fillColor" {
            if let backgroundColorAnimation = action(for: layer, forKey: "backgroundColor") as? CABasicAnimation {
                let animation = backgroundColorAnimation.copy() as! CABasicAnimation
                animation.keyPath = "fillColor"
                animation.fromValue = nil
                animation.toValue = nil
                return animation
            }
            return nil
        } else {
            return super.action(for: layer, forKey: event)
        }
    }
    
    var path: CGPath? {
        get {
            return shapeLayer.path
        }
        set {
            shapeLayer.path = newValue
        }
    }
    
    var strokeColor: UIColor? {
        get {
            if let strokeColor = shapeLayer.strokeColor {
                return UIColor(cgColor: strokeColor)
            }
            return nil
        }
        set {
            shapeLayer.strokeColor = newValue?.cgColor
        }
    }
    
    var fillColor: UIColor? {
        get {
            if let fillColor = shapeLayer.fillColor {
                return UIColor(cgColor: fillColor)
            }
            return nil
        }
        set {
            shapeLayer.fillColor = newValue?.cgColor
        }
    }
    
    var lineWidth: CGFloat {
        get {
            return shapeLayer.lineWidth
        }
        set {
            shapeLayer.lineWidth = newValue
        }
    }
    
    var lineDashPattern: [NSNumber]? {
        get {
            return shapeLayer.lineDashPattern
        }
        set {
            shapeLayer.lineDashPattern = newValue
        }
    }
}
