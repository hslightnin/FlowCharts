//
//  Link.swift
//  FlowCharts
//
//  Created by alex on 04/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit
import DiagramGeometry

public protocol LinkDataSourceDelegate: class {
    
    func linkWillChangeArrow(_ dataSource: LinkDataSource, withIn transition: Transition)
    
    func linkWillChangeStrokeColor(_ dataSource: LinkDataSource, withIn transition: Transition)
    func linkWillChangeOriginFillColor(_ dataSource: LinkDataSource, withIn transition: Transition)
    func linkWillChangeEndingFillColor(_ dataSource: LinkDataSource, withIn transition: Transition)
    
    func linkWillChangeLineDashPattern(_ dataSource: LinkDataSource, withIn transition: Transition)
    func linkWillChangeOriginDashPattern(_ dataSource: LinkDataSource, withIn transition: Transition)
    func linkWillChangeEndingDashPattern(_ dataSource: LinkDataSource, withIn transition: Transition)
}

public protocol LinkDataSource: DiagramItemDataSource {
    
    weak var delegate: LinkDataSourceDelegate? { get set }
    
    var arrow: Arrow { get }
    
    var strokeColor: UIColor { get }
    var originFillColor: UIColor { get }
    var endingFillColor: UIColor { get }
    
    var lineDashPattern: [Double] { get }
    var originDashPattern: [Double] { get }
    var endingDashPattern: [Double] { get }
}
