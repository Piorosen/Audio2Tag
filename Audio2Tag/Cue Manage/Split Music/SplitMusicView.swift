//
//  SplitMusicView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/21.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI



struct SplitMusicView: View {
    @Binding var bind: [SplitMusicModel]
    
    var body: some View {
        Group {
            List(bind, id: \.self.name) { value in
                VStack {
                    Text("\(value.name) \(value.status)")
                    
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
    }
}

