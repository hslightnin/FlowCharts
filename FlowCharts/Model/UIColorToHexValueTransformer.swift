//
//  UIColorToHexValueTransformer.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 29/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit

class UIColorToHexValueTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> Swift.AnyClass {
        return UIColor.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        if let hex = value as? String {
            var rgb: UInt64 = 0
            Scanner(string: hex).scanHexInt64(&rgb)
            let r = CGFloat((rgb >> 16) & 0xFF) / CGFloat(255.0)
            let g = CGFloat((rgb >> 8) & 0xFF) / CGFloat(255.0)
            let b = CGFloat((rgb >> 0) & 0xFF) / CGFloat(255.0)
            return UIColor(red: r, green: g, blue: b, alpha: 1)
        }
        return nil
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        if let color = value as? UIColor {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            color.getRed(&r, green: &g, blue: &b, alpha: &a)
            return String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
        return nil
    }
}
