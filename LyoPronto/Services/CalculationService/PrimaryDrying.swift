//
//  PrimaryDrying.swift
//  LyoPronto
//


import Foundation

class PrimaryDrying {
    
    let vial: Vial
    let product: Product
    var ht: Ht
    var pchamber: Pchamber
    var tshelf: Tshelf
    let functions: Functions
    let numerical_solvers: NumericalSolver
    
    
    init(vial: Vial, product: Product, ht: Ht, pchamber: Pchamber, tshelf: Tshelf) {
        self.vial = vial
        self.product = product
        self.ht = ht
        self.pchamber = pchamber
        self.pchamber.setpt.insert(self.pchamber.setpt.first ?? 0.0, at: 0)
        self.tshelf = tshelf
        self.tshelf.setpt.insert(self.tshelf.init_val, at: 0)
        self.functions = Functions()
        self.numerical_solvers = NumericalSolver()
    }
    
    func initialize_tsetpt(){
        
        for dt_setpt_val in self.tshelf.dt_setpt {
            self.tshelf.t_setpt.append((self.tshelf.t_setpt.last ?? 0.0) + dt_setpt_val/Constants.hr_to_min)
        }
        
        for dt_setpt_val in self.pchamber.dt_setpt {
            self.pchamber.t_setpt.append((self.pchamber.t_setpt.last ?? 0.0) + dt_setpt_val/Constants.hr_to_min)
        }
        
    }
    
    func calculate_tsh(elapsed_time: Double) -> (Double, Bool) {
        
        var tsh = self.tshelf.init_val
        
        var drying_complete = false
        
        var valid_time_stamp_index = -1
        
        for (index, t_setpt) in self.tshelf.t_setpt.enumerated() {
            if (t_setpt > elapsed_time) {
                valid_time_stamp_index = index
                break
            }
        }
        
        if (valid_time_stamp_index <= -1){
            // print("Total time exceeded. Drying Complete!")
            drying_complete = true
            return (tsh, drying_complete)
        }
        
        if (valid_time_stamp_index == 0 && self.tshelf.setpt.count > valid_time_stamp_index){
            tsh = self.tshelf.setpt[valid_time_stamp_index]
        }
        else if (self.tshelf.setpt.count > valid_time_stamp_index){
            let ramp_rate = self.tshelf.ramp_rate*Constants.hr_to_min*(elapsed_time-self.tshelf.t_setpt[valid_time_stamp_index-1])
            if (self.tshelf.setpt[valid_time_stamp_index] >= self.tshelf.setpt[valid_time_stamp_index-1]){
                tsh = min(self.tshelf.setpt[valid_time_stamp_index-1] + ramp_rate, self.tshelf.setpt[valid_time_stamp_index])
            }
            else{
                tsh = max(self.tshelf.setpt[valid_time_stamp_index-1] - ramp_rate, self.tshelf.setpt[valid_time_stamp_index])
            }
        }
        
        return (tsh, drying_complete)
    }
    
    func calculate_pch(elapsed_time: Double) -> (Double, Bool) {
        var pch = self.pchamber.setpt.first ?? 0.0
        
        var drying_complete = false
        
        var valid_time_stamp_index = -1
        
        for (index, t_setpt) in self.pchamber.t_setpt.enumerated() {
            if (t_setpt > elapsed_time) {
                valid_time_stamp_index = index
                break
            }
        }
        
        if (valid_time_stamp_index <= -1){
            // print("Total time exceeded. Drying Complete!")
            drying_complete = true
            return (pch, drying_complete)
        }
        
        if (valid_time_stamp_index == 0 && self.pchamber.setpt.count > valid_time_stamp_index){
            pch = self.pchamber.setpt[valid_time_stamp_index]
        }
        else if (self.pchamber.setpt.count > valid_time_stamp_index){
            let ramp_rate = self.pchamber.ramp_rate*Constants.hr_to_min*(elapsed_time-self.pchamber.t_setpt[valid_time_stamp_index-1])
            if (self.pchamber.setpt[valid_time_stamp_index] >= self.pchamber.setpt[valid_time_stamp_index-1]){
                pch = min(self.pchamber.setpt[valid_time_stamp_index-1] + ramp_rate, self.pchamber.setpt[valid_time_stamp_index])
            }
            else{
                pch = max(self.pchamber.setpt[valid_time_stamp_index-1] - ramp_rate, self.pchamber.setpt[valid_time_stamp_index])
            }
        }
        
        return (pch, drying_complete)
    }
    
    func dry_calculator(time_step: Double, kv_known: Bool = true) throws -> ([[Double]], Int) {
        
        let lpr0 = self.functions.get_lpr0(vfill: self.vial.vfill, ap: self.vial.ap, csolid: self.product.csolid)
        
        var iteration_step = 0.0, time_in_hr = 0.0
        
        var lck = 0.0, percent_dried = lck/lpr0*100.0
        
        var drying_complete = false
        
        var tsh = self.tshelf.init_val
        
        var pch = self.pchamber.setpt.first ?? 0.0
        
        let solvent_ratio = 1-self.product.csolid*(Constants.rho_solution-Constants.rho_ice)/Constants.rho_solute
        let solution_ratio = 1-self.product.csolid*Constants.rho_solution/Constants.rho_solute
        
        let vial_ap_in_sq_meters = self.vial.ap*pow(Constants.cm_to_m, 2)
        
        self.initialize_tsetpt()
        
        var output_length = 1
        if (kv_known) {
            output_length = 100000
        }
        var resultant_array: [[Double]] = .init(repeating: [], count: output_length)
        var resultant_array_length = 0
        
        while ((lck <= lpr0) && (!kv_known || Int(iteration_step) < resultant_array.count)) {
            
            let kv = self.functions.get_kv(kc: self.ht.kc, kp: self.ht.kp, kd: self.ht.kd, pch: pch)
            let rp = self.functions.get_rp(length: lck, r0: self.product.r0, a1: self.product.a1, a2: self.product.a2)
            
            let data:[String: Double] = ["pch": pch, "av": self.vial.av, "ap": self.vial.ap, "kv": kv, "lpr0": lpr0, "lck": lck, "rp": rp, "tsh": tsh]
         
            let input_x_val1 = self.tshelf.init_val
            var input_x_val2 = self.tshelf.init_val*1.1
            if (input_x_val2 == 0){
                input_x_val2 = 0.1
            }
            let tsub = self.numerical_solvers.secantSolver(x_values: [input_x_val1, input_x_val2], tolerance_value: 0.001, additional_data: data, function: self.functions.get_temp_sub_solver)
            
            let dmdt = max(0.0, self.functions.get_sub_rate(ap: self.vial.ap, rp: rp, t_sub: tsub, pch: pch))
            
            let tbot = self.functions.get_temp_at_bottom(t_sub: tsub, lpr0: lpr0, lck: lck, pch: pch, rp: rp)
            
            var dl = (dmdt*Constants.kg_to_g)*time_step/(solution_ratio)/(self.vial.ap*Constants.rho_ice)*solvent_ratio
            
            if kv_known {
                let iteration_output = [time_in_hr, tsub, tbot, tsh, pch*Constants.torr_to_mTorr, dmdt/(vial_ap_in_sq_meters), percent_dried]
                if(resultant_array_length < resultant_array.count){
                    resultant_array[resultant_array_length] = iteration_output
                    resultant_array_length += 1
                }
            }
                  
            let lck_prev = lck
            lck = lck + dl
            
            if ((lck_prev < lpr0) && (lck>lpr0)){
                lck = lpr0
                dl = lck - lck_prev
                time_in_hr = iteration_step*time_step + dl/((dmdt*Constants.kg_to_g)/solution_ratio/(self.vial.ap*Constants.rho_ice)*solvent_ratio)
            }
            else{
                time_in_hr = (iteration_step+1.0)*time_step
            }
            
            percent_dried = lck/lpr0*100
            
            (tsh, drying_complete) = self.calculate_tsh(elapsed_time: time_in_hr)
            
            if (drying_complete) {
                break
            }
            
            (pch, drying_complete) = self.calculate_pch(elapsed_time: time_in_hr)
            
            if (drying_complete) {
                break
            }
            
            iteration_step += 1
            
        }
        
        if (kv_known) {
            return (resultant_array, resultant_array_length-1)
        }
        
        resultant_array[0] = [time_in_hr]
        return (resultant_array, 1)
        
    }
    
    
    func dry_calculator_unknown_kv(time_step: Double, kv_range: KVRange) throws -> (([[Double]], Int), Double, Double) {
        
        let kv_array_length = Int((kv_range.to-kv_range.from)/kv_range.step)
        var kv_range_array: [Double] = .init(repeating: kv_range.from, count: kv_array_length+1)
        var iterator = 0
        for kv_value in stride(from: kv_range.from, to: kv_range.to, by: kv_range.step) {
            kv_range_array[iterator] = kv_value
            iterator += 1
        }
        var best_kv_value = kv_range_array[0]
        var min_time_deviation = 1000000.0
        
        
        self.ht.kp = 0.0
        self.ht.kd = 0.0
        for kv_val in kv_range_array {
            self.ht.kc = kv_val
            let (auxilliary_output, array_length) = try self.dry_calculator(time_step: time_step, kv_known: false)
            let time = auxilliary_output[array_length-1][0]
            let time_deviation = abs(kv_range.drying_time-time)/kv_range.drying_time*100
            if (time_deviation < min_time_deviation) {
                min_time_deviation = time_deviation
                best_kv_value = kv_val
            }
        }
        
        self.ht.kc = best_kv_value
        return (try self.dry_calculator(time_step: time_step), best_kv_value, min_time_deviation)
        
    }
    
    
    func run_primary_drying_calc(time_step: Double = 0.001, kv_range: KVRange? = nil) -> [[Double]] {
        if (kv_range != nil) {
            do {
                let default_kv_range = KVRange(from: 10.6*1e-4, to: 10.8*1e-4, step: 0.01*1e-4, drying_time: 15.0)
                let ((resultant_array, length), best_kv_value, min_time_deviation) = try self.dry_calculator_unknown_kv(time_step: time_step, kv_range: kv_range ?? default_kv_range)
            
                print("Best KV Value = \(best_kv_value), Drying Time Deviation = \(min_time_deviation)")
                //print(Array(resultant_array[0...length+1]))
                if (length >= 1) {
                    return Array(resultant_array[0...length])
                }
                else{
                    return []
                }
            }
            catch{
                print("Some Error.")
                // TODO: Write a logger class to log errors AND info logs.
            }
        }
        else{
            do {
                let (resultant_array, length) = try self.dry_calculator(time_step: time_step)
                if (length >= 1) {
                    return Array(resultant_array[0...length])
                }
                else{
                    return []
                }
            }
            catch{
                print("Some Error.")
                // TODO: Write a logger class to log errors AND info logs.
            }
        }
        
        return []
    }
    
}
