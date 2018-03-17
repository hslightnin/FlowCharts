//
//  TransitionCurve.swift
//  PresenterKit
//
//  Created by Alexander Kozlov on 22/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit

public enum TransitionCurve {
    
    case easeInOut
    case easeIn
    case easeOut
    case linear
    
    init(viewAnimationCurve: UIViewAnimationCurve) {
        switch viewAnimationCurve {
        case .easeIn:
            self = .easeIn
        case .easeOut:
            self = .easeIn
        case .easeInOut:
            self = .easeIn
        case .linear:
            self = .linear
        }
    }
    
    var viewAnimationOption: UIViewAnimationOptions {
        switch self {
        case .easeInOut:
            return .curveEaseInOut
        case .easeIn:
            return .curveEaseIn
        case .easeOut:
            return .curveEaseOut
        case .linear:
            return .curveLinear
        }
    }
    
    var layerTiminingFunction: CAMediaTimingFunction {
        switch self {
        case .easeInOut:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        case .easeIn:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        case .easeOut:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        case .linear:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        }
    }
}
