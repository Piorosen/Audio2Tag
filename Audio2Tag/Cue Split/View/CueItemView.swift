//
//  CueItemView.swift
//  Audio2Tag
//
//  Created by Mac13 on 2020/06/29.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct CueItemView: View {
    let item: CueModel
    
    var body: some View {
        HStack {
            Text("\(item.index)")
            VStack {
                Text("Title \(item.fileName)")
                Text("Artist \(item.artist)")
            }
            Spacer()
            Text("Length of Music : \(String(format: "%.2f 초", item.duration))")
            Text("Length of Index : \(String(format: "%.2f 초", item.interval))")
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct CueItemView_Previews: PreviewProvider {
    static var previews: some View {
        CueItemView(item: CueModel(index: 0, fileName: "aa", artist: "artist", duration: 551.234, interval: 1234.55))
    }
}
