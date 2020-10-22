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
    
    
    
    var caseName: String {
        return Mirror(reflecting: self).children.first?.label ?? String(describing: self)
    }
}

struct CueDetailTrackDescriptionCell: View {
    @Binding var track: CSTrack
    
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
                    Text("\(track.title)")
                }
            }
            Button(action: {
                edit(.trackNum)
            }) {
                HStack {
                    Text("Track Num")
                    Spacer()
                    Text("\(track.trackNum)")
                }
            }
            Button(action: {
                edit(.isrc)
            }) {
                HStack {
                    Text("ISRC")
                    Spacer()
                    Text("\(track.isrc)")
                }
            }
            Button(action: {
                edit(.performer)
            }) {
                HStack {
                    Text("Performer")
                    Spacer()
                    Text("\(track.performer)")
                }
            }
            Button(action: {
                edit(.trackType)
            }) {
                HStack {
                    Text("Track Type")
                    Spacer()
                    Text("\(track.trackType)")
                }
            }
            Button(action: {
                edit(.songWriter)
            }) {
                HStack {
                    Text("Song Writer")
                    Spacer()
                    Text("\(track.songWriter)")
                }
            }
        }
    }
}
