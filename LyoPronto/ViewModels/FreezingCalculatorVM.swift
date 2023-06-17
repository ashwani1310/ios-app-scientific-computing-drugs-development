//
//  FreezingCalculatorVM.swift
//  LyoPronto
//

import Foundation

class FreezingCalculatorViewModel: ObservableObject {
    
    private init(){}
    
    static let _instance = FreezingCalculatorViewModel()
    
    private func getFreezing(_ input: FreezingModel) -> FreezingCalculator? {
        
        // Vial
        var vial: Vial
        if let av = Double(input.av),
           let ap = Double(input.ap),
           let vfill = Double(input.vfill) {
            vial = Vial(av: av, ap: ap, vfill: vfill)
        } else {
            print("cannot convert vial in double  \(#line)")
            return nil
        }
        
        // Product
        var product: Product
        if let cSolid = Double(input.cSolid),
           let tpr0 = Double(input.tpr0),
           let tf = Double(input.tf),
           let tn = Double(input.tn) {
            product = Product(csolid: cSolid, tpr0: tpr0, tf: tf, tn: tn)
        } else {
            print("cannot convert product in double  \(#line)")
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
                dt_setpt: ts_dt_setpt
                )
        } else {
            print("cannot convert tshelf in double  \(#line)")
            return nil
        }
        
        let freezing = FreezingCalculator(vial: vial, product: product, tshelf: tshelf)
        
        return freezing
    }
    
    
    func computeResult(_ userInput: FreezingModel, completion: @escaping(([[Double]]?,String?)-> Void)) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let freezing = self.getFreezing(userInput) else {
                completion(nil, "Cant convert tp freezing")
                return
            }
            let time_step = Double(userInput.time_step)
            let h_freezing = Double(userInput.h_freezing)
            let result = freezing.run_freezing_calc(time_step: time_step!, h_freezing: h_freezing!)
            completion(result, nil)
        }
    }
}
