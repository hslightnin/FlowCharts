//
//  DeleteUIProtocol.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit

protocol DeleteUILayoutDelegate: class {
    func buttonLocation(in view: UIView) -> CGPoint
}

protocol DeleteUIProtocol: class {
    
    var onButtonPressed: (() -> Void)? { get set }
    
    func prepareForButtonPresentation(withIn transition: Transition)
    func prepareForButtonDismission(withIn transition: Transition)
    
    weak var layoutDelegate: DeleteUILayoutDelegate! { get set }
    func layout()
}
