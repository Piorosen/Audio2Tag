//
//  SearchAlbumView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/08.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import SwiftVgmdb

struct TagSearchAlbumModalView: View {
    @Environment(\.presentationMode) private var mode
    let sender: VDSearchAnnotation
    @Binding var payback: VDTrack
    
    func close() {
            mode.wrappedValue.dismiss()
        
    }
    
    
    var body: some View {
        VStack{
            
            Button(action: self.close) {
                Text("dismiss")
            }
        }.frame(width: 400, height: 400)
    }
}
