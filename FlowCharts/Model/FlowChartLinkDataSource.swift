//
//  FlowChartLinkDataSource.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 15/02/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit
import DiagramGeometry
import DiagramView

class FlowChartLinkDataSource: LinkDataSource {
    
    unowned let link: FlowChartLink
    
    var delegate: LinkDataSourceDelegate?
    
    private(set) var arrow: Arrow
    
    private(set) var lineDashPattern: [Double]
    private(set) var originDashPattern: [Double]
    private(set) var endingDashPattern: [Double]
    
    private(set) var strokeColor: UIColor
    private(set) var originFillColor: UIColor
    private(set) var endingFillColor: UIColor
    
    private var originFillPattern: LinkPointerFillPattern
    private var endingFillPattern: LinkPointerFillPattern
    
    init(link: FlowChartLink) {
        
        self.link = link
        
        self.arrow = link.arrow
        
        self.lineDashPattern = link.lineDashPattern
        self.originDashPattern = link.originDashPattern
        self.endingDashPattern = link.endingDashPattern
        
        self.originFillPattern = link.origin.pointerPreset.pointerFillPattern
        self.endingFillPattern = link.ending.pointerPreset.pointerFillPattern
        
        self.strokeColor = FlowChartLink.normalStrokeColor
        self.originFillColor = FlowChartLinkDataSource.pointerFillColor(
            forStrokeColor: strokeColor, withFillPattern: originFillPattern)
        self.endingFillColor = FlowChartLinkDataSource.pointerFillColor(
            forStrokeColor: strokeColor, withFillPattern: endingFillPattern)
    }
    
    // MARK: - Arrow
    
    func updateArrow(withIn transition: Transition) {
        changeArrow(link.arrow, withIn: transition)
    }
    
    private func changeArrow(_ arrow: Arrow, withIn transition: Transition) {
        transition.addBeginning {
            self.arrow = arrow
        }
        delegate?.linkWillChangeArrow(self, withIn: transition)
    }
    
    // MARK: - Dash patterns
    
    func updateLineDashPattern(withIn transition: Transition) {
        changeLineDashPattern(link.lineDashPattern, withIn: transition)
    }
    
    func updateOriginDashPattern(withIn transition: Transition) {
        changeOriginDashPattern(link.originDashPattern, withIn: transition)
    }
    
    func updateEndingDashPattern(withIn transition: Transition) {
        changeEndingDashPattern(link.endingDashPattern, withIn: transition)
    }
    
    private func changeLineDashPattern(_ pattern: [Double], withIn transition: Transition) {
        transition.addBeginning {
            self.lineDashPattern = pattern
        }
        delegate?.linkWillChangeLineDashPattern(self, withIn: transition)
    }
    
    private func changeOriginDashPattern(_ pattern: [Double], withIn transition: Transition) {
        transition.addBeginning {
            self.originDashPattern = pattern
        }
        delegate?.linkWillChangeOriginFillColor(self, withIn: transition)
    }
    
    private func changeEndingDashPattern(_ pattern: [Double], withIn transition: Transition) {
        transition.addBeginning {
            self.endingDashPattern = pattern
        }
        delegate?.linkWillChangeEndingDashPattern(self, withIn: transition)
    }
    
    // MARK: - Colors
    
    func setStrokeColor(_ color: UIColor, withIn transition: Transition) {
        updateColors(strokeColor: color, withIn: transition)
    }
    
    func setStrokeColor(_ color: UIColor, with transition: Transition = .instant()) {
        setStrokeColor(color, withIn: transition)
        transition.perform()
    }
    
    func focus(withIn transition: Transition) {
        setStrokeColor(FlowChartLink.focusedStrokeColor, withIn: transition)
    }
    
    func focus(with transition: Transition = .instant()) {
        focus(withIn: transition)
        transition.perform()
    }
    
    func unfocus(withIn transition: Transition) {
        setStrokeColor(FlowChartLink.normalStrokeColor, withIn: transition)
    }
    
    func unfocus(with transition: Transition = .instant()) {
        unfocus(withIn: transition)
        transition.perform()
    }
    
    func updateOriginFillPattern(withIn transition: Transition) {
        let newOriginFillPattern = link.origin.pointerPreset.pointerFillPattern
        if newOriginFillPattern != originFillPattern {
            originFillPattern = newOriginFillPattern
            changeOriginFillColor(originFillColor(forStrokeColor: strokeColor), withIn: transition)
        }
    }
    
    func updateEndingFillPattern(withIn transition: Transition) {
        let newEndingFillPattern = link.ending.pointerPreset.pointerFillPattern
        if newEndingFillPattern != endingFillPattern {
            endingFillPattern = newEndingFillPattern
            changeEndingFillColor(endingFillColor(forStrokeColor: strokeColor), withIn: transition)
        }
    }
    
    private func updateColors(strokeColor: UIColor, withIn transition: Transition) {
        
        changeStrokeColor(strokeColor, withIn: transition)
        
        let originFillColor = self.originFillColor(forStrokeColor: strokeColor)
        changeOriginFillColor(originFillColor, withIn: transition)
        
        let endingFillColor = self.endingFillColor(forStrokeColor: strokeColor)
        changeEndingFillColor(endingFillColor, withIn: transition)
    }
    
    private func changeStrokeColor(_ color: UIColor, withIn transition: Transition) {
        transition.addBeginning {
            self.strokeColor = color
        }
        delegate?.linkWillChangeStrokeColor(self, withIn: transition)
    }

    private func changeOriginFillColor(_ color: UIColor, withIn transition: Transition) {
        transition.addBeginning {
            self.originFillColor = color
        }
        delegate?.linkWillChangeOriginFillColor(self, withIn: transition)
    }

    private func changeEndingFillColor(_ color: UIColor, withIn transition: Transition) {
        transition.addBeginning {
            self.endingFillColor = color
        }
        delegate?.linkWillChangeEndingFillColor(self, withIn: transition)
    }

    private func originFillColor(forStrokeColor strokeColor: UIColor) -> UIColor {
        return FlowChartLinkDataSource.pointerFillColor(
            forStrokeColor: strokeColor,
            withFillPattern: originFillPattern)
    }
    
    private func endingFillColor(forStrokeColor strokeColor: UIColor) -> UIColor {
        
        return FlowChartLinkDataSource.pointerFillColor(
            forStrokeColor: strokeColor,
            withFillPattern: endingFillPattern)
    }
    
    private static func pointerFillColor(
        forStrokeColor strokeColor: UIColor,
        withFillPattern fillPattern: LinkPointerFillPattern) -> UIColor {
        
        switch fillPattern {
        case .fillWithBackgroundColor:
            return .white
        case .fillWithStrokeColor:
            return strokeColor
        case .none:
            return .clear
        }
    }
}
