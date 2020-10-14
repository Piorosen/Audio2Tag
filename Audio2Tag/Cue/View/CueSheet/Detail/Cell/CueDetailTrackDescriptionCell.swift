//
//  CueDetailListInfoDescriptionSection.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/22.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct CueDetailTrackDescriptionCell: View {
    var track: TrackModel
    @State var openAlert = false
    
    var body: some View {
        Section(header: Text("Description")) {
            Button(action: {
                openAlert = true
            }) {
                HStack {
                    Text("Title")
                    Spacer()
                    Text("\(track.track.title)")
                }
            }
            Button(action: {
                openAlert = true
            }) {
                HStack {
                    Text("Track Num")
                    Spacer()
                    Text("\(track.track.trackNum)")
                }
            }
            Button(action: {
                openAlert = true
            }) {
                HStack {
                    Text("ISRC")
                    Spacer()
                    Text("\(track.track.isrc)")
                }
            }
            Button(action: {
                openAlert = true
            }) {
                HStack {
                    Text("Performer")
                    Spacer()
                    Text("\(track.track.performer)")
                }
            }
            Button(action: {
                openAlert = true
            }) {
                HStack {
                    Text("Track Type")
                    Spacer()
                    Text("\(track.track.trackType)")
                }
            }
            Button(action: {
                openAlert = true
            }) {
                HStack {
                    Text("Song Writer")
                    Spacer()
                    Text("\(track.track.songWriter)")
                }
            }
            
            
            
            
            
        }
    }
}
