//
//  DisplayNames.swift
//  LyoPronto
//

import Foundation

enum DisplayNames {
    // Primary fields
    static let pchamber = "Chamber Pressure"
    static let tshelf = "Shelf Temperature"
    static let product = "Product"
    static let vial = "Vial"
    static let ht = "Vial Heat Transfer"
    static let equipcapability = "Equipment Capability"
    static let aux_inputs = "Additional Inputs"
    static let other_inputs = "Other Inputs"
    static let freezingProduct = "Freezing Product"
    
    // Attributes for Primary fields
    static let a1 = "A\u{2081} (cm-hr-Torr/g)"
    static let a2 = "A\u{2082} (1/cm)"
    static let ap = "Product Area (cm\u{00B2})"
    static let av = "Vial Area (cm\u{00B2})"
    static let cr_temp = "Critical Product Temperature (\u{2103})"
    static let cSolid = "Solid Content (%w/v)"
    static let dt_setpt = "Hold Time (minutes)"
    static let equip_a = "a (Slope)"
    static let equip_b = "b (Intercept)"
    static let kc = "K\u{1D04} (Cal-K/cm\u{00B2}-s)"
    static let kd = "K\u{1D05} (1/Torr)"
    static let kp = "K\u{1D18} (Cal-K/cm\u{00B2}-s-Torr)"
    static let max = "Maximum Value"
    static let min = "Minimum Value"
    static let r0 = "R\u{2080} (cm\u{00B2}-hr-Torr/g)"
    static let ramp_rate = "Ramp Rate (Torr/minutes)"
    static let setpt = "Setpoint (Torr)"
    static let tf = "Freezing Temperature (\u{2103})"
    static let tn = "Nucleation Temperature (\u{2103})"
    static let tpr0 = "Initial Product Temperature (\u{2103})"
    static let ts_dt_setpt = "Hold Time (minutes)"
    static let ts_init_val = "Initial Shelf Temperature (\u{2103})"
    static let ts_max = "Maximum Value"
    static let ts_min = "Minimum Value"
    static let ts_ramp_rate = "Ramp Rate (\u{2103}/minutes)"
    static let ts_setpt = "Setpoint (\u{2103})"
    static let vfill = "Fill Volume (mL)"
    static let h_freezing = "Heat Transfer Coefficient (W/m\u{00B2} K)"
    static let time_step = "Time Step (hours)"
    static let n_vials = "Number of Vials"
    static let from = "From"
    static let to = "To"
    static let step = "Step"
    static let drying_time = "Primary Drying Time (hours)"
    
    static let vialPresetTitle = "Vial Presets"
    static let productPresetTitle = "Product Presets"
    static let htPresetTitle = "Heat Transfer Presets"
    static let pchamberPresetTitle = "PChamber Presets"
    static let tshelfPresetTitle = "TShelf Presets"
    static let eqpCapPresetTitle = "Equip Capability Presets"
    static let otherPresetTitle = "Presets"
    
    static let history = "History"
}
