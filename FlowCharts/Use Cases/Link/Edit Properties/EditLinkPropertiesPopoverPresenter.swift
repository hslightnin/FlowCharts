//
//  EditLinkPropertiesPopoverPresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 01/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit

class EditLinkPropertiesPopoverPresenter: PopoverPresenter, LinePresetsViewControllerDelegate {
    
    var onSelectedPresetsChanged: ((LineTypePreset, LineDashPatternPreset) -> Void)?
    
    // MARK: - Properties
    
    var selectedLineTypePreset: LineTypePreset? {
        get { return linePresetsViewController.selectedLineTypePreset }
        set { linePresetsViewController.selectedLineTypePreset = newValue }
    }
    
    var selectedLineDashPatternPreset: LineDashPatternPreset? {
        get { return linePresetsViewController.selectedLineDashPatternPreset }
        set { linePresetsViewController.selectedLineDashPatternPreset = newValue }
    }
    
    // MARK: - Presented items
    
    private lazy var linePresetsViewController: LinePresetsViewController = {
        let storyboard = UIStoryboard(name: "LinePresets", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! LinePresetsViewController
        viewController.lineTypePresets = LineTypePreset.all
        viewController.lineDashPatternPresets = LineDashPatternPreset.all
        viewController.delegate = self
        return viewController
    }()
    
    override func loadContentViewController() -> UIViewController {
        return linePresetsViewController
    }
    
    // MARK: - Interactions
    
    // MARK: LinePresetsViewControllerDelegate
    
    func linePresetsViewController(
        _ controller: LinePresetsViewController,
        didSelectLineTypePreset lineTypePreset: LineTypePreset,
        lineDashPatternPreset: LineDashPatternPreset) {
        
        onSelectedPresetsChanged?(lineTypePreset, lineDashPatternPreset)
    }
}
