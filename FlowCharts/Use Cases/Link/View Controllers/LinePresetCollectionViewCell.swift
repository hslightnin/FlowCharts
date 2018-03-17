//
//  LinePresetCollectionViewCell.swift
//  FlowCharts
//
//  Created by alex on 08/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry

class LinePresetCollectionViewCell: UICollectionViewCell {
    
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
        
        shapeLayer.actions = [
            "strokeColor": NSNull()
        ]
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = 5
        layer.addSublayer(shapeLayer)
    }
    
    var lineType: LineType = StraightLineType() {
        didSet {
            updateLine()
        }
    }
    
    var lineDashPattern = [Double]() {
        didSet {
            updateLine()
        }
    }
    
    private func updateLine() {
        let viewBounds = Rect(bounds.insetBy(dx: 6, dy: 12))
        let origin = Point(viewBounds.minX, viewBounds.minY)
        let ending = Point(viewBounds.maxX, viewBounds.maxY)
        let path = lineType.path(point1: origin, direction1: .left, point2: ending, direction2: .right)
        shapeLayer.lineDashPattern = lineDashPattern.map { NSNumber(value: $0) }
        shapeLayer.path = CGPath(path)
    }
    
    var shapeColor: UIColor = .white {
        didSet {
            shapeLayer.fillColor = shapeColor.cgColor
        }
    }
    
    override var isSelected: Bool {
        
        get {
            return super.isSelected
        }
        
        set {
            super.isSelected = newValue
            
            if isSelected {
                layer.borderColor = tintColor.cgColor
                shapeLayer.strokeColor = tintColor.cgColor
            } else {
                layer.borderColor = UIColor.clear.cgColor
                shapeLayer.strokeColor = UIColor.systemGray.cgColor
            }
        }
    }
}
