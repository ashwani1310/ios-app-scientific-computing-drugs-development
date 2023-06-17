//
//  Functions.swift
//  LyoPronto
//

import Foundation

class Functions {
	
	init(){}
	
	func get_vapor_pressure(t_sub: Double) -> Double {
		return 2.698e10*(exp(-6144.96/(273.15+t_sub)))
	}
	
	func get_lpr0(vfill: Double, ap: Double, csolid: Double) -> Double {
		
		return vfill/(ap*Constants.rho_ice)*(1-csolid*(Constants.rho_solution-Constants.rho_ice)/Constants.rho_solute)
	}
	
	func get_kv(kc: Double, kp: Double, kd: Double, pch: Double) -> Double {
		
		return kc+kp*pch/(1.0+kd*pch)
	}
	
	func get_rp(length: Double, r0: Double, a1: Double, a2: Double) -> Double {
		
		return r0+a1*length/(1.0+a2*length)
	}
	
	func get_temp_sub_solver(t_sub: Double, data: [String: Double]) -> Double {
		
		let pch: Double! = data["pch"]
		let av: Double! = data["av"]
		let ap: Double! = data["ap"]
		let kv: Double! = data["kv"]
		let lpr0: Double! = data["lpr0"]
		let lck: Double! = data["lck"]
		let rp: Double! = data["rp"]
		let tsh: Double! = data["tsh"]
		
		
		let p_sub = self.get_vapor_pressure(t_sub: t_sub)
		
		let av_ap = av/ap*kv/Constants.k_ice*(lpr0-lck)+1
		
		return (p_sub - pch)*(av_ap)-av/ap*kv*rp*Constants.hr_to_s/Constants.dHs*(tsh-t_sub)
	}
	
	
	func get_sub_rate(ap: Double, rp: Double, t_sub: Double, pch: Double) -> Double {
		
		let vapor_pr = self.get_vapor_pressure(t_sub: t_sub)
		
		return ap/rp/Constants.kg_to_g*(vapor_pr-pch)
	}
	
	func get_temp_at_bottom(t_sub: Double, lpr0: Double, lck: Double, pch: Double, rp: Double) -> Double {
		
		let p_sub = self.get_vapor_pressure(t_sub: t_sub)
		
		let t_bot = t_sub + (lpr0-lck)*(p_sub-pch)*Constants.dHs/rp/Constants.hr_to_s/Constants.k_ice
		
		return t_bot
	}
	
    func get_lumped_cap_tpr(data: [String: Double]) -> Double {
        
        let time_in_hr:Double! = data["time"]
        let tpr0:Double! = data["tpr0"]
        let rho:Double! = data["rho"]
        let cp:Double! = data["cp"]
        let volume:Double! = data["volume"]
        let heat_coeff:Double! = data["heat_coeff"]
        let av:Double! = data["av"]
        let tsh:Double! = data["tsh"]
        let tsh0:Double! = data["tsh0"]
        let tsh_ramp:Double! = data["tsh_ramp"]
        
        let time_in_sec = time_in_hr*Constants.hr_to_s
        let cm_to_m_sq = pow(Constants.cm_to_m, 2)
        let diff_trp0_tsh0 = tpr0 + tsh_ramp/Constants.min_to_s*rho*cp/Constants.kg_to_g*volume/heat_coeff/av/cm_to_m_sq - tsh0
        let heat = exp(-heat_coeff*av*cm_to_m_sq*time_in_sec/rho/cp*Constants.kg_to_g/volume)
        let ramp = tsh_ramp/Constants.min_to_s*rho*cp/Constants.kg_to_g*volume/heat_coeff/av/cm_to_m_sq
        
        return diff_trp0_tsh0*heat - ramp + tsh
    }
    
    func get_crystallization_time(data: [String: Double]) -> Double {
        
        let volume:Double! = data["volume"]
        let heat_coeff:Double! = data["heat_coeff"]
        let av:Double! = data["av"]
        let freezing_temp:Double! = data["freezing_temp"]
        let nucleation_temp:Double! = data["nucleation_temp"]
        let shelf_temp:Double! = data["shelf_temp"]
        
        let freezing_nucleation_temp_diff = freezing_temp-nucleation_temp
        let freezing_shelf_temp_diff = freezing_temp-shelf_temp
        let eqn1 = Constants.dHf*Constants.cal_to_J-Constants.cp_solution/Constants.kg_to_g*freezing_nucleation_temp_diff
        let cm_to_m_sq = pow(Constants.cm_to_m, 2)
        
        return Constants.rho_solution*volume*eqn1/heat_coeff/Constants.hr_to_s/av/cm_to_m_sq/freezing_shelf_temp_diff
        
    }
    
    func get_list_of_rp_values(length: [Double], r0: Double, a1: Double, a2: Double) -> [Double] {

        var local_length_copy = length

        let a2_length = length.map{$0 * a2}
        let denoinator = a2_length.map{$0 + 1.0}
        for i in 0..<length.count{
            local_length_copy[i] = local_length_copy[i]/denoinator[i]
        }
        let a1_length = local_length_copy.map{$0 * a1}
        let rp_val = a1_length.map{$0 + r0}

        return rp_val

    }

    func get_temp_sub_from_tpr(t_sub: Double, data: [String: Double]) -> Double {

        let pch: Double! = data["pch"]
        let lpr0: Double! = data["lpr0"]
        let lck: Double! = data["lck"]
        let rp: Double! = data["rp"]
        let tbot: Double! = data["tbot"]


        let p_sub = self.get_vapor_pressure(t_sub: t_sub)

        return t_sub - tbot + (p_sub - pch)*(lpr0 - lck)*Constants.dHs/rp/Constants.hr_to_s/Constants.k_ice
    }

    func get_tbot_max_eq_cap(pch: Double, dm_dt: Double, lpr0: Double, lck: [Double], rp: [Double], ap: Double) -> Double {

        let dm_dt_by_ap = dm_dt/ap
        let dm_dt_ap_rp = rp.map{$0 * dm_dt_by_ap}
        let p_sub = dm_dt_ap_rp.map{$0 + pch}
        var p_sub_log = p_sub.map{$0 / 2.698e10}

        for i in 0..<p_sub_log.count {
            p_sub_log[i] = -6144.96/log(p_sub_log[i])
        }

        let t_sub = p_sub_log.map{$0 - 273.15}

        let lpr_lck = lck.map{$0 * -1 + lpr0}

        let p_sub_pch = p_sub.map{$0 - pch}

        var dhs_rp = rp

        for i in 0..<rp.count{
            dhs_rp[i] = Constants.dHs/dhs_rp[i]/Constants.hr_to_s/Constants.k_ice
        }

        var tbot = t_sub
        var max_tbot = Double(Int.min)
        for i in 0..<tbot.count{
            tbot[i] = tbot[i] + lpr_lck[i]*p_sub_pch[i]*dhs_rp[i]
            max_tbot = max(max_tbot, tbot[i])
        }

        return max_tbot
    }
    
}
