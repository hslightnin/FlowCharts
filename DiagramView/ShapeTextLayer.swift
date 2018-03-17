//
//  SymbolLayer.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 10/12/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit

class ShapeTextLayer: CALayer {
    
    var textPath: CGPath? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var text: NSAttributedString? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var contentsScale: CGFloat {
        get {
            return super.contentsScale
        }
        set {
            super.contentsScale = newValue
            setNeedsDisplay()
        }
    }
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        if text != nil && textPath != nil {
            
//            ctx.saveGState()
//            ctx.setFillColor(UIColor.red.cgColor)
//            ctx.addPath(textPath!)
//            ctx.fillPath()
//            ctx.restoreGState()

            ctx.saveGState()
            
            ctx.addPath(textPath!)
            ctx.translateBy(x: 0.0, y: self.bounds.height) //  + 2 * d
            ctx.scaleBy(x: 1.0, y: -1.0)
            
            let framesetter = CTFramesetterCreateWithAttributedString(text!)
            let textRange = CFRange(location: 0, length: text!.length)
            let frame = CTFramesetterCreateFrame(framesetter, textRange, ctx.path!, nil)
            CTFrameDraw(frame, ctx)
            
            ctx.restoreGState()
        }
    }
}
