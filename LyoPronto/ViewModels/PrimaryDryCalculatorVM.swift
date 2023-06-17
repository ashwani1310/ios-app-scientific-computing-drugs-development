//
//  PrimaryDryCalculator.swift
//  LyoPronto
//

import Foundation

class PrimaryDryCalculatorViewModel: ObservableObject {
    
    private init(){}
    
    static let _instance = PrimaryDryCalculatorViewModel()
    
    private func getPrimaryDrying(_ input: PDModel) -> PrimaryDrying? {
        
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
        var dt_setpt: [Double] = [Double]()
        
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
        
        if (input.dt_setpt.contains(",")) {
            let dt_setpt_list = input.dt_setpt.split(separator: ",")
            for val in dt_setpt_list {
                if let dt_setpt_val = Double(val.replacingOccurrences(of: " ", with: "")) {
                    dt_setpt.append(dt_setpt_val)
                } else{
                    print("cannot convert dt_setpt in double  \(#line)")
                    return nil
                }
            }
        } else if let dt_setpt_val = Double(input.dt_setpt) {
            dt_setpt.append(dt_setpt_val)
        } else {
            print("cannot convert dt_setpt in double  \(#line)")
            return nil
        }

        if let ramp_rate = Double(input.ramp_rate) {
            pchamber = Pchamber(
                ramp_rate: ramp_rate,
                setpt: setpt,
                dt_setpt: dt_setpt
            )
        } else {
            print("cannot convet pchamber in double  \(#line)")
            return nil
        }
        
        // Tshelf
        var tshelf: Tshelf
        var ts_setpt: [Double] = [Double]()
        var ts_dt_setpt: [Double] = [Double]()
        
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
        
        if (input.ts_dt_setpt.contains(",")) {
            let dt_setpt_list = input.ts_dt_setpt.split(separator: ",")
            for val in dt_setpt_list {
                if let dt_setpt_val = Double(val.replacingOccurrences(of: " ", with: "")) {
                    ts_dt_setpt.append(dt_setpt_val)
                } else{
                    print("cannot convert ts_dt_setpt in double  \(#line)")
                    return nil
                }
            }
        } else if let dt_setpt_val = Double(input.ts_dt_setpt) {
            ts_dt_setpt.append(dt_setpt_val)
        } else {
            print("cannot convert ts_dt_setpt in double  \(#line)")
            return nil
        }
        
        if let ts_init_val = Double(input.ts_init_val),
           let ts_ramp_rate = Double(input.ts_ramp_rate) {
            tshelf = Tshelf(
                init_val: ts_init_val,
                ramp_rate: ts_ramp_rate,
                setpt: ts_setpt,
                dt_setpt: ts_dt_setpt)
        } else {
            print("cannot convet tshelf in double  \(#line)")
            return nil
        }
        
        let primaryDrying = PrimaryDrying(vial: vial, product: product, ht: ht, pchamber: pchamber, tshelf: tshelf)
        
        return primaryDrying
    }
    
    private func getKVRange(_ input: PDModel) -> KVRange? {
        var kvrange: KVRange
        if let from = Double(input.from),
           let to = Double(input.to),
           let step = Double(input.step),
           let drying_time = Double(input.drying_time) {
            kvrange = KVRange(from: from, to: to, step: step, drying_time: drying_time)
        } else {
            print("Cannot create KVrange object.")
            return nil
        }
        return kvrange
    }
    
    
    func computeResult(_ userInput: PDModel, completion: @escaping(([[Double]]?,String?)-> Void)) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let primaryDring = self.getPrimaryDrying(userInput) else {
                completion(nil, "Cant convert tp primary drying")
                return
            }
            let time_step = Double(userInput.time_step)
            
            if (!userInput.kv_known){
                guard let kv_range = self.getKVRange(userInput) else {
                    completion(nil, "Cant convert to kvrange to call primary drying")
                    return
                }
                let result = primaryDring.run_primary_drying_calc(time_step: time_step!, kv_range: kv_range)
                completion(result, nil)
            }
            else{
                let result = primaryDring.run_primary_drying_calc(time_step: time_step!)
                completion(result, nil)
            }
        }
    }
    
    
}
