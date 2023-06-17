//
//  NumericalSolver.swift
//  LyoPronto
//

import Foundation

class NumericalSolver {
	
		// -60 to 0 -> bracketed estimates || use (-60, 0) as intial guess and use the previous temp as initial guess for next iteration
	
		// Add/Subtract -5/-10 to the last iteration's value to get the new bounds.
	
	init() {}
	
    func secantSolver(x_values: [Double], tolerance_value: Double, additional_data: [String: Double], function: (Double, [String: Double]) -> Double) -> Double {
        
        var x_0 = x_values[0]
        var x_1 = x_values[1]
        
        var resultant_value = x_0
        
        var second_value = function(x_0, additional_data)
        var first_value = function(x_1, additional_data)
        
        for _ in 1...50{
            
            let step = -1.0*first_value*((x_1 - x_0)/(first_value-second_value))
            
            resultant_value = x_1 + step
        
            if (abs(step) <= abs(tolerance_value*resultant_value)){
                break
            }
         
            second_value = first_value
            first_value = function(resultant_value, additional_data)
            
            x_0 = x_1
            x_1 = resultant_value
        }
        
        return resultant_value
    }
	
}
