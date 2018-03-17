//
//  Polynom.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

// c3 * x^3 + c2 * x^2 + c1 * x + c0 = 0
public struct Polynom {
    
    public let c3: Double
    public let c2: Double
    public let c1: Double
    public let c0: Double
    
    public init(_ c3: Double, _ c2: Double, _ c1: Double, _ c0: Double) {
        self.c3 = c3
        self.c2 = c2
        self.c1 = c1
        self.c0 = c0
    }
    
    public init(_ c2: Double, _ c1: Double, _ c0: Double) {
        self.init(0.0, c2, c1, c0);
    }
    
    public var roots: [Double] {
        if c3 != 0.0 {
            return cubicRoots
        } else if c2 != 0.0 {
            return quadraticRoots
        } else if c1 != 0.0 {
            return [-c0 / c1]
        } else {
            return []
        }
    }
    
    private var cubicRoots: [Double] {
        
        // Vieta formula
        
        let a = c2 / c3
        let b = c1 / c3
        let c = c0 / c3
        
        let Q = (a * a - 3.0 * b) / 9.0
        let R = (2.0 * a * a * a - 9.0 * a * b + 27.0 * c) / 54.0
        
        let R2 = pow(R, 2.0)
        let Q3 = pow(Q, 3.0)
        
        if R2 < Q3 {
            let t = acos(R / sqrt(Q3)) / 3.0
            let r0 = -2.0 * sqrt(Q) * cos(t) - a / 3.0
            let r1 = -2.0 * sqrt(Q) * cos(t + 2.0 * .pi / 3.0) - a / 3.0
            let r2 = -2.0 * sqrt(Q) * cos(t - 2.0 * .pi / 3.0) - a / 3.0
            return [r0, r1, r2]
        } else {
            let A = (R >= 0.0 ? -1.0 : 1.0) * pow(fabs(R) + sqrt(R2 - Q3), 1.0 / 3.0)
            let B = (A == 0.0) ? 0.0 : Q / A
            let r0 = (A + B) - a / 3.0
            if fabs(A - B) > 0.001 {
                return [r0]
            } else {
                let r1 = -A - a / 3.0
                return [r0, r1]
            }
        }
    }
    
    private var quadraticRoots: [Double] {
        
        let a = c2
        let b = c1
        let c = c0
        
        let D = b * b - 4.0 * a * c
        
        if fabs(D) < 0.001 {
            let r0 = -b / (2.0 * a)
            return [r0]
        } else if D < 0 {
            return []
        } else {
            let r0 = (-b + sqrt(D)) / (2.0 * a)
            let r1 = (-b - sqrt(D)) / (2.0 * a)
            return [r0, r1]
        }
    }
}
