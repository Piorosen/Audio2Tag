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
//            Button(action: {
//                
//            }) {
//                HStack {
//                    Text("Meta 정보 추가")
//                    Spacer()
//                    Image(systemName: "plus")
//                }
//            }
        }
    }
}
