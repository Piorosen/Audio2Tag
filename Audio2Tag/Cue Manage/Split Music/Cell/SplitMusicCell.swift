//
//  SplitMusicCell.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/06.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct SplitMusicCell: View {
    @Binding var bind: SplitMusicModel
    
    var body: some View {
        VStack {
            Text("\(bind.name)")
            ProgressBar(value: self.bind.$status)
        }.padding(10)
    }
}

