//
//  TagSearchModal.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/04.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import SwiftVgmdb

struct TagSearchModalView: View {
    @Environment(\.presentationMode) private var mode
    @ObservedObject var viewModel = TagSearchModalViewModel()
    
    
    @State var albumList = false
    @State var trackList = false
    
    
    func close() {
        mode.wrappedValue.dismiss()
    }
    

    var body: some View {
        VStack{
            if albumList {
                List (self.viewModel.albumList, id: \.id) { item in
                    Button(action: {self.viewModel.searchTrack(select: item); self.trackList = true; self.albumList = false}) {
                        Text("\(item.albumTitle)")
                    }
                }
            }
            else if trackList {
                List (self.viewModel.trackList, id: \.self) { item in
                    Text("\(item)")
                }
            }
            else {
                TextField("Title", text: self.$viewModel.searchTitle)
                Button(action: { self.albumList = true; self.viewModel.searchAlbum() }){
                    Text("Next")
                }
            }
            Button(action: self.close) {
                Text("dismiss")
            }
        }.frame(width: 400, height: 400)
    }
}

struct TagSearchModal_Previews: PreviewProvider {
    static var previews: some View {
        TagSearchModalView()
    }
}
