//
//  SymbolDataSource.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 09/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit
import DiagramGeometry

public protocol SymbolDataSourceDelegate: class {
    func symbolWillChangeShape(_ dataSource: SymbolDataSource, withIn transition: Transition)
    func symbolWillChangeStrokeColor(_ dataSource: SymbolDataSource, withIn transition: Transition)
    func symbolWillChangeFillColor(_ dataSource: SymbolDataSource, withIn transition: Transition)
}

public protocol SymbolDataSource: DiagramItemDataSource {
    
    weak var delegate: SymbolDataSourceDelegate? { get set }
    
    var shape: Shape { get }
    var fillColor: UIColor { get }
    var strokeColor: UIColor { get }
}
