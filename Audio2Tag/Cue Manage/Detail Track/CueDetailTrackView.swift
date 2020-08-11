//
//  CueDetailTrackView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/19.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI


struct CueDetailTrackView: View {
    @ObservedObject var viewModel: CueDetailTrackViewModel
    
    init(_ item: TrackModel) {
        viewModel = CueDetailTrackViewModel(item: item)
    }
    
    var body: some View {
        List {
            Section(header: Text("Description")) {
                HStack {
                    Text("Title")
                    Spacer()
                    Text("\(self.viewModel.item.track.title)")
                }
                HStack {
                    Text("Track Num")
                    Spacer()
                    Text("\(self.viewModel.item.track.trackNum)")
                }
                HStack {
                    Text("ISRC")
                    Spacer()
                    Text("\(self.viewModel.item.track.isrc)")
                }
                HStack {
                    Text("Performer")
                    Spacer()
                    Text("\(self.viewModel.item.track.performer)")
                }
                
                HStack {
                    Text("Track Type")
                    Spacer()
                    Text("\(self.viewModel.item.track.trackType)")
                }
                HStack {
                    Text("Song Writer")
                    Spacer()
                    Text("\(self.viewModel.item.track.songWriter)")
                }
            }
            Section(header: Text("Rem")) {
                ForEach (self.viewModel.rem) { item in
                    HStack {
                        Text("\(item.value.key)")
                        Spacer()
                        Text("\(item.value.value)")
                    }
                }
            }
            
            Section(header: Text("Time Info")) {
                HStack {
                    Text("Start Time")
                    Spacer()
                    Text(self.viewModel.startTime)
                }
                HStack {
                    Text("End Time")
                    Spacer()
                    Text(self.viewModel.endTime)
                }
                HStack {
                    Text("Wait Time")
                    Spacer()
                    Text(self.viewModel.waitTime)
                }
                HStack {
                    Text("Duration Time")
                    Spacer()
                    Text(self.viewModel.durTime)
                }
            }

        }.navigationBarTitle("Track Info")
    }
}
