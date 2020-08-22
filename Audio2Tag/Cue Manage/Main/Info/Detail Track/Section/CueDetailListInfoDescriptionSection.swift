//
//  CueDetailListInfoDescriptionSection.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/22.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct CueDetailListInfoDescriptionSection: View {
    var body: some View {
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
            Button(action: {
                
            }) {
                HStack {
                    Text("Meta 정보 추가")
                    Spacer()
                    Image(systemName: "plus")
                }
            }
        }
    }
}
