//
//  DesignSpaceCalculatorVM.swift
//  LyoPronto
//

import Foundation

class DesignSpaceCalculatorViewModel: ObservableObject {
    
    private init(){}
    
    static let _instance = DesignSpaceCalculatorViewModel()
    
    private func getDesignSpace(_ input: DesignSpaceModel) -> DesignSpaceGenerator? {
        
        // Vial
        var vial: Vial
        if let av = Double(input.av),
           let ap = Double(input.ap),
           let vfill = Double(input.vfill) {
            vial = Vial(av: av, ap: ap, vfill: vfill)
        } else {
            print("cannot convet vial in double  \(#line)")
            return nil
        }
        
        // Product
        var product: Product
        if let cSolid = Double(input.cSolid),
           let crTemp = Double(input.cr_temp),
           let r0 = Double(input.r0),
           let a1 = Double(input.a1),
           let a2 = Double(input.a2) {
            product = Product(csolid: cSolid, cr_temp: crTemp, r0: r0, a1: a1, a2: a2)
        } else {
            print("cannot convet product in double  \(#line)")
            return nil
        }
        
        // Ht
        var ht: Ht
        if let kc = Double(input.kc),
           let kd = Double(input.kd),
           let kp = Double(input.kp) {
            ht = Ht(kc: kc, kp: kp, kd: kd)
        } else {
            print("cannot convet ht in double  \(#line)")
            return nil
        }
        
        // Pchamber
        var pchamber: Pchamber

        var setpt: [Double] = [Double]()
        if (input.setpt.contains(",")) {
            let setpt_list = input.setpt.split(separator: ",")
            for val in setpt_list {
                if let setpt_val = Double(val.replacingOccurrences(of: " ", with: "")) {
                    setpt.append(setpt_val)
                } else{
                    print("cannot convert setpt in double  \(#line)")
                    return nil
                }
            }
        } else if let setpt_val = Double(input.setpt) {
            setpt.append(setpt_val)
        } else {
            print("cannot convert setpt in double  \(#line)")
            return nil
        }
        
        if let ramp_rate = Double(input.ramp_rate) {
            pchamber = Pchamber(
                ramp_rate: ramp_rate,
                setpt: setpt
            )
        } else {
            print("cannot convet pchamber in double  \(#line)")
            return nil
        }
        
        // Tshelf
        var tshelf: Tshelf
        
        var ts_setpt: [Double] = [Double]()
        if (input.ts_setpt.contains(",")) {
            let ts_setpt_list = input.ts_setpt.split(separator: ",")
            for val in ts_setpt_list {
                if let setpt_val = Double(val.replacingOccurrences(of: " ", with: "")) {
                    ts_setpt.append(setpt_val)
                } else{
                    print("cannot convert ts_setpt in double  \(#line)")
                    return nil
                }
            }
        } else if let ts_setpt_val = Double(input.ts_setpt) {
            ts_setpt.append(ts_setpt_val)
        } else {
            print("cannot convert ts_setpt in double  \(#line)")
            return nil
        }
        
        if let ts_init_val = Double(input.ts_init_val),
           let ts_ramp_rate = Double(input.ts_ramp_rate) {
            tshelf = Tshelf(
                init_val: ts_init_val,
                ramp_rate: ts_ramp_rate,
                setpt: ts_setpt)
        } else {
            print("cannot convet tshelf in double  \(#line)")
            return nil
        }
        
        var equipCapability: EquipCapability
        if let equip_a = Double(input.equip_a),
           let equip_b = Double(input.equip_b) {
            equipCapability = EquipCapability(a: equip_a, b: equip_b)
        } else {
            print("cannot convet equipCapability in double  \(#line)")
            return nil
        }
        
        let designSpace = DesignSpaceGenerator(vial: vial, product: product, ht: ht, pchamber: pchamber, tshelf: tshelf, equipcapability: equipCapability)
        
        return designSpace
    }
    
    
    func computeResult(_ userInput: DesignSpaceModel, completion: @escaping(([String : [[Double]]]?,String?)-> Void)) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let designSpace = self.getDesignSpace(userInput) else {
                completion(nil, "Cant convert to DesignSpaceGenerator")
                return
            }
            let time_step = Double(userInput.time_step)
            let num_vials = Double(userInput.n_vials)
            let result = designSpace.run_design_space_generator(time_step: time_step!, num_vials: num_vials!)
            completion(result, nil)
            
        }
    }
    
    
}
