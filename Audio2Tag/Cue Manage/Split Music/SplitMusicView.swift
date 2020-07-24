//
//  SplitMusicView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/21.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct splitMusicModel : Identifiable {
    let id = UUID()
    let name: String
    var status: Int
}

struct SplitMusicView: View {
    @Binding var bind: [splitMusicModel]
    
    var body: some View {
        Group {
            Text("asdfasdf")
            List(bind, id: \.self.name) { value in
                Text("\(value.name) : \(String(format: "%d", value.status))")
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
    }
}

