//
//  GalleryView.swift
//  LyoPronto
//

import SwiftUI


struct PhotoView: View {
    
    let photo: Photo
    
    var body: some View {
        VStack {
            Link(destination: URL(string: photo.url)!) {
                Image(photo.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(5)
            }
        }
        .padding()
    }
    
}

/*
struct GalleryView: View {
   
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    @State var selectedImage: Image = Image("")
    @State var showImageViewer: Bool = false
    
    let colGrid = [GridItem(.adaptive(minimum: 300), spacing: 10)]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white.opacity(0.8)
                //.frame(width: .infinity, height: 250)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
                .blur(radius: 1)
            
            List {
                Section("Members Since 2014") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: isiPad() ? 300 : 140), spacing: isiPad() ? 10 : 0)]) {
                        ForEach(0..<2) { index in
                            Image("\(index)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: isiPad() ? 300 : 150, height: isiPad() ? 300 : 130)
                                .cornerRadius(12)
                                .padding(.bottom, isiPad() ? 30 : 10)
                                .onTapGesture {
                                    selectedImage = Image("\(index)")
                                    showImageViewer = false
                                }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
                
                Section("Members Since 2015") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: isiPad() ? 300 : 140), spacing: isiPad() ? 10 : 0)]) {
                        ForEach(2..<5) { index in
                            Image("\(index)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: isiPad() ? 300 : 150, height: isiPad() ? 300 : 130)
                                .cornerRadius(12)
                                .padding(.bottom, isiPad() ? 30 : 10)
                                .onTapGesture {
                                    selectedImage = Image("\(index)")
                                    showImageViewer = false
                                }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 10)
                
                Section("Members Since 2016") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: isiPad() ? 300 : 140), spacing: isiPad() ? 10 : 0)]) {
                        ForEach(5..<10) { index in
                            Image("\(index)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: isiPad() ? 300 : 150, height: isiPad() ? 300 : 130)
                                .cornerRadius(12)
                                .padding(.bottom, isiPad() ? 30 : 10)
                                .onTapGesture {
                                    selectedImage = Image("\(index)")
                                    showImageViewer = true
                                }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 10)
                
                Section("Members Since 2017") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: isiPad() ? 300 : 140), spacing: isiPad() ? 10 : 0)]) {
                        ForEach(10..<13) { index in
                            Image("\(index)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: isiPad() ? 300 : 150, height: isiPad() ? 300 : 130)
                                .cornerRadius(12)
                                .padding(.bottom, isiPad() ? 30 : 10)
                                .onTapGesture {
                                    selectedImage = Image("\(index)")
                                    showImageViewer = false
                                }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
                
                Section("Members Since 2018") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: isiPad() ? 300 : 140), spacing: isiPad() ? 10 : 0)]) {
                        ForEach(13..<15) { index in
                            Image("\(index)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: isiPad() ? 300 : 150, height: isiPad() ? 300 : 130)
                                .cornerRadius(12)
                                .padding(.bottom, isiPad() ? 30 : 10)
                                .onTapGesture {
                                    selectedImage = Image("\(index)")
                                    showImageViewer = false
                                }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
                
                Section("Members Since 2019") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: isiPad() ? 300 : 140), spacing: isiPad() ? 10 : 0)]) {
                        ForEach(15..<19) { index in
                            Image("\(index)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: isiPad() ? 300 : 150, height: isiPad() ? 300 : 130)
                                .cornerRadius(12)
                                .padding(.bottom, isiPad() ? 30 : 10)
                                .onTapGesture {
                                    selectedImage = Image("\(index)")
                                    showImageViewer = true
                                }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
                
                Section("Members Since 2020") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: isiPad() ? 300 : 140), spacing: isiPad() ? 10 : 0)]) {
                        ForEach(19..<21) { index in
                            Image("\(index)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: isiPad() ? 300 : 150, height: isiPad() ? 300 : 130)
                                .cornerRadius(12)
                                .padding(.bottom, isiPad() ? 30 : 10)
                                .onTapGesture {
                                    selectedImage = Image("\(index)")
                                    showImageViewer = true
                                }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
                
                Section("Members Since 2021") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: isiPad() ? 300 : 140), spacing: isiPad() ? 10 : 0)]) {
                        ForEach(21..<25) { index in
                            Image("\(index)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: isiPad() ? 300 : 150, height: isiPad() ? 300 : 130)
                                .cornerRadius(12)
                                .padding(.bottom, isiPad() ? 30 : 10)
                                .onTapGesture {
                                    selectedImage = Image("\(index)")
                                    showImageViewer = true
                                }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 10)
                
                Section("Members Since 2022") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: isiPad() ? 300 : 140), spacing: isiPad() ? 10 : 0)]) {
                        ForEach(25..<29) { index in
                            Image("\(index)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: isiPad() ? 300 : 150, height: isiPad() ? 300 : 130)
                                .cornerRadius(12)
                                .padding(.bottom, isiPad() ? 30 : 10)
                                .onTapGesture {
                                    selectedImage = Image("\(index)")
                                    showImageViewer = true
                                }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 10)
                
            }
            .fullScreenCover(isPresented: $showImageViewer) {
                ImageViewer(image: self.$selectedImage, viewerShown: self.$showImageViewer)
            }
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
*/





struct GalleryView: View {
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    private var photos: [Photo] = [
        Photo(name: "Photo1", imageName: "0", year: "2014", url: "https://ima.it/pharma/brands/ima-life/"),
        Photo(name: "Photo1", imageName: "3", year: "2015", url: "https://ima.it/pharma/brands/ima-life/"),
        Photo(name: "Photo2", imageName: "32", year: "2014", url: "https://www.pfizer.com/"),
        Photo(name: "Photo3", imageName: "2", year: "2015", url: "https://www.janssen.com/"),
        Photo(name: "Photo4", imageName: "3", year: "2015", url: "https://www.millrocktech.com/"),
        Photo(name: "Photo1", imageName: "4", year: "2015", url: "https://www.inficon.com/en"),
        Photo(name: "Photo2", imageName: "5", year: "2016", url: "https://www.scientificproducts.com/"),
        Photo(name: "Photo3", imageName: "6", year: "2016", url: "https://www.baxter.com/"),
        Photo(name: "Photo4", imageName: "7", year: "2016", url: "https://www.abbvie.com/"),
        Photo(name: "Photo1", imageName: "8", year: "2016", url: "https://www.abbvie.com/allergan.html"),
        Photo(name: "Photo2", imageName: "9", year: "2016", url: "https://www.roche.com/"),
        Photo(name: "Photo3", imageName: "10", year: "2017", url: "https://www.siemens.com/global/en.html"),
        Photo(name: "Photo4", imageName: "11", year: "2017", url: "https://www.fresenius-kabi.com/"),
        Photo(name: "Photo1", imageName: "12", year: "2017", url: "https://www.bms.com/"),
        Photo(name: "Photo2", imageName: "13", year: "2018", url: "https://www.optima-packaging.com/en-us/pharma"),
        Photo(name: "Photo3", imageName: "14", year: "2018", url: "https://www.amgen.com/"),
        Photo(name: "Photo4", imageName: "15", year: "2019", url: "https://www.astrazeneca.com/"),
        Photo(name: "Photo1", imageName: "16", year: "2019", url: "https://corporate.evonik.com/en"),
        Photo(name: "Photo2", imageName: "17", year: "2019", url: "https://www.daiichisankyo.com/"),
        Photo(name: "Photo3", imageName: "18", year: "2019", url: "https://www.cookbiotech.com/"),
        Photo(name: "Photo4", imageName: "19", year: "2020", url: "https://www.corning.com/worldwide/en/products/pharmaceutical-technologies.html"),
        Photo(name: "Photo1", imageName: "20", year: "2020", url: "https://www.sanofi.us/"),
        Photo(name: "Photo2", imageName: "31", year: "2021", url: "https://www.merck.com/"),
        Photo(name: "Photo3", imageName: "22", year: "2021", url: "https://www.fujifilm.com/us/en"),
        Photo(name: "Photo4", imageName: "23", year: "2021", url: "https://www.elanco.com/en-us"),
        Photo(name: "Photo4", imageName: "24", year: "2021", url: "https://www.jazzpharma.com/"),
        Photo(name: "Photo2", imageName: "25", year: "2022", url: "https://www.metrohm.com/en_us.html"),
        Photo(name: "Photo3", imageName: "26", year: "2022", url: "http://www.psicorp.com/"),
        Photo(name: "Photo4", imageName: "27", year: "2022", url: "https://www.regeneron.com/"),
        Photo(name: "Photo4", imageName: "28", year: "2022", url: "https://www.westpharma.com/"),
        Photo(name: "Photo4", imageName: "29", year: "2023", url: "https://www.tempris.com/"),
        Photo(name: "Photo4", imageName: "30", year: "2019", url: "https://www.emdserono.com/us-en"),
        Photo(name: "Photo4", imageName: "31", year: "2023", url: "https://www.emdserono.com/us-en")
    ]

    /*
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    let years = Set(photos.map { $0.year }).sorted()
                    ForEach(years, id: \.self) { year in
                        Section(header: Text("\(year)")) {
                            let yearPhotos = photos.filter { $0.year == year }
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                                ForEach(yearPhotos) { photo in
                                    PhotoView(photo: photo)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Image Gallery")
        }
    }*/
    private var years: [String] {
            Set(photos.map { $0.year }).sorted()
    }

    private func yearPhotos(_ year: String) -> [Photo] {
        photos.filter { $0.year == year }
    }

    private func gridSection(year: String) -> some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 20)
            Text("Members since \(year)")
                .padding(.leading)
                .font(.system(size:24, weight: .bold, design: .rounded))
                //.foregroundColor(Color.black.opacity(0.8))
                .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))

            LazyVGrid(columns: [GridItem(.adaptive(minimum: isiPad() ? 200 : 150 ))]) {
                ForEach(yearPhotos(year)) { photo in
                    PhotoView(photo: photo)
                }
            }
        }
        .padding(.bottom)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
                .shadow(color: Color.blue.opacity(0.2), radius: 10, x: 0, y: 5)
                .blur(radius: 1)
        )
        .padding()
    }

    var body: some View {
        ZStack{
            ScrollView {
                LazyVStack {
                    ForEach(years, id: \.self) { year in
                        gridSection(year: year)
                    }
                }
            }
            .padding(.top, 1)
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
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



struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}
