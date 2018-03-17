//
//  TestError.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 01/02/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation

class DebugError: Error {
    
}

extension DebugError: LocalizedError {
    var errorDescription: String? {
        return "Debug error"
    }
}
