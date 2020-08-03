//
//  ProgressScrollView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/04.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct ProgressScrollView: View {
    @Binding var bind: [SplitMusicModel]
    
    var body: some View {
        ScrollView {
            ForEach(self.bind) { value in
                Text("\(value.name) : \(value.status)")
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

