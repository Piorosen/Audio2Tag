//
//  CueSheetTrackView.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/06.
//

import SwiftUI
import SwiftCueSheet

struct CueSheetTrackView: View {
    @Binding var track: CueSheetTrack
    
    var body: some View {
        Form {
            Section(header: Text("Detail")) {
                HStack {
                    Text("Title")
                    Spacer()
                    Text(String(track.trackNum))
                }
                
                HStack {
                    Text("Track Number")
                    Spacer()
                    Text(String(track.trackNum))
                }
                HStack {
                    Text("Track Type")
                    Spacer()
                    Text(String(track.trackType))
                }
            }
            
            Section(header: Text("Meta")) {
                ForEach(self.track.meta.sorted { $0.key.caseName.uppercased() < $1.key.caseName.uppercased() }) { meta in
                    Button(action: {
                        
                    }) {
                        HStack {
                            Text(meta.key.caseName.uppercased())
                            Spacer()
                            Text(meta.value)
                        }.foregroundColor(Color(UIColor.label))
                    }
                }
                AddButton("New") {

                }
            }
            Section(header: Text("Rem")) {
                ForEach(self.track.rem.sorted { $0.key.caseName.uppercased() < $1.key.caseName.uppercased() }) { rem in
                    Button(action: {

                    }) {
                        HStack {
                            Text(rem.key.caseName.uppercased())
                            Spacer()
                            Text(rem.value)
                        }.foregroundColor(Color(UIColor.label))
                    }
                }
                AddButton("New") {

                }
            }
            
            Section(header: Button(action: {
                
            }) {
                HStack {
                    Text("Time")
                    Spacer()
                    Text("Edit")
                }
            }) {
                HStack {
                    Text("Start")
                    Spacer()
                    Text(CSIndexTime(time: track.startTime).description)
                }
                HStack {
                    Text("End")
                    Spacer()
                    Text(CSIndexTime(time: track.endTime).description)
                }
                HStack {
                    Text("Duration")
                    Spacer()
                    if (track.endTime < track.startTime) {
                        Text("Error")
                    }else {
                        Text(CSIndexTime(time: track.endTime - track.startTime).description)
                    }
                    
                }
                
                
            }
            
        }.navigationTitle(track.title)
    }
}
