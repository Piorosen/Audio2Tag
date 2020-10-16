//
//  SplitMusicCell.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/06.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct CueSplitCellView: View {
    @Binding var bind: SplitMusicModel
//    @State private var progress = Progress()
    
    var body: some View {
        VStack {
            Text("\(bind.name)")
                .frame(maxWidth: .infinity, alignment: .leading)
            ProgressView(value: Float(bind.status), total: 100)
//            ProgressBar(value: self.$bind.status)
        }.padding(10)
    }
}

