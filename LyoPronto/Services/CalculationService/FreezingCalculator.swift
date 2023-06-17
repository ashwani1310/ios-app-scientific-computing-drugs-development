//
//  Freezing.swift
//  LyoPronto
//

import Foundation

class FreezingCalculator {

    let vial: Vial
    let product: Product
    var h_freezing: Double
    var tshelf: Tshelf
    var time_step: Double
    var freezing_variables: FreezingVariables
    let functions: Functions
    var tsh_tr: [Double] = []
    var t_tr: [Double] = []
    var ramp_rate: [Double] = []
    var output: [[Double]] = .init(repeating: [], count: 100000)
    var output_length: Int


    init(vial: Vial, product: Product, tshelf: Tshelf) {
        self.vial = vial
        self.product = product
        self.tshelf = tshelf
        self.functions = Functions()
        self.time_step = 0.0
        self.h_freezing = 0.0
        self.output_length = 0
        self.freezing_variables = FreezingVariables(tpr: 0.0, tpr0: 0.0, time_in_hr: 0.0, tsh: 0.0)
    }

    func initialize_triggers(){

        self.tsh_tr.append(self.tshelf.init_val)
        for tshelf_setpt in self.tshelf.setpt {
            self.tsh_tr.append(tshelf_setpt)
            self.tsh_tr.append(tshelf_setpt)
        }

        self.ramp_rate.append(0.0)
        for (index, tsh_tr) in self.tsh_tr.enumerated() {

            if (index == self.tsh_tr.count - 1) {
                break
            }

            if (self.tsh_tr[index+1] > tsh_tr) {
                self.ramp_rate.append(self.tshelf.ramp_rate)
            }
            else if ((index > 0) && (self.tsh_tr[index-1] < tsh_tr)){
                self.ramp_rate.append(-self.tshelf.ramp_rate)
            }
            else if ((index <= 0) && (self.tsh_tr[self.tsh_tr.count-1] < tsh_tr)){
                self.ramp_rate.append(-self.tshelf.ramp_rate)
            }
            else{
                self.ramp_rate.append(0.0)
            }
        }

        self.t_tr.append(0.0)
        var iterator = 0
        for (index, tsh_tr) in self.tsh_tr.enumerated(){

            if (index == self.tsh_tr.count - 1) {
                break
            }

            if (index > 0 && self.tsh_tr[index+1] == tsh_tr) {
                self.t_tr.append(self.t_tr[index-1] + self.tshelf.dt_setpt[iterator]/Constants.hr_to_min)
                iterator += 1
            }
            else if (index <= 0 && self.tsh_tr[index+1] == tsh_tr) {
                self.t_tr.append(self.t_tr[self.t_tr.count-1] + self.tshelf.dt_setpt[iterator]/Constants.hr_to_min)
                iterator += 1
            }
            else{
                self.t_tr.append((self.tsh_tr[index+1] - tsh_tr)/self.ramp_rate[index+1]/Constants.hr_to_min)
            }
        }
    }


    func cooling_phase(step: Double, prev_step: Double) -> (Double, Double) {

        var iteration_step = step
        var i_prev = prev_step

        while (self.output_length < self.output.count && self.freezing_variables.tpr > self.product.tn){

            iteration_step += 1
            self.freezing_variables.time_in_hr = iteration_step*self.time_step

            var valid_tr_index = -1

            for (index, t_tr) in self.t_tr.enumerated() {
                if (t_tr > self.freezing_variables.time_in_hr) {
                    valid_tr_index = index
                    break
                }
            }

            if (valid_tr_index <= -1){
                // print("Total time exceeded. Freezing Inomplete!")
                break
            }

            if (Double(valid_tr_index) != i_prev) {
                self.freezing_variables.tpr0 = self.freezing_variables.tpr
                i_prev = Double(valid_tr_index)
            }

            if (self.ramp_rate.count > valid_tr_index) {
                self.freezing_variables.tsh += self.ramp_rate[valid_tr_index]*Constants.hr_to_min*self.time_step
            }

            var time = 0.0, tsh_tr = 0.0

            if (valid_tr_index > 0 && self.t_tr.count > (valid_tr_index-1)) {
                time = self.freezing_variables.time_in_hr - self.t_tr[valid_tr_index-1]
                tsh_tr = self.tsh_tr[valid_tr_index-1]
            }
            else if (self.tsh_tr.count > 0){
                time = self.freezing_variables.time_in_hr - self.t_tr[self.t_tr.count-1]
                tsh_tr = self.tsh_tr[self.tsh_tr.count-1]
            }

            let data = ["time": time,
                        "tpr0": self.freezing_variables.tpr0,
                        "rho": Constants.rho_solution,
                        "cp": Constants.cp_solution,
                        "volume": self.vial.vfill,
                        "heat_coeff": self.h_freezing,
                        "av": self.vial.av,
                        "tsh": self.freezing_variables.tsh,
                        "tsh0": tsh_tr,
                        "tsh_ramp": self.ramp_rate[valid_tr_index],
            ]
            
            self.freezing_variables.tpr = self.functions.get_lumped_cap_tpr(data: data)
        
            self.output[self.output_length] = [self.freezing_variables.time_in_hr, self.freezing_variables.tsh, self.freezing_variables.tpr]
            self.output_length += 1
        }

        return (iteration_step, i_prev)

    }


    func crystallization_and_solidification_phase(step: Double, prev_step: Double) -> (Double, Double) {

        var iteration_step = step
        var i_prev = prev_step
        var valid_tr_index = -1

        let nucleation_onset_time = self.freezing_variables.time_in_hr

        var data = [ "volume": self.vial.vfill,
                     "heat_coeff": self.h_freezing,
                     "av": self.vial.av,
                     "freezing_temp": self.product.tf,
                     "nucleation_temp": self.product.tn,
                     "shelf_temp": self.freezing_variables.tsh,
        ]

        let crystallization_time = self.functions.get_crystallization_time(data: data)

        let solidification_onset_time = nucleation_onset_time + crystallization_time

        while (self.output_length < self.output.count && self.freezing_variables.time_in_hr < solidification_onset_time){

            valid_tr_index = -1

            for (index, t_tr) in self.t_tr.enumerated() {
                if (t_tr > self.freezing_variables.time_in_hr) {
                    valid_tr_index = index
                    break
                }
            }

            if (valid_tr_index <= -1){
                // print("Total time exceeded. Freezing Incomplete!")
                break
            }

            if (Double(valid_tr_index) != i_prev) {
                self.freezing_variables.tpr0 = self.freezing_variables.tpr
                i_prev = Double(valid_tr_index)
            }

            if (self.ramp_rate.count > valid_tr_index) {
                self.freezing_variables.tsh += self.ramp_rate[valid_tr_index]*Constants.hr_to_min*self.time_step
            }
            
            self.freezing_variables.tpr = self.product.tf

            self.output[self.output_length] = [self.freezing_variables.time_in_hr, self.freezing_variables.tsh, self.freezing_variables.tpr]
            self.output_length += 1

            iteration_step += 1
            self.freezing_variables.time_in_hr = iteration_step*self.time_step
        }

        let lpr0 = self.functions.get_lpr0(vfill: self.vial.vfill, ap: self.vial.ap, csolid: self.product.csolid)

        let frozen_product_volume = lpr0*self.vial.ap

        while(self.output_length < self.output.count && self.freezing_variables.time_in_hr < self.t_tr[self.t_tr.count-1]){

            if (self.ramp_rate.count > valid_tr_index && self.tshelf.setpt.count > 0 && self.freezing_variables.tsh > self.tshelf.setpt[0]){
                self.freezing_variables.tsh += self.ramp_rate[valid_tr_index]*Constants.hr_to_min*self.time_step
            }

            data = ["time": self.freezing_variables.time_in_hr - solidification_onset_time,
                    "tpr0": self.product.tf,
                    "rho": Constants.rho_ice,
                    "cp": Constants.cp_ice,
                    "volume": frozen_product_volume,
                    "heat_coeff": self.h_freezing,
                    "av": self.vial.av,
                    "tsh": self.freezing_variables.tsh,
                    "tsh0": self.freezing_variables.tsh,
                    "tsh_ramp": 0.0,
            ]

            self.freezing_variables.tpr = self.functions.get_lumped_cap_tpr(data: data)

            self.output[self.output_length] = [self.freezing_variables.time_in_hr, self.freezing_variables.tsh, self.freezing_variables.tpr]
            self.output_length += 1

            iteration_step += 1
            self.freezing_variables.time_in_hr = iteration_step*self.time_step
        }

        return (iteration_step, i_prev)
    }


    func freezing_calculator() throws -> ([[Double]], Int) {

        self.freezing_variables.time_in_hr = 0.0
        self.freezing_variables.tsh = self.tshelf.init_val
        self.freezing_variables.tpr = self.product.tpr0
        self.freezing_variables.tpr0 = self.product.tpr0

        self.initialize_triggers()

        if (self.output_length < self.output.count) {
            self.output[self.output_length] = [self.freezing_variables.time_in_hr, self.freezing_variables.tsh, self.freezing_variables.tpr]
            self.output_length += 1
        }
        
        var i_prev = 1.0
        var iteration_step = 0.0

        (iteration_step, i_prev) = self.cooling_phase(step: iteration_step, prev_step: i_prev)

        if (self.output_length < self.output.count) {
            self.output[self.output_length] = [self.freezing_variables.time_in_hr, self.freezing_variables.tsh, self.product.tn]
            self.output_length += 1
        }

        (iteration_step, i_prev) = self.crystallization_and_solidification_phase(step: iteration_step, prev_step: i_prev)

        return (self.output, Int(self.output_length)-1)

    }


    func run_freezing_calc(time_step: Double, h_freezing: Double) -> [[Double]] {
        do {
            self.time_step = time_step
            self.h_freezing = h_freezing
            let (resultant_array, length) = try self.freezing_calculator()
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

        return []
    }

}
