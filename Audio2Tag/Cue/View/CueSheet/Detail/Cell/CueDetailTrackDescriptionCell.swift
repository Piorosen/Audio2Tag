//
//  CueDetailListInfoDescriptionSection.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/22.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct CueDetailListInfoDescriptionSection: View {
    var track: TrackModel
    @State var openAlert = false
    
    var body: some View {
        Section(header: Text("Description")) {
            HStack {
                Text("Title")
                Spacer()
                Text("\(track.track.title)")
            }
            HStack {
                Text("Track Num")
                Spacer()
                Text("\(track.track.trackNum)")
            }
            HStack {
                Text("ISRC")
                Spacer()
                Text("\(track.track.isrc)")
            }
            HStack {
                Text("Performer")
                Spacer()
                Text("\(track.track.performer)")
            }
            
            HStack {
                Text("Track Type")
                Spacer()
                Text("\(track.track.trackType)")
            }
            HStack {
                Text("Song Writer")
                Spacer()
                Text("\(track.track.songWriter)")
            }
            AddButton("META 추가") {
                openAlert = true
            }
        }.alert(isPresented: $openAlert) {
            Alert(title: Text("미 구현 입니다."))
        }
    }
}
