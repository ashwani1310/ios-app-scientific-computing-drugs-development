//
//  InfoPage.swift
//  LyoPronto
//

import SwiftUI

struct InfoPage: View {
    
    @Binding var title: String
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                if title == DisplayNames.vial {
                    vialBody
                } else if title == DisplayNames.product {
                    productBody
                } else if title == DisplayNames.ht {
                    heatTransferBody
                } else if title == DisplayNames.pchamber {
                    chamberPressureBody
                } else if title == DisplayNames.tshelf {
                    shelfTempBody
                } else if title == DisplayNames.equipcapability {
                    equipCapabilityBody
                } else if title == DisplayNames.freezingProduct {
                    freezingProductBody
                } else if title == DisplayNames.history {
                    historyInfoBody
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Back")
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var vialBody: some View {
        ZStack(alignment: .topLeading) {
            
            Color.white.opacity(0.9)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
                .blur(radius: 0.5)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("In lyophilization, a vial is a small container made of glass or plastic that is used to hold the product being lyophilized. Following cycle completion, the vial is typically sealed with a rubber stopper and an aluminum crimp cap to prevent contamination and maintain the sterility of the product.")
                    .multilineTextAlignment(.leading)
                Text("1. Vial Area ")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Text("Refers to the cross-sectional area of the vial at the base.")
                        .multilineTextAlignment(.leading)
                Text("2. Product Area ")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Text("Refers to the cross-sectional area of the frozen product inside the vial.")
                        .multilineTextAlignment(.leading)
                Text("3. Fill Volume ")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Text("Refers to the amount of product that is placed inside the vial before lyophilization. The fill volume is typically expressed in milliliters or cubic centimeters.")
                        .multilineTextAlignment(.leading)
                Spacer()
                Text("Allowed Values: ").fontWeight(.bold) + Text("The values of vial area, product area, and fill volume must be greater than 0.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.all)
            .foregroundColor(Color.black.opacity(0.8))
        }
    }
    
    var productBody: some View {
        ZStack(alignment: .topLeading) {
            
            Color.white.opacity(0.9)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
                .blur(radius: 0.5)
            
            VStack(alignment: .leading, spacing: 16) {
                
                Text("1. Solid Content ")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Text("Refers to the amount or percentage of solid material present in a product before it is lyophilized. This solid material includes bulking agents, buffers, active pharmaceutical ingredients, etc.")
                    .multilineTextAlignment(.leading)
                
                Text("2. Critical Product Temperature ")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Text("Refers to the temperature at which the product begins to collapse or melt during the primary drying stage.")
                    .multilineTextAlignment(.leading)
                
                Text("3. Product Resistance ")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Text("𝑅𝑝 is the mass transfer resistance of the product, which quantifies how much the porous cake obstructs the flow of water vapor from underneath during primary drying. It is defined as the ratio of (pressure drop from sublimation front to chamber) times (product area) to (mass flow rate). Since a thicker porous cake obstructs flow more than a thinner one, 𝑅𝑝 generally increases as the dried layer height L increases. To capture this behavior throughout the drying process, it is calculated by Rp = R0 + A1*L / (1 + A2*L), where R0, A1, and A2 are determined experimentally for a given formulation (and freezing and drying conditions).")
                    .multilineTextAlignment(.leading)
                Spacer()
                Text("Allowed Values: ").fontWeight(.bold) + Text("Solid content must be a non-negative value. The product resistance values (R\u{2080}, A\u{2081}, A\u{2082}) must be non-negative.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.all)
            .foregroundColor(Color.black.opacity(0.8))
        }
    }
    
    var freezingProductBody: some View {
        ZStack(alignment: .topLeading) {
            
            Color.white.opacity(0.9)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
                .blur(radius: 0.5)
            
            VStack(alignment: .leading, spacing: 16) {
                
                Text("1. Solid Content ")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Text("Refers to the amount or percentage of solid material present in a product before it is lyophilized. This solid material includes bulking agents, buffers, active pharmaceutical ingredients, etc.")
                    .multilineTextAlignment(.leading)
                
                Text("2. Freezing Temperature ")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Text("Refers to the temperature at which the solution containing the material to be freeze-dried starts to freeze or solidify.")
                    .multilineTextAlignment(.leading)
                
                Text("3. Nucleation Temperature ")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Text("Refers to the temperature at which ice crystals begin to form in the solution.")
                    .multilineTextAlignment(.leading)
                Spacer()
                Text("Allowed Values: ").fontWeight(.bold) + Text("Solid content must be a non-negative value. Both freezing and nucleation temperature must be equal to or less than 0.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.all)
            .foregroundColor(Color.black.opacity(0.8))
        }
    }
    
    var heatTransferBody: some View {
        ZStack(alignment: .topLeading) {
            
            Color.white.opacity(0.9)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
                .blur(radius: 0.5)
            
            VStack(alignment: .leading, spacing: 16) {
            Text("Vial Heat Transfer ")
                .bold()
                .multilineTextAlignment(.leading)
            Text("The vial heat transfer coefficient, Kv, is the lumped heat transfer parameter for the single vial, which is defined as the ratio of heat flux to the temperature between the shelf and the vial. The mechanisms of heat transfer to vial are the conductive heat transfer due to contact between the vial and the shelf, the conduction through the gas between the vial bottom and the shelf, and radiative heat transfer from the top and bottom shelves. Radiative heat from the freeze- dryer walls, front door, neighboring vials, and shelf above can affect Kv, while the conduction through gas affects Kv to be a function of chamber pressure, P\u{1D04}h with three parameters K\u{1D04} [cal/s * K/cm\u{00B2}], K\u{1D18} [cal/s * K/cm\u{00B2} * 1/Torr], and K\u{1D05} [1/Torr]. \nKv = K\u{1D04} + K\u{1D18} * P\u{1D04}h / (1 + K\u{1D05} * P\u{1D04}h)")
                .multilineTextAlignment(.leading)
            Image("heat_transfer")
                .resizable()
                .scaledToFit()
            Spacer()
            Text("Allowed Values: ").fontWeight(.bold) + Text("The values of K\u{1D04}, K\u{1D18}, and K\u{1D05} must be greater than 0.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.all)
            .foregroundColor(Color.black.opacity(0.8))
        }
    }
    
    var chamberPressureBody: some View {
        ZStack(alignment: .topLeading) {
            
            Color.white.opacity(0.9)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
                .blur(radius: 0.5)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("The chamber pressure refers to the absolute pressure inside the lyophilization chamber during the drying process.")
                Text("1. Chamber Pressure Ramp Rate ")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Text("Refers to the rate at which the chamber pressure is increased or decreased during the lyophilization process.")
                        .multilineTextAlignment(.leading)
                Text("2. Chamber Pressure Setpoint ")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Text("Refers to the desired chamber pressure inside the lyophilization chamber.")
                        .multilineTextAlignment(.leading)
                Text("3. Chamber Pressure Hold Time ")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Text("Refers to the amount of time that the chamber pressure is maintained at the setpoint during the lyophilization process.")
                        .multilineTextAlignment(.leading)
                Spacer()
                Text("Allowed Values: ").fontWeight(.bold) + Text("Both ramp rate and hold time values should be non-negative. The setpoint is allowed to vary from 0 to 2000.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.all)
            .foregroundColor(Color.black.opacity(0.8))
        }
    }
    
    var shelfTempBody: some View {
        ZStack(alignment: .topLeading) {
            
            Color.white.opacity(0.9)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
                .blur(radius: 0.5)
            
            VStack(alignment: .leading, spacing: 16) {
                Group{
                    Text("The shelf temperature refers to the temperature of the shelves on which the product is placed during the lyophilization process.")
                    Text("1. Shelf Temperature Ramp Rate ")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    Text("Refers to the rate at which the shelf temperature is increased or decreased during the heating phase of the lyophilization process.")
                        .multilineTextAlignment(.leading)
                    Text("2. Initial Shelf Temperature ")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    Text("Refers to the temperature of the shelves at the onset of primary drying.")
                        .multilineTextAlignment(.leading)
                    Text("3. Shelf Temperature Setpoint ")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    Text("Refers to the desired temperature of the shelves during the lyophilization process.")
                        .multilineTextAlignment(.leading)
                    Text("4. Shelf Temperature Hold Time ")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    Text("Refers to the amount of time that the shelf temperature is maintained at the setpoint during the lyophilization process.")
                        .multilineTextAlignment(.leading)
                }
                Group{
                    Spacer()
                    Text("Allowed Values: ").fontWeight(.bold) + Text("Both ramp rate and hold time values should be non-negative. The setpoint is allowed to vary from -60 to 60.")
                }
               
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.all)
            .foregroundColor(Color.black.opacity(0.8))
        }
    }
    
    var equipCapabilityBody: some View {
        ZStack(alignment: .topLeading) {
            
            Color.white.opacity(0.9)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
                .blur(radius: 0.5)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Equipment capability, a (kg/hr) and b (kg/hr*Torr), represents the maximum flow rate of vapor through the duct section. This correlation can be determined using experimental choked flow tests, minimum controllable pressure tests, or using computational fluid dynamics (CFD) modeling of choked flow through a lyophilizer.")
                        .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.all)
            .foregroundColor(Color.black.opacity(0.8))
        }
    }
    
    var historyInfoBody: some View {
        ZStack(alignment: .topLeading) {
            
            Color.white.opacity(0.9)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
                .blur(radius: 0.5)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Browse up to 30 recent entries here, while the older ones are automatically removed. To manually delete a specific entry, simply swipe left on it.")
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.all)
            .foregroundColor(Color.black.opacity(0.8))
        }
    }
    
    
}
