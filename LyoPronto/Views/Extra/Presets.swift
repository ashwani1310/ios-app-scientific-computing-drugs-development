//
//  Presets.swift
//  LyoPronto
//

import Foundation

enum PrimaryDryingPresetKeys {
    static let vialKeys = ["6R SCHOTT Vial", "20R SCHOTT Vial"]
    static let productKeys = ["Mannitol 5%", "Sucrose 5%"]
    static let heatTransferKeys = ["REVO Millrock 6R SCHOTT Vial"]
    static let pchamberKeys = ["Mannitol 5% (Typical) 1", "Mannitol 5% (Typical) 2", "Sucrose 5% (Typical) 1", "Sucrose 5% (Typical) 2"]
    static let tshelfKeys = ["Mannitol 5% (Typical) 1", "Mannitol 5% (Typical) 2", "Sucrose 5% (Typical) 1", "Sucrose 5% (Typical) 2"]
    static let otherKeys = ["Option 1"]
    
}

enum PrimaryDryingPresets {
    
    static let vialPresets: [String: VialPreset] = [
        "6R SCHOTT Vial"  : VialPreset(av: "3.8", ap: "3.14", vfill: "3.0"),
        "20R SCHOTT Vial" : VialPreset(av: "7.07", ap: "5.98", vfill: "5.0")
    ]
    
    static let productPresets: [String: ProductPreset] = [
        "Mannitol 5%" : ProductPreset(csolid: "0.05", cr_temp: "-5.0", r0: "1.4", a1: "16.0", a2: "0.0"),
        "Sucrose 5%"  : ProductPreset(csolid: "0.05", cr_temp: "-35.0", r0: "0.208", a1: "15.29", a2: "1.6"),
    ]
    
    static let heatTransferPresets: [String: HtPreset] = [
        "REVO Millrock 6R SCHOTT Vial" : HtPreset(kc: "0.000275", kp: "0.000893", kd: "0.46")
    ]
    
    static let chamberPresets: [String: PchamberPreset] = [
        "Mannitol 5% (Typical) 1" : PchamberPreset(ramp_rate: "0.5", setpt: "0.1", dt_setpt: "3600.0"),
        "Mannitol 5% (Typical) 2" : PchamberPreset(ramp_rate: "0.5", setpt: "0.15, 0.12, 0.1", dt_setpt: "120.0, 120.0, 3600.0"),
        "Sucrose 5% (Typical) 1"  : PchamberPreset(ramp_rate: "0.5", setpt: "0.07", dt_setpt: "3600.0"),
        "Sucrose 5% (Typical) 2"  : PchamberPreset(ramp_rate: "0.5", setpt: "0.07, 0.09, 0.07", dt_setpt: "120.0, 120.0, 3600.0"),
    ]
    
    static let shelfTemperaturePresets: [String: TshelfPreset] = [
        "Mannitol 5% (Typical) 1" : TshelfPreset(init_val: "-45.0", ramp_rate: "1.0", setpt: "10.0", dt_setpt: "3600.0"),
        "Mannitol 5% (Typical) 2" : TshelfPreset(init_val: "-45.0", ramp_rate: "1.0", setpt: "20.0, 10.0, 5.0", dt_setpt: "120.0, 120.0, 3600.0"),
        "Sucrose 5% (Typical) 1"  : TshelfPreset(init_val: "-45.0", ramp_rate: "1.0", setpt: "-30.0", dt_setpt: "3600.0"),
        "Sucrose 5% (Typical) 2"  : TshelfPreset(init_val: "-45.0", ramp_rate: "1.0", setpt: "-35.0, -32.0, -28.0", dt_setpt: "120.0, 120.0, 3600.0")
    ]
    
    static let otherPresets: [String: PDOtherPreset] = [
        "Option 1" : PDOtherPreset(time_step: "0.01")
    ]
}

enum DesignSpacePresetKeys {
    static let vialKeys = ["6R SCHOTT Vial", "20R SCHOTT Vial"]
    static let productKeys = ["Mannitol 5%", "Sucrose 5%"]
    static let heatTransferKeys = ["REVO Millrock 6R SCHOTT Vial"]
    static let pchamberKeys = ["Mannitol 5% (Typical)", "Sucrose 5% (Typical)"]
    static let tshelfKeys = ["Mannitol 5% (Typical)", "Sucrose 5% (Typical)"]
    static let equipCapKeys = ["REVO Millrock 6R SCHOTT Vial"]
    static let otherKeys = ["Option 1"]
    
}

enum DesignSpacePresets {
    
    static let vialPresets: [String: VialPreset] = [
        "6R SCHOTT Vial"  : VialPreset(av: "3.8", ap: "3.14", vfill: "3.0"),
        "20R SCHOTT Vial" : VialPreset(av: "7.07", ap: "5.98", vfill: "5.0")
    ]
    
    static let productPresets: [String: ProductPreset] = [
        "Mannitol 5%" : ProductPreset(csolid: "0.05", cr_temp: "-5.0", r0: "1.4", a1: "16.0", a2: "0.0"),
        "Sucrose 5%"  : ProductPreset(csolid: "0.05", cr_temp: "-35.0", r0: "0.208", a1: "15.29", a2: "1.6")
    ]
    
    static let heatTransferPresets: [String: HtPreset] = [
        "Millrock Revo 6R SCHOTT Vial" : HtPreset(kc: "0.000275", kp: "0.000893", kd: "0.46")
    ]
    
    static let chamberPresets: [String: PchamberPreset] = [
        "Mannitol 5% (Typical)" : PchamberPreset(ramp_rate: "0.5", setpt: "0.2, 0.15, 0.1, 0.07"),
        "Sucrose 5% (Typical)"  : PchamberPreset(ramp_rate: "0.5", setpt: "0.15,0.12,0.1,0.07"),
    ]
    
    static let shelfTemperaturePresets: [String: TshelfPreset] = [
        "Mannitol 5% (Typical)" : TshelfPreset(init_val: "20.0", ramp_rate: "1.0", setpt: "-10.0, -5.0, 0.0, 5.0"),
        "Sucrose 5% (Typical)"  : TshelfPreset(init_val: "20.0", ramp_rate: "1.0", setpt: "-30.0, -20.0, -15.0, -10.0"),
    ]
    
    static let eqpCapPresets: [String: EquipCapabilityPreset] = [
        "Millrock Revo" : EquipCapabilityPreset(a: "-0.182", b: "11.7")
    ]
    
    static let otherPresets: [String: DSOtherPreset] = [
        "Option 1" : DSOtherPreset(time_step: "0.05", num_vials: "1000")
    ]
}

enum FreezingPresetKeys {
    static let vialKeys = ["6R SCHOTT Vial", "20R SCHOTT Vial"]
    static let productKeys = ["Option 1"]
    static let tshelfKeys = ["Option 1"]
    static let otherKeys = ["Option 1", "Option 2"]
    
}

enum FreezingPresets {
    
    static let vialPresets: [String: VialPreset] = [
        "6R SCHOTT Vial"  : VialPreset(av: "3.8", ap: "3.14", vfill: "3.0"),
        "20R SCHOTT Vial" : VialPreset(av: "7.07", ap: "5.98", vfill: "5.0")
    ]
    
    static let productPresets: [String: ProductPreset] = [
        "Option 1" : ProductPreset(csolid: "0.0", tpr0: "20.0", tf: "0.0", tn: "-12.0")
    ]
    
    static let shelfTemperaturePresets: [String: TshelfPreset] = [
        "Option 1" : TshelfPreset(init_val: "20.0", ramp_rate: "1.0", setpt: "-40.0", dt_setpt: "180.0")
    ]
    
    static let otherPresets: [String: FreezingOtherPreset] = [
        "Option 1" : FreezingOtherPreset(time_step: "0.016", h_freezing: "45.0"),
        "Option 2" : FreezingOtherPreset(time_step: "0.016", h_freezing: "60.0")
    ]
}
