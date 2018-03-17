//
//  Size.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import CoreGraphics

public struct Size: Equatable {
    
    public var width: Double
    public var height: Double
    
    public init(_ width: Double, _ height: Double) {
        self.width = width
        self.height = height
    }
    
    public init() {
        self.init(0.0, 0.0)
    }
    
    public static func ==(lhs: Size, rhs: Size) -> Bool {
        return lhs.width == rhs.width && lhs.height == rhs.height
    }
    
    public static let zero: Size = Size()
}

public extension CGSize {
    public init(_ size: Size) {
        self.init(width: size.width, height: size.height)
    }
}

public extension Size {
    public init(_ size: CGSize) {
        self.init(Double(size.width), Double(size.height))
    }
}
