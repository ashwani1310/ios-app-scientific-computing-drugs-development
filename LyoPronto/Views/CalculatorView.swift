//
//  CalculatorRootView.swift
//  LyoPronto
//

import SwiftUI


enum CalculatorListEnum: String,CaseIterable {
    
	case PrimaryDrying =  "Primary Drying"
    case DesignSpace = "Design Space"
	case FreezingCalculator = "Freezing Calculator"

	var id: String { return self.rawValue }
    
    @ViewBuilder
	var contentView: some View {
        switch self {
        case .PrimaryDrying:
            PrimaryDryCalculator(vm: .init(provider: CoreDataProvider.shared))
        case .DesignSpace:
            DesignSpaceCalculator(vm: .init(provider: CoreDataProvider.shared))
        case .FreezingCalculator:
            FreezingRoot(vm: .init(provider: CoreDataProvider.shared))
        }
	}
}

struct CalculatorView: View {
    
    @AppStorage("HideTabBar") var hideTabBar: Bool = false

    var body: some View {
            List {
                Section {
                    ForEach(CalculatorListEnum.allCases, id: \.rawValue) { item in
                        NavigationLink(item.rawValue) {
                            item.contentView
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.all)
                .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                .font(.headline)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
                
                Section {
                    Text("LyoPRONTO: Lyophilization Process Optimization Tool")
                        .font(.system(size:16, weight: .bold, design: .rounded))
                    
                    Text("This tool comprises of freezing and primary drying calculators, a design space generator, and a primary drying optimizer. The freezing calculator performs 0D lumped capacitance modeling to predict the product temperature variation with time which shows reasonably good agreement with experimental measurements. The primary drying calculator performs 1D heat and mass transfer analysis is a vial and predicts the drying time with an average deviation of 3% from experiments. The calculator is also extended to generate a design space over a range of chamber pressures and shelf temperatures to predict the most optimal setpoints for operation.")
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.black.opacity(0.6))
            }
            .onAppear {
                hideTabBar = false
            }
    }
}
