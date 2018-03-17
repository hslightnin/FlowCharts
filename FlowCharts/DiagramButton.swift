//
//  FlowChartButton.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 03/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit

class DiagramButton: UIButton {
    
    static let defaultSize = CGSize(width: 32, height: 32)
    
    init() {
        super.init(frame: CGRect(origin: .zero, size: DiagramButton.defaultSize))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(icon: DiagramButtonIcon? = nil, background: DiagramButtonBackground? = nil) {
        self.init()
        self.icon = icon
        self.background = background
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var icon: DiagramButtonIcon? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var background: DiagramButtonBackground? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            super.isHighlighted = newValue
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()!
        
        if let background = self.background {
            background.draw(in: context, with: bounds, isHighlighted: isHighlighted)
        }
        
        if let icon = self.icon {
            icon.draw(in: context, with: bounds)
        }
    }
}
