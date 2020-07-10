//
//  SearchAlbumView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/08.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import SwiftVgmdb

struct TagSearchAlbumModalModel : Identifiable {
    let id = UUID()
    let item: VDAlbum
}

struct TagSearchAlbumModalView: View {
    @Environment(\.presentationMode) private var mode
    let sender: [TagSearchAlbumModalModel]
    @Binding var payback: VDTrack
    
    init(sender: [VDAlbum], ret: Binding<VDTrack>) {
        self.sender = sender.map { item in TagSearchAlbumModalModel(item: item) }
        self._payback = ret
    }
    
    func close() {
            mode.wrappedValue.dismiss()
        
    }
    
    
    var body: some View {
        VStack{
            List (sender) { value in
                
                Text("\(value.item.albumTitle)")
            }
            Button(action: self.close) {
                Text("dismiss")
            }
        }.frame(width: 400, height: 400)
    }
}
