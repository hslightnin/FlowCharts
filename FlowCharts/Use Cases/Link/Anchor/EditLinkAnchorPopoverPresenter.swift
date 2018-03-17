//
//  EditLinkAnchorPopoverPresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 01/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry

class EditLinkAnchorPopoverPresenter: PopoverPresenter, PointerPresetsViewControllerDelegate {
    
    var onSelectedPresetChanged: ((PointerPreset) -> Void)?
    
    // MARK: - Properties
    
    var pointerPresets: [PointerPreset] {
        get { return pointerPresentsViewController.pointerPresets }
        set { pointerPresentsViewController.pointerPresets = newValue }
    }
    
    var pointerDirection: Vector {
        get { return pointerPresentsViewController.pointerDirection }
        set { pointerPresentsViewController.pointerDirection = newValue }
    }
    
    var selectedPointerPreset: PointerPreset? {
        get { return pointerPresentsViewController.selectedPointerPreset }
        set { pointerPresentsViewController.selectedPointerPreset = newValue }
    }
    
    // MARK: - Presented items
    
    private lazy var pointerPresentsViewController: PointerPresetsViewController = {
        let storyboard = UIStoryboard(name: "PointerPresets", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! PointerPresetsViewController
        viewController.delegate = self
        return viewController
    }()
    
    override func loadContentViewController() -> UIViewController {
        return pointerPresentsViewController
    }
    
    // MARK: - Interactions
    
    func pointerPresetsViewController(_ viewController: PointerPresetsViewController, didSelect preset: PointerPreset) {
        onSelectedPresetChanged?(preset)
    }
}

