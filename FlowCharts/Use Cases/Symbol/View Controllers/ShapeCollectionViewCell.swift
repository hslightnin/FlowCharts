//
//  SymbolCollectionViewCell.swift
//  FlowCharts
//
//  Created by alex on 02/07/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry

class ShapeCollectionViewCell: UICollectionViewCell {
    
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
        
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = 5
        layer.addSublayer(shapeLayer)
    }
    
    var shapePreset: ShapePreset = .rect {
        didSet {
            let viewBounds = Rect(bounds.insetBy(dx: 6, dy: 6))
            let size = shapePreset.preferredSize(withConstraints: viewBounds.size)
            let pathBounds = Rect(center: viewBounds.center, size: size)
            let path = shapePreset.shapeType.path(within: pathBounds)
            shapeLayer.path = CGPath(path)
        }
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
            } else {
                layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
}
