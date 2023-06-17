//
//  HomeView.swift
//  LyoPronto
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    @State var selectedImage: Image = Image("")
    @State var showImageViewer: Bool = false
    
    private var resourceImages: [ImageClass] = [
        ImageClass(name: "best_practices_1", caption: "Recommended Best Practices for Lyophilization Validation: Process Design and Modeling"),
        ImageClass(name: "best_practices_2", caption: "Recommended Best Practices for Lyophilization Validation: Process Qualification and Continued Process Verification")
    ]
    
    private var resourcesByYear: [ResourcesByYear] = [
        ResourcesByYear(year: "2023", resources: [
            ResourceLink(label: "Recommended Best Practices for Equipment Performance Qualification", link: "https://link.springer.com/article/10.1208/s12249-023-02506-x", symbol: "doc.plaintext"),
            ResourceLink(label: "label1", link: "https://link.springer.com/article/10.1208/s12249-023-02506-x", symbol: "doc.plaintext")
        ]),
        
        ResourcesByYear(year: "2021", resources: [
            ResourceLink(label: "Recommended Best Practices for Equipment Performance Qualification", link: "https://link.springer.com/article/10.1208/s12249-023-02506-x", symbol: "doc.plaintext"),
            ResourceLink(label: "label1", link: "https://link.springer.com/article/10.1208/s12249-023-02506-x", symbol: "doc.plaintext")
        ]),
        ResourcesByYear(year: "2022", resources: [
            ResourceLink(label: "Annual Report – 2022", link: "https://pharmahub.org/resources/991/download/LyoHUB_2022_Annual_Report_DIGITAL_FINAL_25Jul2022a.pdf", symbol: "doc.plaintext"),
            ResourceLink(label: "Recommended Best Practices and Guidelines for Scale Up and Tech Transfer in Freeze-Drying based on case studies. Part 1: Challenges during scale up and transfer", link: "https://pubmed.ncbi.nlm.nih.gov/36451057/", symbol: "doc.plaintext"),
            ResourceLink(label: "Recommended Best Practices for Lyophilization Validation: Process Design and Modeling", link: "https://pubmed.ncbi.nlm.nih.gov/34409506/", symbol: "doc.plaintext"),
            ResourceLink(label: "Recommended Best Practices for Lyophilization Validation: Process Qualification and Continued Process Verification", link: "https://pubmed.ncbi.nlm.nih.gov/34750693/", symbol: "doc.plaintext"),
        ]),
        ResourcesByYear(year: "2019", resources: [
            ResourceLink(label: "LyoPRONTO: an Open-Source Lyophilization Process Optimization Tool", link: "https://link.springer.com/article/10.1208/s12249-019-1532-7", symbol: "doc.plaintext")
        ]),
        ResourcesByYear(year: "2017", resources: [
            ResourceLink(label: "Recommended Best Practices for Process Monitoring Instrumentation in Pharmaceutical Freeze Drying—2017", link: "https://pubmed.ncbi.nlm.nih.gov/28205144/", symbol: "doc.plaintext")
        ])
        
    ]
    
    private var BGopacity = 0.15
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.white.opacity(0.0)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            //LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.1), .green.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).opacity(0.4), Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).opacity(0.3)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            //Color.white.opacity(0.35)
            //    .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(showsIndicators: false) {
                if isiPad() {
                    Image("home-image-2")
                        .resizable()
                        .scaledToFill()
                        //.frame(width: UIScreen.main.bounds.width/2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedImage = Image("home-image-2")
                            showImageViewer = true
                        }
                } else {
                    Image("home-image-2")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(5)
                        .onTapGesture {
                            selectedImage = Image("home-image-2")
                            showImageViewer = true
                        }
                }
                Spacer()
                    .frame(height: 30)
                AboutSection
                    .padding(.horizontal)
                Spacer()
                    .frame(height: 30)
                ResourcesLinkSection
                    .padding(.horizontal)
            }
            .padding(.top, 1)
            //.navigationTitle("Home")
            .fullScreenCover(isPresented: $showImageViewer) {
                ImageViewer(image: self.$selectedImage, viewerShown: self.$showImageViewer)
            }
            
        }
        
        
    }
    
    private var AboutSection: some View {
        ZStack(alignment: .topLeading) {
            
            Color.white.opacity(0.8)
                //.frame(width: .infinity, height: 250)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
                .blur(radius: 1)
                
            VStack(alignment: .leading, spacing: 16) {
                Text("About")
                    .font(.system(size:24, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("The Advanced Lyophilization Technology Hub (LyoHUB) is an industry-driven consortium at Purdue University that is advancing the science and technology of lyophilization to lower costs and improve the availability of lyophilized products. Our member companies span the entire lyophilization ecosystem, from equipment vendors to pharmaceutical manufacturers. Together, we combine our expertise and resources to:")
                    .multilineTextAlignment(.leading)
                    //.padding(.top, 2)
                
                Text("1. Conduct applied research to improve and optimize processes, technologies, and products in the field of lyophilization.")
                    .multilineTextAlignment(.leading)
                
                Text("2. Identify and disseminate best practices for pharmaceutical manufacturing, equipment performance, testing, and process validation.")
                    .multilineTextAlignment(.leading)
                
                Text("3. Provide training, education, and learning resources for students and professionals in the field of lyophilization.")
                    .multilineTextAlignment(.leading)
                
                Link(destination: URL(string: "https://pharmahub.org/groups/lyo")!, label: {
                    Label("Go to Lyohub.org", systemImage: "paperplane")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                        
                })
            }
            //.frame(width: .infinity, height: 250)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.all)
            .foregroundColor(Color.black.opacity(0.8))
//            .background {
//                RoundedRectangle(cornerRadius: 12)
//                    .foregroundColor(.gray.opacity(BGopacity))
//            }
        }
    }
    
    private var MissionSection: some View {
//        VStack {
//            Text("Mission")
//                .font(.title2)
//                .fontWeight(.bold)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            Text("The goal of Advanced Lyophilization Technology Hub (LyoHub) is to advance the science and technology of freeze-drying/lyophilization. LyoHub’s members include companies in the pharmaceutical and food processing sectors, equipment manufacturers and university researchers, who combine their expertise and resources to accomplish the goal.")
//                .multilineTextAlignment(.leading)
//                .padding(.top, 2)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            Text("\nImmediate objectives are:\n")
//                .multilineTextAlignment(.leading)
//                .fontWeight(.medium)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            Text("• to identify and disseminate Best Practices for lyophilization equipment performance, testing and validation. \n• to conduct applied research to advance lyophilization processes and products.")
//                .multilineTextAlignment(.leading)
//                .frame(maxWidth: .infinity, alignment: .leading)
//        }
//        .padding(.all)
//        .background {
//            RoundedRectangle(cornerRadius: 12)
//                .foregroundColor(.gray.opacity(BGopacity))
//        }
        
        ZStack(alignment: .topLeading) {
            
            Color.black.opacity(0.35)
                //.frame(width: .infinity, height: 250)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: 10)
                .blur(radius: 1)
                
            VStack(alignment: .leading, spacing: 16) {
                Text("Mission")
                    .font(.system(size:24, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("The goal of Advanced Lyophilization Technology Hub (LyoHub) is to advance the science and technology of freeze-drying/lyophilization. LyoHub’s members include companies in the pharmaceutical and food processing sectors, equipment manufacturers and university researchers, who combine their expertise and resources to accomplish the goal.")
                    .multilineTextAlignment(.leading)
                    //.padding(.top, 2)
            }
            //.frame(width: .infinity, height: 250)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.all)
            .foregroundColor(Color.black.opacity(0.8))
        }
        
    }
    
    
    
    private var ResourcesLinkSection: some View {
        ZStack(alignment: .topLeading) {
            
            Color.white.opacity(0.8)
                //.frame(width: .infinity, height: 250)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
                .blur(radius: 1)
                
            VStack(alignment: .leading, spacing: 16) {
                Text("Resources")
                    .font(.system(size:24, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                ScrollView(.vertical, showsIndicators: false){
                    VStack{
                        ForEach(resourcesByYear, id:\.self) { resources in
                            Spacer()
                                .frame(height: 20)
                            Text(resources.year)
                                .font(.system(size:18, weight: .bold, design: .rounded))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                                .frame(height: 10)
                            
                            ForEach(resources.resources, id:\.self) { resource in
                                
                                Link(destination: URL(string: resource.link)!, label: {
                                    Label(resource.label, systemImage: resource.symbol)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    
                                })
                                
                                Spacer()
                                    .frame(height: 10)
                                
                            }
                            
                        }
                    }

                    
                }
            }
            //.frame(width: .infinity, height: 250)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.all)
            .foregroundColor(Color.black.opacity(0.8))
//            .background {
//                RoundedRectangle(cornerRadius: 12)
//                    .foregroundColor(.gray.opacity(BGopacity))
//            }
        }
    }
    
    
    
    
    private var ResourcesSection: some View {
//        VStack {
//            Text("Resources")
//                .font(.title2)
//                .fontWeight(.bold)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            Text("Recommended Best Practices for Lyophilization Validation: Process Design and Modeling")
//                .font(.title3)
//                .fontWeight(.semibold)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.top, 2)
//            if isiPad() {
//                Image("best_practices_1")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: UIScreen.main.bounds.width/2)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .onTapGesture {
//                        selectedImage = Image("best_practices_1")
//                        showImageViewer = true
//                    }
//            } else {
//                Image("best_practices_1")
//                    .resizable()
//                    .scaledToFit()
//                    .onTapGesture {
//                        selectedImage = Image("best_practices_1")
//                        showImageViewer = true
//                    }
//            }
//            Text("Recommended Best Practices for Lyophilization Validation: Process Qualification and Continued Process Verification")
//                .font(.title3)
//                .fontWeight(.semibold)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.top, 2)
//            if isiPad() {
//                Image("best_practices_2")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: UIScreen.main.bounds.width/2)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .onTapGesture {
//                        selectedImage = Image("best_practices_2")
//                        showImageViewer = true
//                    }
//            } else {
//                Image("best_practices_2")
//                    .resizable()
//                    .scaledToFit()
//                    .onTapGesture {
//                        selectedImage = Image("best_practices_2")
//                        showImageViewer = true
//                    }
//            }
//        }
//        .padding(.all)
//        .background {
//            RoundedRectangle(cornerRadius: 12)
//                .foregroundColor(.gray.opacity(BGopacity))
//        }
        
        ZStack(alignment: .topLeading) {
            
            Color.white.opacity(0.35)
                //.frame(width: .infinity, height: 250)
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: 10)
                .blur(radius: 1)
                
            VStack(alignment: .leading, spacing: 16) {
                Text("Resources")
                    .font(.system(size:24, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView(.vertical, showsIndicators: false){
                    //HStack{
                        ForEach(resourceImages, id:\.self) { image in
                            VStack{
                                if isiPad() {
                                    Image(image.name)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width/2)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .cornerRadius(5)
                                        .onTapGesture {
                                            selectedImage = Image(image.name)
                                            showImageViewer = true
                                        }
                                } else {
                                    Image(image.name)
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(5)
                                        .onTapGesture {
                                            selectedImage = Image(image.name)
                                            showImageViewer = true
                                        }
                                }
                            }
                            
                        }
                    //}
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 260)
            .padding(.all)
            .foregroundColor(Color.black.opacity(0.8))
        }
        
        
        
        
        
        
    }
    
    private var LyoProntoSection: some View {
//        VStack {
//            Text("LyoPronto")
//                .font(.title2)
//                .fontWeight(.bold)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            Text("LyoPronto, is a free, open source, user-friendly lyophilization simulation and process optimization tool. It includes freezing, primary drying modeling, and optimization modules, as well as a design space generator. LyoPronto can be used to model the lyophilization process and create more efficient cycles. The tool also can determine the vial heat transfer parameters and product resistance characteristics, thus reducing the number of experiments.")
//                .multilineTextAlignment(.leading)
//                .padding(.top, 2)
//            Text("Access this tool by navigating to the Calculators section of this app.")
//                .multilineTextAlignment(.leading)
//                .foregroundColor(.blue)
//                .padding(.top, 2)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            if isiPad() {
//                Image("lyopronto")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: UIScreen.main.bounds.width/2)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .onTapGesture {
//                        selectedImage = Image("lyopronto")
//                        showImageViewer = true
//                    }
//            } else {
//                Image("lyopronto")
//                    .resizable()
//                    .scaledToFit()
//                    .onTapGesture {
//                        selectedImage = Image("lyopronto")
//                        showImageViewer = true
//                    }
//            }
//        }
//        .padding(.all)
//        .background {
//            RoundedRectangle(cornerRadius: 12)
//                .foregroundColor(.gray.opacity(BGopacity))
//        }
        
        ZStack(alignment: .topLeading) {
            
            Color.white.opacity(0.35)
            //.frame(width: .infinity, height: 250)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: 10)
                .blur(radius: 1)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("LyoPronto")
                    .font(.system(size:24, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("LyoPronto, is a free, open source, user-friendly lyophilization simulation and process optimization tool. It includes freezing, primary drying modeling, and optimization modules, as well as a design space generator. LyoPronto can be used to model the lyophilization process and create more efficient cycles.")
                    .multilineTextAlignment(.leading)
                //.padding(.top, 2)
                
                Link(destination: URL(string: "https://link.springer.com/article/10.1208/s12249-019-1532-7")!, label: {
                    Label("Checkout Lyopronto's Paper", systemImage: "doc.plaintext")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                        
                })
            }
            //.frame(width: .infinity, height: 250)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.all)
            .foregroundColor(Color.black.opacity(0.8))
        }
    }
    
    private func isiPad() -> Bool {
        switch sizeClass {
        case .regular:
            return true
        default:
            return false
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
