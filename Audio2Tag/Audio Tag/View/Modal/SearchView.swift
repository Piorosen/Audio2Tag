//
//  TagSearchModal.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/04.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import SwiftVgmdb

extension VDTrack {
    static func instance() -> VDTrack {
        return VDTrack(albumInfo: [VDTrackInfo:String](), trackInfo: [VDLangauge:[[String]]]())
    }
}

struct TagSearchModalView: View {
    @Environment(\.presentationMode) private var mode
    @ObservedObject var viewModel = testViewModel()
    
    class testViewModel : ObservableObject {
        @Published var isActive:Bool = false
        @Published var payback:VDTrack = VDTrack.instance()
        
        @Published var title = String()
        @Published var discNum = String()
        @Published var barcode = String()
        @Published var composer = String()
        @Published var artist = String()
        @Published var publisher = String()
        
        func next() {
            isActive = true
        }

        func makeQuary() -> VDSearchAnnotation {
            let title = self.title
            let discNum = self.discNum
            let barcode = self.barcode
            let composer = [self.composer]
            let artist = [self.artist]
            let publisher = [self.publisher]
            
            return VDSearchAnnotation(title: title, discNum: discNum, barcode: barcode, composer: composer, artist: artist, publisher: publisher)
        }
        
    }
    
    
    func close() {
        mode.wrappedValue.dismiss()
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
//                Text("Title")
                TextField("Title", text: self.$viewModel.title)
                
//                Text("Title")
                TextField("Disc Num", text: self.$viewModel.discNum)
                
//                Text("Title")
                TextField("Barcode", text: self.$viewModel.barcode)
                
//                Text("Title")
                TextField("Composer", text: self.$viewModel.composer)
                
//                Text("Title")
                TextField("Artist", text: self.$viewModel.artist)
                
//                Text("Title")
                TextField("Publisher", text: self.$viewModel.publisher)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color.red)
            
            
            HStack {
                Spacer()
                Button(action: self.viewModel.next) {
                    Text("Next")
                }.sheet(isPresented: self.$viewModel.isActive) {
                    TagSearchAlbumModalView(sender: self.viewModel.makeQuary(), payback: self.$viewModel.payback)
                }
                Button(action: self.close) {
                    Text("Close")
                }
            }.padding(.top, 10)
//                .background(Color.black)
            
        }
        .padding(10)
        .frame(width: 500, height: 250)
    }
}

struct TagSearchModal_Previews: PreviewProvider {
    static var previews: some View {
        TagSearchModalView()
    }
}
