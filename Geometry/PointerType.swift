//
//  PointerType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 13/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public protocol PointerType {
    func path(withLocation location: Point, direction: Vector, size: Size) -> BezierPath
    func tail(withLocation location: Point, direction: Vector, size: Size) -> Point
    func head(withLocation location: Point, direction: Vector, size: Size) -> Point
}
