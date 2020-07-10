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
    @ObservedObject var viewModel = TagSearchModalViewModel()
    
    
    
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
                }.sheet(isPresented: self.$viewModel.isActivity) {
                    TagSearchAlbumModalView(sender: self.viewModel.param, ret: self.$viewModel.payback).animation(.spring())
                }
                Button(action: self.close) {
                    Text("Close")
                }
            }.padding(.top, 10)
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
