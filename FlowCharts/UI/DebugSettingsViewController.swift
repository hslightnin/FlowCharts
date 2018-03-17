//
//  DebugSettingsViewController.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 27/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit

class DebugSettingsViewController: UITableViewController {

    @IBOutlet var slowPresentationTransitionsSwitch: UISwitch!
    @IBOutlet var slowDismissionTransitionsSwitch: UISwitch!
    @IBOutlet var slowChangeoverTransitionsSwitch: UISwitch!
    @IBOutlet var simulateBuildSymbolErrorSwitch: UISwitch!
    @IBOutlet var simulateDeleteSymbolErrorSwitch: UISwitch!
    @IBOutlet var simulateMoveSymbolErrorSwitch: UISwitch!
    @IBOutlet var simulateEditSymbolTextErrorSwitch: UISwitch!
    @IBOutlet var simulateEditSymbolPropertiesErrorSwitch: UISwitch!
    @IBOutlet var simulateResizeSymbolErrorSwitch: UISwitch!
    @IBOutlet var simulateBuildLinkErrorSwitch: UISwitch!
    @IBOutlet var simulateDeleteLinkErrorSwitch: UISwitch!
    @IBOutlet var simulateMoveLinkAnchorErrorSwitch: UISwitch!
    @IBOutlet var simulatEditLinkPointerErrorSwitch: UISwitch!
    @IBOutlet var simulatEditLinkLineErrorSwitch: UISwitch!
    @IBOutlet var simulatEditLinkTextErrorSwitch: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        slowPresentationTransitionsSwitch.isOn = UserDefaults.standard.slowPresentationTransitions
        slowDismissionTransitionsSwitch.isOn = UserDefaults.standard.slowDismissionTransitions
        slowChangeoverTransitionsSwitch.isOn = UserDefaults.standard.slowChangeoverTransitions
        
        simulateBuildSymbolErrorSwitch.isOn = UserDefaults.standard.simulateBuildSymbolErrors
        
        simulateDeleteSymbolErrorSwitch.isOn = UserDefaults.standard.simulateDeleteSymbolErrors
        simulateMoveSymbolErrorSwitch.isOn = UserDefaults.standard.simulateMoveSymbolErrors
        simulateEditSymbolTextErrorSwitch.isOn = UserDefaults.standard.simulateEditSymbolTextErrors
        simulateEditSymbolPropertiesErrorSwitch.isOn = UserDefaults.standard.simulateEditSymbolPropertiesErrors
        simulateResizeSymbolErrorSwitch.isOn = UserDefaults.standard.simulateResizeSymbolErrors
        simulateBuildLinkErrorSwitch.isOn = UserDefaults.standard.simulateBuildLinkErrorsEnabled
        
        simulateDeleteLinkErrorSwitch.isOn = UserDefaults.standard.simulateDeleteLinkErrors
        simulateMoveLinkAnchorErrorSwitch.isOn = UserDefaults.standard.simulateMoveLinkAnchorErrors
        simulatEditLinkPointerErrorSwitch.isOn = UserDefaults.standard.simulateEditLinkAnchorPropertiesErrors
        simulatEditLinkLineErrorSwitch.isOn = UserDefaults.standard.simulateEditLinkPropertiesErrors
        simulatEditLinkTextErrorSwitch.isOn = UserDefaults.standard.simulateEditLinkTextErrors
    }
    
    @IBAction func changeSetting(_ sender: UISwitch) {
        
        switch sender {
            
        case let control where control === slowPresentationTransitionsSwitch:
            UserDefaults.standard.slowPresentationTransitions = control.isOn
        case let control where control === slowDismissionTransitionsSwitch:
            UserDefaults.standard.slowDismissionTransitions = control.isOn
        case let control where control === slowChangeoverTransitionsSwitch:
            UserDefaults.standard.slowChangeoverTransitions = control.isOn
            
        case let control where control === simulateBuildSymbolErrorSwitch:
            UserDefaults.standard.simulateBuildSymbolErrors = control.isOn
            
        case let control where control === simulateDeleteSymbolErrorSwitch:
            UserDefaults.standard.simulateDeleteSymbolErrors = control.isOn
        case let control where control === simulateMoveSymbolErrorSwitch:
            UserDefaults.standard.simulateMoveSymbolErrors = control.isOn
        case let control where control === simulateEditSymbolTextErrorSwitch:
            UserDefaults.standard.simulateEditSymbolTextErrors = control.isOn
        case let control where control === simulateEditSymbolPropertiesErrorSwitch:
            UserDefaults.standard.simulateEditSymbolPropertiesErrors = control.isOn
        case let control where control === simulateResizeSymbolErrorSwitch:
            UserDefaults.standard.simulateResizeSymbolErrors = control.isOn
        case let control where control === simulateBuildLinkErrorSwitch:
            UserDefaults.standard.simulateBuildLinkErrorsEnabled = control.isOn
            
        case let control where control === simulateDeleteLinkErrorSwitch:
            UserDefaults.standard.simulateDeleteLinkErrors = control.isOn
        case let control where control === simulateMoveLinkAnchorErrorSwitch:
            UserDefaults.standard.simulateMoveLinkAnchorErrors = control.isOn
        case let control where control === simulatEditLinkPointerErrorSwitch:
            UserDefaults.standard.simulateEditLinkAnchorPropertiesErrors = control.isOn
        case let control where control === simulatEditLinkLineErrorSwitch:
            UserDefaults.standard.simulateEditLinkPropertiesErrors = control.isOn
        case let control where control === simulatEditLinkTextErrorSwitch:
            UserDefaults.standard.simulateEditLinkTextErrors = control.isOn
        default:
            break
        }
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
