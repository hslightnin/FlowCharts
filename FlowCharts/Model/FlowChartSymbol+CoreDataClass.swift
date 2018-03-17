//
//  FlowChartSymbol+CoreDataClass.swift
//  FlowCharts
//
//  Created by alex on 11/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import CoreData
import PresenterKit
import DiagramGeometry
import DiagramView

class FlowChartSymbol: FlowChartManagedObject {
    
    let font: UIFont = UIFont.systemFont(ofSize: 12)
    let textInsets = Vector(2, 2)
    static let normalStrokeColor = UIColor.black
    
    static var focusedStrokeColor: UIColor {
        return UIView.appearance().tintColor
    }
    
    lazy var dataSource: FlowChartSymbolDataSource = {
        return FlowChartSymbolDataSource(symbol: self)
    }()
    
    var location: Point {
        return Point(x, y)
    }
    
    var center: Point {
        return Point(x + width / 2, y + height / 2)
    }
    
    var size: Size {
        return Size(width, height)
    }
    
    var frame: Rect {
        return Rect(x: x, y: y, width: width, height: height)
    }
    
    var text: NSAttributedString? {
        
        guard let plainText = string else {
            return nil
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.allowsDefaultTighteningForTruncation = false
        
        return NSAttributedString(string: plainText, attributes: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName : font
        ])
    }
    
    var lineWidth: Double = 1.0 {
        didSet {
            dataSource.updateShape(withIn: .instant())
        }
    }
    
    var shape: Shape {
        return Shape(
            bounds: frame,
            type: shapePreset.shapeType,
            lineWidth: lineWidth,
            text: text,
            textInsets: textInsets
        )
    }
    
    var shapePreset: ShapePreset {
        get {
            return ShapePreset.preset(withId: Int(shapePresetId))
        }
        set {
            shapePresetId = Int32(ShapePreset.id(forPreset: newValue))
        }
    }
    
    var topAnchor: FlowChartSymbolAnchor {
        return anchor(withDirection: .up)
    }
    
    var bottomAnchor: FlowChartSymbolAnchor {
        return anchor(withDirection: .down)
    }
    
    var rightAnchor: FlowChartSymbolAnchor {
        return anchor(withDirection: .right)
    }
    
    var leftAnchor: FlowChartSymbolAnchor {
        return anchor(withDirection: .left)
    }
    
    func anchor(withDirection direction: Direction) -> FlowChartSymbolAnchor {
        return anchors.first { $0.direction == direction }!
    }
    
    func noteObjectDidChange(withIn transition: Transition) {
        
        let changedKeys = changedValuesForCurrentEvent().keys
        
        if changedKeys.contains("x") ||
            changedKeys.contains("y") ||
            changedKeys.contains("width") ||
            changedKeys.contains("height") ||
            changedKeys.contains("shapePresetId") ||
            changedKeys.contains("string") {
            
            dataSource.updateShape(withIn: transition)
        }
        
        if changedKeys.contains("color") {
            dataSource.updateFillColor(withIn: transition)
        }
    }
    
    func noteObjectInserted(withIn transition: Transition) {
        dataSource.updateShape(withIn: transition)
        dataSource.updateFillColor(withIn: transition)
    }
}
