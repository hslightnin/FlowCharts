//
//  UserDefaults+Debug.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 27/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    var slowPresentationTransitions: Bool {
        get { return bool(forKey: "slowPresentationTransitions") }
        set { setValue(newValue, forKey: "slowPresentationTransitions") }
    }
    
    var slowDismissionTransitions: Bool {
        get { return bool(forKey: "slowDismissionTransitions") }
        set { setValue(newValue, forKey: "slowDismissionTransitions") }
    }
    
    var slowChangeoverTransitions: Bool {
        get { return bool(forKey: "slowChangeoverTransitions") }
        set { setValue(newValue, forKey: "slowChangeoverTransitions") }
    }
    
    var simulateBuildSymbolErrors: Bool {
        get { return bool(forKey: "simlateBuildSymbolErrors") }
        set { setValue(newValue, forKey: "simlateBuildSymbolErrors") }
    }
    
    var simulateMoveSymbolErrors: Bool {
        get { return bool(forKey: "simulateMoveSymbolErrors") }
        set { setValue(newValue, forKey: "simulateMoveSymbolErrors") }
    }
    
    var simulateDeleteSymbolErrors: Bool {
        get { return bool(forKey: "simulateDeleteSymbolErrors") }
        set { setValue(newValue, forKey: "simulateDeleteSymbolErrors") }
    }
    
    var simulateEditSymbolTextErrors: Bool {
        get { return bool(forKey: "simulateEditSymbolTextErrors") }
        set { setValue(newValue, forKey: "simulateEditSymbolTextErrors") }
    }
    
    var simulateResizeSymbolErrors: Bool {
        get { return bool(forKey: "simulateResizeSymbolErrors") }
        set { setValue(newValue, forKey: "simulateResizeSymbolErrors") }
    }
    
    var simulateEditSymbolPropertiesErrors: Bool {
        get { return bool(forKey: "simulateEditSymbolPropertiesErrors") }
        set { setValue(newValue, forKey: "simulateEditSymbolPropertiesErrors") }
    }
    
    var simulateBuildLinkErrors: Bool {
        get { return bool(forKey: "simulateBuildLinkErrors") }
        set { setValue(newValue, forKey: "simulateBuildLinkErrorssimulateBuildLinkErrors") }
    }
    
    var simulateBuildLinkErrorsEnabled: Bool {
        get { return bool(forKey: "simulateBuildLinkErrorsEnabled") }
        set { setValue(newValue, forKey: "simulateBuildLinkErrorsEnabled") }
    }
    
    var simulateMoveLinkAnchorErrors: Bool {
        get { return bool(forKey: "simlateMoveLinkAnchorErrors") }
        set { setValue(newValue, forKey: "simlateMoveLinkAnchorErrors") }
    }
    
    var simulateEditLinkAnchorPropertiesErrors: Bool {
        get { return bool(forKey: "simulateEditLinkAnchorPropertiesErrors") }
        set { setValue(newValue, forKey: "simulateEditLinkAnchorPropertiesErrors") }
    }
    
    var simulateDeleteLinkErrors: Bool {
        get { return bool(forKey: "simulateDeleteLinkErrors") }
        set { setValue(newValue, forKey: "simulateDeleteLinkErrors") }
    }
    
    var simulateEditLinkTextErrors: Bool {
        get { return bool(forKey: "simulateEditLinkTextErrors") }
        set { setValue(newValue, forKey: "simulateEditLinkTextErrors") }
    }
    
    var simulateEditLinkPropertiesErrors: Bool {
        get { return bool(forKey: "simlateEditLinkPropertiesErrors") }
        set { setValue(newValue, forKey: "simlateEditLinkPropertiesErrors") }
    }
}
