//
//  CueDetailListInfoDescriptionSection.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/22.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import SwiftCueSheet

enum CueDetailTrackDescription : Identifiable {
    var id: Int {
        self.hashValue
    }
    
    case title
    case trackNum
    case isrc
    case performer
    case trackType
    case songWriter
}

struct CueDetailTrackDescriptionCell: View {
    @Binding var track: TrackModel
    
    var edit: (CueDetailTrackDescription) -> Void = { _ in }
    func onEdit(_ action: @escaping (CueDetailTrackDescription) -> Void) -> CueDetailTrackDescriptionCell {
        var copy = self
        copy.edit = action
        return copy
    }
    
    var body: some View {
        Section(header: Text("Description")) {
            Button(action: {
                edit(.title)
            }) {
                HStack {
                    Text("Title")
                    Spacer()
                    Text("\(track.track.title)")
                }
            }
            Button(action: {
                edit(.trackNum)
            }) {
                HStack {
                    Text("Track Num")
                    Spacer()
                    Text("\(track.track.trackNum)")
                }
            }
            Button(action: {
                edit(.isrc)
            }) {
                HStack {
                    Text("ISRC")
                    Spacer()
                    Text("\(track.track.isrc)")
                }
            }
            Button(action: {
                edit(.performer)
            }) {
                HStack {
                    Text("Performer")
                    Spacer()
                    Text("\(track.track.performer)")
                }
            }
            Button(action: {
                edit(.trackType)
            }) {
                HStack {
                    Text("Track Type")
                    Spacer()
                    Text("\(track.track.trackType)")
                }
            }
            Button(action: {
                edit(.songWriter)
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
