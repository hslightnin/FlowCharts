//
//  SymbolView.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 18/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import CoreGraphics
import DiagramGeometry

public class SymbolView: ShapeView {
    
    private let textLayer = ShapeTextLayer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        textLayer.actions = [
            "bounds": NSNull(),
            "position": NSNull()
        ]
        
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.addSublayer(textLayer)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var contentScaleFactor: CGFloat {
        get {
            return super.contentScaleFactor
        }
        set {
            super.contentScaleFactor = newValue
            textLayer.contentsScale = newValue
        }
    }
    
    var textPath: CGPath? {
        didSet {
            textLayer.textPath = textPath
        }
    }
    
    var text: NSAttributedString? {
        didSet {
            textLayer.text = text
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        textLayer.frame = layer.bounds
    }
}
