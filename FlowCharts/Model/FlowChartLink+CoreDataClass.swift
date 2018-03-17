//
//  FlowChartLink+CoreDataClass.swift
//  FlowCharts
//
//  Created by alex on 04/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import CoreData
import PresenterKit
import DiagramGeometry
import DiagramView

enum LinkPointerFillPattern {
    case none
    case fillWithStrokeColor
    case fillWithBackgroundColor
}

class FlowChartLink: FlowChartManagedObject {

    // MARK: - Constants
    
    let maxTextWidth = 200.0
    let font = UIFont.systemFont(ofSize: 12)
    
    static let normalStrokeColor = UIColor.black
    
    static var focusedStrokeColor: UIColor {
        return UIView.appearance().tintColor
    }
    
    // MARK: - Presets
    
    var lineTypePreset: LineTypePreset {
        get {
            return LineTypePreset.preset(withId: Int(lineTypePresetId))
        }
        set {
            lineTypePresetId = Int32(LineTypePreset.id(forPreset: newValue))
        }
    }
    
    var lineDashPatternPreset: LineDashPatternPreset {
        get {
            return LineDashPatternPreset.preset(withId: Int(lineDashPatternPresetId))
        }
        set {
            lineDashPatternPresetId = Int32(LineDashPatternPreset.id(forPreset: newValue))
        }
    }
    
    // MARK: - Data source
    
    lazy var dataSource: FlowChartLinkDataSource = {
        return FlowChartLinkDataSource(link: self)
    }()
    
    // MARK: - Arrow
    
    var arrow: Arrow {
        
        let arrow = Arrow()
        
        arrow.lineType = lineTypePreset.lineType
        if let text = self.text {
            arrow.text = NSAttributedString(
                string: text,
                attributes: [NSFontAttributeName : font]
            )
        }
        
        arrow.maxTextWidth = maxTextWidth
        
        arrow.point1 = origin.location
        arrow.direction1 = origin.direction
        arrow.pointer1Type = origin.pointerPreset.pointerType
        arrow.pointer1Size = origin.pointerPreset.pointerSize
        if origin.pointerPreset === PointerPreset.thinArrow {
            arrow.minPointer1TailLength = origin.pointerPreset.pointerSize.width
        }
        
        arrow.point2 = ending.location
        arrow.direction2 = ending.direction
        arrow.pointer2Type = ending.pointerPreset.pointerType
        arrow.pointer2Size = ending.pointerPreset.pointerSize
        if ending.pointerPreset === PointerPreset.thinArrow {
            arrow.minPointer2TailLength = ending.pointerPreset.pointerSize.width
        }
        
        return arrow
    }
    
    // MARK: - Dash patterns
    
    var lineDashPattern: [Double] {
        return lineDashPatternPreset.pattern
    }
    
    var originDashPattern: [Double] {
        if lineDashPatternPreset === LineDashPatternPreset.small &&
            origin.pointerPreset === PointerPreset.thinArrow {
            return LineDashPatternPreset.small.pattern
        } else {
            return LineDashPatternPreset.solid.pattern
        }
    }
    
    var endingDashPattern: [Double] {
        if lineDashPatternPreset === LineDashPatternPreset.small &&
            ending.pointerPreset === PointerPreset.thinArrow {
            return LineDashPatternPreset.small.pattern
        } else {
            return LineDashPatternPreset.solid.pattern
        }
    }
    
    // MARK: - Update
    
    func noteObjectDidChange(withIn transition: Transition) {
        
        let changedKeys = changedValuesForCurrentEvent().keys
        let originChangedKeys = origin!.changedValuesForCurrentEvent().keys
        let endingChangedKeys = ending!.changedValuesForCurrentEvent().keys
        
        if changedKeys.contains("lineTypePresetId") ||
            changedKeys.contains("text") ||
            changedKeys.contains("origin") ||
            changedKeys.contains("ending") ||
            originChangedKeys.contains("x") ||
            originChangedKeys.contains("y") ||
            originChangedKeys.contains("pointerPresetId") ||
            endingChangedKeys.contains("x") ||
            endingChangedKeys.contains("y") ||
            endingChangedKeys.contains("pointerPresetId") {
            
            dataSource.updateArrow(withIn: transition)
        }
        
        if changedKeys.contains("lineTypePresetId") ||
            changedKeys.contains("lineDashPatternPresetId") {
            
            dataSource.updateLineDashPattern(withIn: transition)
            dataSource.updateOriginDashPattern(withIn: transition)
            dataSource.updateEndingDashPattern(withIn: transition)
        }
        
        if originChangedKeys.contains("pointerPresetId") {
            dataSource.updateOriginFillPattern(withIn: transition)
        }
        
        if endingChangedKeys.contains("pointerPresetId") {
            dataSource.updateEndingFillPattern(withIn: transition)
        }
    }
}
