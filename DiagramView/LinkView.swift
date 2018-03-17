//
//  LinkView.swift
//  FlowCharts
//
//  Created by alex on 11/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry

public class LinkView: ShapeView {
    
    private let label: UILabel
    
    var touchDistance = CGFloat(20)

    override init(frame: CGRect) {
        label = UILabel(frame: .zero)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = Int.max
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        strokeColor = UIColor.black
        fillColor = UIColor.clear
        shapeLayer.lineCap = kCALineCapRound
        addSubview(label)
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
            label.contentScaleFactor = newValue
        }
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        guard let path = shapeLayer.path else {
            return false
        }
        
        if textFrame.contains(point) {
            return true
        }
        
        let touchPath = path.copy(
            strokingWithWidth: 2 * touchDistance,
            lineCap: .round,
            lineJoin: .miter,
            miterLimit: 0)
        
        return touchPath.contains(point)
    }
    
    var text: NSAttributedString? {
        get {
            return label.attributedText
        }
        set {
            label.attributedText = newValue
        }
    }
    
    var textFrame: CGRect {
        get {
            return label.frame
        }
        set {
            label.frame = newValue
        }
    }
}
