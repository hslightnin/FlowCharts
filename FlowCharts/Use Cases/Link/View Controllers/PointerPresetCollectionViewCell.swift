//
//  PointerPresetCollectionViewCell.swift
//  FlowCharts
//
//  Created by alex on 14/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry

class PointerPresetCollectionViewCell: UICollectionViewCell {
    
    let shapeLayer: CAShapeLayer
    
    override init(frame: CGRect) {
        shapeLayer = CAShapeLayer()
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        shapeLayer = CAShapeLayer()
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        shapeLayer.strokeColor = UIColor.systemGray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        
        shapeLayer.borderWidth = 1
        shapeLayer.borderColor = UIColor.clear.cgColor
        shapeLayer.cornerRadius = 5
        
        shapeLayer.actions = [
            "fillColor": NSNull(),
            "strokeColor": NSNull(),
            "borderColor": NSNull()
        ]
        
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = layer.bounds
    }
    
    var pointerPreset: PointerPreset = .empty {
        didSet {
            update()
        }
    }
    
    var pointerDirection = Vector(1, 0) {
        didSet {
            update()
        }
    }
    
    private func update() {
        
        shapeLayer.frame = layer.bounds
        
        let headOffset = pointerPreset.pointerType.head(
            withLocation: .zero,
            direction: pointerDirection.unit,
            size: pointerPreset.thumbnailPointerSize)
        
        let arrowCenter = Point(Double(bounds.midX), Double(bounds.midY))
        let arrowWidth = Double(bounds.width - 20)
        
        let arrow = Arrow()
        
        arrow.lineType = StraightLineType()
        
        arrow.point1 = arrowCenter.translated(by: -(arrowWidth / 2) * pointerDirection.unit)
        arrow.direction1 = .left
        arrow.pointer1Type = EmptyPointerType()
        
        arrow.point2 = arrowCenter.translated(by: +(arrowWidth / 2) * pointerDirection.unit) - headOffset
        arrow.direction2 = .right
        arrow.pointer2Type = pointerPreset.pointerType
        arrow.pointer2Size = pointerPreset.thumbnailPointerSize
        
        shapeLayer.path = CGPath(arrow.path)
        
        switch pointerPreset.pointerFillPattern {
        case .fillWithBackgroundColor:
            shapeLayer.fillColor = UIColor.white.cgColor
        case .fillWithStrokeColor:
            shapeLayer.fillColor = UIColor.systemGray.cgColor
        case .none:
            shapeLayer.fillColor = nil
        }
    }
    
    override var isSelected: Bool {
        
        get {
            return super.isSelected
        }
        
        set {
            super.isSelected = newValue
            
            setNeedsDisplay()
            
            if isSelected {
                shapeLayer.borderColor = tintColor.cgColor
                shapeLayer.strokeColor = tintColor.cgColor
                if pointerPreset.pointerFillPattern == .fillWithStrokeColor {
                    shapeLayer.fillColor = tintColor.cgColor
                }
            } else {
                shapeLayer.borderColor = UIColor.clear.cgColor
                shapeLayer.strokeColor = UIColor.systemGray.cgColor
                if pointerPreset.pointerFillPattern == .fillWithStrokeColor {
                    shapeLayer.fillColor = UIColor.systemGray.cgColor
                }
            }
        }
    }
}
