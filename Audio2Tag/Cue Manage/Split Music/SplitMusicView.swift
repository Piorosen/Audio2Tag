//
//  SplitMusicView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/21.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct SplitMusicView: View {
    @Binding var bind: [(name:String, status:Float)]
    
    var body: some View {
        List(bind, id: \.self.name) { value in
            Text("\(value.name) : \(String(format: "%.0f", value.status * 100))")
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

