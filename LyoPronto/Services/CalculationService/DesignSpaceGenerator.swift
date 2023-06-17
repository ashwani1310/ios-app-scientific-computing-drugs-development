//
//  DesignSpaceGenerator.swift
//  LyoPronto
//

import Foundation

class DesignSpaceGenerator {

    let vial: Vial
    let product: Product
    var ht: Ht
    var pchamber: Pchamber
    var tshelf: Tshelf
    let functions: Functions
    let numerical_solvers: NumericalSolver
    let equipcapability: EquipCapability


    init(vial: Vial, product: Product, ht: Ht, pchamber: Pchamber, tshelf: Tshelf, equipcapability: EquipCapability) {
        self.vial = vial
        self.product = product
        self.ht = ht
        self.pchamber = pchamber
        self.tshelf = tshelf
        self.equipcapability = equipcapability
        self.functions = Functions()
        self.numerical_solvers = NumericalSolver()
    }


    func dry_calculator(time_step: Double, num_vials: Int) throws -> ([[[Double]]], [[Double]], [[Double]]) {

        let lpr0 = self.functions.get_lpr0(vfill: self.vial.vfill, ap: self.vial.ap, csolid: self.product.csolid)

        var iteration_step = 0.0, time_in_hr = 0.0
        var lck = 0.0
        var tsh = self.tshelf.init_val
        var t_setpt = 0.0
        var kv = 0.0
        var init_temp_val = 0.0

        let solvent_ratio = 1-self.product.csolid*(Constants.rho_solution-Constants.rho_ice)/Constants.rho_solute
        let solution_ratio = 1-self.product.csolid*Constants.rho_solution/Constants.rho_solute
        let vial_ap_rho_ice = self.vial.ap*Constants.rho_ice
        let vial_ap_in_sq_meters = self.vial.ap*pow(Constants.cm_to_m, 2)

        var resultant_array: [[Double]] = .init(repeating: [], count: 100000)
        var resultant_array_length = 0

        var t_max = Array(repeating: Array(repeating: 0.0, count: self.pchamber.setpt.count), count: self.tshelf.setpt.count)
        var drying_time = Array(repeating: Array(repeating: 0.0, count: self.pchamber.setpt.count), count: self.tshelf.setpt.count)
        var sub_flux_avg = Array(repeating: Array(repeating: 0.0, count: self.pchamber.setpt.count), count: self.tshelf.setpt.count)
        var sub_flux_max = Array(repeating: Array(repeating: 0.0, count: self.pchamber.setpt.count), count: self.tshelf.setpt.count)
        var sub_flux_end = Array(repeating: Array(repeating: 0.0, count: self.pchamber.setpt.count), count: self.tshelf.setpt.count)

        for (tsh_index, tsh_setpt) in self.tshelf.setpt.enumerated(){
            for (pch_index, pch) in self.pchamber.setpt.enumerated(){

                iteration_step = 0.0
                time_in_hr = 0.0
                lck = 0.0
                tsh = self.tshelf.init_val
                t_setpt = abs(tsh_setpt - self.tshelf.init_val)/self.tshelf.ramp_rate/Constants.hr_to_min
                init_temp_val = tsh
                kv = self.functions.get_kv(kc: self.ht.kc, kp: self.ht.kp, kd: self.ht.kd, pch: pch)

                while (lck <= lpr0) {
                    let rp = self.functions.get_rp(length: lck, r0: self.product.r0, a1: self.product.a1, a2: self.product.a2)

                    let data:[String: Double] = ["pch": pch, "av": self.vial.av, "ap": self.vial.ap, "kv": kv, "lpr0": lpr0, "lck": lck, "rp": rp, "tsh": tsh]

                    let input_x_val1 = init_temp_val
                    var input_x_val2 = init_temp_val*1.1
                    if (input_x_val2 == 0){
                        input_x_val2 = 0.1
                    }
                    
                    let tsub = self.numerical_solvers.secantSolver(x_values: [input_x_val1, input_x_val2], tolerance_value: 0.01, additional_data: data, function: self.functions.get_temp_sub_solver)

                    let dmdt = max(0.0, self.functions.get_sub_rate(ap: self.vial.ap, rp: rp, t_sub: tsub, pch: pch))

                    let tbot = self.functions.get_temp_at_bottom(t_sub: tsub, lpr0: lpr0, lck: lck, pch: pch, rp: rp)

                    var dl = (dmdt*Constants.kg_to_g)*time_step/(solution_ratio)/(vial_ap_rho_ice)*solvent_ratio

                    let iteration_output = [time_in_hr, tbot, dmdt/(vial_ap_in_sq_meters)]

                    if (resultant_array_length < resultant_array.count){
                        resultant_array[resultant_array_length] = iteration_output
                        resultant_array_length += 1
                    }

                    let lck_prev = lck
                    lck = lck + dl
                    if ((lck_prev < lpr0) && (lck > lpr0)) {
                        lck = lpr0
                        dl = lck - lck_prev
                        time_in_hr = iteration_step*time_step + dl/((dmdt*Constants.kg_to_g)/(solution_ratio)/(vial_ap_rho_ice)*(solvent_ratio))
                    }
                    else{
                        time_in_hr = (iteration_step+1) * time_step
                    }

                    if (time_in_hr < t_setpt) {
                        if (self.tshelf.init_val < tsh_setpt) {
                            tsh = tsh + self.tshelf.ramp_rate*Constants.hr_to_min*time_step
                        }
                        else {
                            tsh = tsh - self.tshelf.ramp_rate*Constants.hr_to_min*time_step
                        }
                    }
                    else {
                        tsh = tsh_setpt
                    }

                    iteration_step = iteration_step + 1
                }

                var t_max_val = Double(Int.min)
                var del_t: [Double] = .init(repeating: 0.0, count: resultant_array_length)
                var sub_flux_sum = 0.0
                var del_t_sum = 0.0
                var sub_flux_max_val = Double(Int.min)

                for i in 0..<(resultant_array_length-1) {
                    t_max_val = max(t_max_val, resultant_array[i][1])
                    del_t[i] = resultant_array[i+1][0]-resultant_array[i][0]

                    del_t_sum += del_t[i]
                    sub_flux_sum += resultant_array[i][2]*del_t[i]

                    sub_flux_max_val = max(sub_flux_max_val, resultant_array[i][2])

                }

                t_max_val = max(t_max_val, resultant_array[resultant_array_length-1][1])
                sub_flux_max_val = max(sub_flux_max_val, resultant_array[resultant_array_length-1][2])
                del_t[resultant_array_length-1] = del_t[resultant_array_length-2]

                del_t_sum += del_t[resultant_array_length-1]
                sub_flux_sum += resultant_array[resultant_array_length-1][2]*del_t[resultant_array_length-1]

                t_max[tsh_index][pch_index] = t_max_val
                drying_time[tsh_index][pch_index] = time_in_hr

                sub_flux_avg[tsh_index][pch_index] = sub_flux_sum/del_t_sum
                sub_flux_max[tsh_index][pch_index] = sub_flux_max_val
                sub_flux_end[tsh_index][pch_index] = resultant_array[resultant_array_length-1][2]
                resultant_array_length = 0
            }
        }

        var drying_time_pr = Array(repeating: 0.0, count: 2)
        var sub_flux_avg_pr = Array(repeating: 0.0, count: 2)
        var sub_flux_min_pr = Array(repeating: 0.0, count: 2)
        var sub_flux_end_pr = Array(repeating: 0.0, count: 2)

        let p_chamber_setpt = [self.pchamber.setpt[0], self.pchamber.setpt[self.pchamber.setpt.count-1]]

        resultant_array = .init(repeating: [], count: 100000)
        resultant_array_length = 0

        for (index, pch) in p_chamber_setpt.enumerated(){
            iteration_step = 0.0
            time_in_hr = 0.0
            lck = 0.0
            kv = self.functions.get_kv(kc: self.ht.kc, kp: self.ht.kp, kd: self.ht.kd, pch: pch)

            while (lck <= lpr0) {
                let rp = self.functions.get_rp(length: lck, r0: self.product.r0, a1: self.product.a1, a2: self.product.a2)

                let data:[String: Double] = ["tbot": self.product.cr_temp, "lpr0": lpr0, "lck": lck, "rp": rp, "pch": pch]

                let input_x_val1 = self.product.cr_temp
                var input_x_val2 = self.product.cr_temp*1.1
                if (input_x_val2 == 0){
                    input_x_val2 = 0.1
                }
                
                let tsub = self.numerical_solvers.secantSolver(x_values: [input_x_val1, input_x_val2], tolerance_value: 0.01, additional_data: data, function: self.functions.get_temp_sub_from_tpr)

                let dmdt = max(0.0, self.functions.get_sub_rate(ap: self.vial.ap, rp: rp, t_sub: tsub, pch: pch))

                var dl = (dmdt*Constants.kg_to_g)*time_step/(solution_ratio)/(vial_ap_rho_ice)*solvent_ratio

                let iteration_output = [time_in_hr, dmdt/(vial_ap_in_sq_meters)]

                if (resultant_array_length < resultant_array.count){
                    resultant_array[resultant_array_length] = iteration_output
                    resultant_array_length += 1
                }
                
                let lck_prev = lck
                lck = lck + dl
                if ((lck_prev < lpr0) && (lck > lpr0)) {
                    lck = lpr0
                    dl = lck - lck_prev
                    time_in_hr = iteration_step*time_step + dl/((dmdt*Constants.kg_to_g)/(solution_ratio)/(vial_ap_rho_ice)*(solvent_ratio))
                }
                else{
                    time_in_hr = (iteration_step+1) * time_step
                }

                iteration_step = iteration_step + 1
            }


            drying_time_pr[index] = time_in_hr

            var del_t: [Double] = .init(repeating: 0.0, count: resultant_array_length)
            var sub_flux_sum = 0.0
            var del_t_sum = 0.0
            var sub_flux_min_val = Double(Int.max)

            for i in 0..<(resultant_array_length-1) {
                del_t[i] = resultant_array[i+1][0]-resultant_array[i][0]

                del_t_sum += del_t[i]
                sub_flux_sum += resultant_array[i][1]*del_t[i]

                sub_flux_min_val = min(sub_flux_min_val, resultant_array[i][1])

            }

            sub_flux_min_val = min(sub_flux_min_val, resultant_array[resultant_array_length-1][1])
            del_t[resultant_array_length-1] = del_t[resultant_array_length-2]

            del_t_sum += del_t[resultant_array_length-1]
            sub_flux_sum += resultant_array[resultant_array_length-1][1]*del_t[resultant_array_length-1]

            sub_flux_avg_pr[index] = sub_flux_sum/del_t_sum
            sub_flux_min_pr[index] = sub_flux_min_val
            sub_flux_end_pr[index] = resultant_array[resultant_array_length-1][1]
            
            resultant_array_length = 0
        }


        var t_max_eq_cap = Array(repeating: 0.0, count: self.pchamber.setpt.count)
        
        var dmdt_eq_cap = self.pchamber.setpt.map{$0 * self.equipcapability.b}
        for i in 0..<dmdt_eq_cap.count {
            dmdt_eq_cap[i] += self.equipcapability.a
        }

        let sub_flux_eq_cap = dmdt_eq_cap.map{$0/Double(num_vials)/vial_ap_in_sq_meters}

        var drying_time_eq_cap = dmdt_eq_cap.map{$0/Double(num_vials)}
        
        for i in 0..<drying_time_eq_cap.count{
            drying_time_eq_cap[i] *= Constants.kg_to_g
            drying_time_eq_cap[i] /= solution_ratio
            drying_time_eq_cap[i] /= vial_ap_rho_ice
            drying_time_eq_cap[i] *= solvent_ratio
            drying_time_eq_cap[i] = lpr0/drying_time_eq_cap[i]
            
        }

        var lck_list = Array(repeating: 0.0, count: 100)
        let lck_list_step = Float(lpr0)/99
        for i in 0..<100 {
            lck_list[i] = Double(Float(i)*lck_list_step)
        }
        let rp_list = self.functions.get_list_of_rp_values(length: lck_list, r0: self.product.r0, a1: self.product.a1, a2: self.product.a2)

        for (index, pch) in self.pchamber.setpt.enumerated() {
            t_max_eq_cap[index] = self.functions.get_tbot_max_eq_cap(pch: pch, dm_dt: dmdt_eq_cap[index], lpr0: lpr0, lck: lck_list, rp: rp_list, ap: self.vial.ap)
        }

        var result1 = [[[Double]]]()
        var result2 = [[Double]]()
        var result3 = [[Double]]()

        result1.append(t_max)
        result1.append(drying_time)
        result1.append(sub_flux_avg)
        result1.append(sub_flux_max)
        result1.append(sub_flux_end)

        let crit_prod_temp_list: [Double] = [self.product.cr_temp, self.product.cr_temp]
        result2.append(crit_prod_temp_list)
        result2.append(drying_time_pr)
        result2.append(sub_flux_avg_pr)
        result2.append(sub_flux_min_pr)
        result2.append(sub_flux_end_pr)

        result3.append(t_max_eq_cap)
        result3.append(drying_time_eq_cap)
        result3.append(sub_flux_eq_cap)

        return (result1, result2, result3)
    }


    func get_design_space_output(time_step: Double, num_vials: Int) throws -> ([String: [[Double]]]) {

        let (design_space_shelf, design_space_pr, design_space_eq_cap) = try self.dry_calculator(time_step: time_step, num_vials: num_vials)

        var shelf_temp = Array(repeating: Array(repeating: 0.0, count: 7), count: self.tshelf.setpt.count*self.pchamber.setpt.count)

        for i in 0..<(self.tshelf.setpt.count) {
            for j in 0..<(self.pchamber.setpt.count) {
                shelf_temp[(i*self.pchamber.setpt.count)+j][0] = self.tshelf.setpt[i]
                shelf_temp[(i*self.pchamber.setpt.count)+j][1] = self.pchamber.setpt[j]*Constants.torr_to_mTorr
                shelf_temp[(i*self.pchamber.setpt.count)+j][2] = design_space_shelf[0][i][j]
                shelf_temp[(i*self.pchamber.setpt.count)+j][3] = design_space_shelf[1][i][j]
                shelf_temp[(i*self.pchamber.setpt.count)+j][4] = design_space_shelf[2][i][j]
                shelf_temp[(i*self.pchamber.setpt.count)+j][5] = design_space_shelf[3][i][j]
                shelf_temp[(i*self.pchamber.setpt.count)+j][6] = design_space_shelf[4][i][j]
            }
        }

        var product_temp = Array(repeating: Array(repeating: 0.0, count: 7), count: 2)

        for i in 0..<2 {
            product_temp[i][0] = self.product.cr_temp
            product_temp[i][1] = self.pchamber.setpt[i*(self.pchamber.setpt.count-1)]*Constants.torr_to_mTorr
            for j in 0..<5 {
                product_temp[i][j+2] = design_space_pr[j][i]
            }
        }

        var eqp_cap = Array(repeating: Array(repeating: 0.0, count: 6), count: self.pchamber.setpt.count)

        for i in 0..<(self.pchamber.setpt.count) {
            eqp_cap[i][0] = self.pchamber.setpt[i]*Constants.torr_to_mTorr
            eqp_cap[i][1] = design_space_eq_cap[0][i]
            eqp_cap[i][2] = design_space_eq_cap[1][i]
            eqp_cap[i][3] = design_space_eq_cap[2][i]
            eqp_cap[i][4] = design_space_eq_cap[2][i]
            eqp_cap[i][5] = design_space_eq_cap[2][i]
        }


        var output_data : [String: [[Double]]] = ["table_shelf_temperature": shelf_temp, "table_product_temperature": product_temp, "table_equipment_capability": eqp_cap]

        let pchamber_setpt = self.pchamber.setpt.map{$0 * Constants.torr_to_mTorr}
        
        var graph_shelf_temp = Array(repeating: Array(repeating: 0.0, count: self.tshelf.setpt.count+2), count: 4)

        var prodtemp_aux_values: [Double] = [Double]()
        var design_space_pr_index = 0
        for i in 0..<(self.pchamber.setpt.count) {
            for j in 0..<(self.tshelf.setpt.count){
                graph_shelf_temp[0][j] = self.tshelf.setpt[j]
                graph_shelf_temp[1][j] = design_space_shelf[0][j][i]
                graph_shelf_temp[2][j] = design_space_shelf[1][j][i]
                graph_shelf_temp[3][j] = design_space_shelf[2][j][i]
            }
            
            
            // Critical Product Temperature
            if(i==0 || i==self.pchamber.setpt.count-1){
                graph_shelf_temp[0][self.tshelf.setpt.count] = self.product.cr_temp
                graph_shelf_temp[1][self.tshelf.setpt.count] = design_space_pr[0][design_space_pr_index]
                graph_shelf_temp[2][self.tshelf.setpt.count] = design_space_pr[1][design_space_pr_index]
                graph_shelf_temp[3][self.tshelf.setpt.count] = design_space_pr[2][design_space_pr_index]
                prodtemp_aux_values.append(graph_shelf_temp[0][self.tshelf.setpt.count])
                prodtemp_aux_values.append(graph_shelf_temp[1][self.tshelf.setpt.count])
                prodtemp_aux_values.append(graph_shelf_temp[2][self.tshelf.setpt.count])
                prodtemp_aux_values.append(graph_shelf_temp[3][self.tshelf.setpt.count])
                design_space_pr_index += 1
            }
            else{
                graph_shelf_temp[0][self.tshelf.setpt.count] = prodtemp_aux_values[0]
                graph_shelf_temp[1][self.tshelf.setpt.count] = prodtemp_aux_values[1]
                graph_shelf_temp[2][self.tshelf.setpt.count] = prodtemp_aux_values[2]
                graph_shelf_temp[3][self.tshelf.setpt.count] = prodtemp_aux_values[3]
            }
            
            
            // Equipment Capability
            graph_shelf_temp[0][self.tshelf.setpt.count+1] = 0.0
            graph_shelf_temp[1][self.tshelf.setpt.count+1] = eqp_cap[i][1]
            graph_shelf_temp[2][self.tshelf.setpt.count+1] = eqp_cap[i][2]
            graph_shelf_temp[3][self.tshelf.setpt.count+1] = eqp_cap[i][3]
            
            output_data["graph_\(String(format: "%.2f", pchamber_setpt[i]))"] = graph_shelf_temp
        }
               
        return output_data
    }

    func run_design_space_generator(time_step: Double = 0.001, num_vials: Double = 1.0) -> ([String: [[Double]]]) {

        do {
            let resultant_array  = try self.get_design_space_output(time_step: time_step, num_vials: Int(num_vials))
    
            return resultant_array
        }
        catch{
            print("Some Error.")
            // TODO: Write a logger class to log errors AND info logs.
        }
        return [:]
    }

}
