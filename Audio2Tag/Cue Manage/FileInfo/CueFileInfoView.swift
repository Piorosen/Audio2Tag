//
//  CueFileInfoView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/21.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct CueFileInfoView: View {
    @Binding var fileInfo: CueFileInfoModel
    
    var body: some View {
        List {
            Section(header: Text("Meta")) {
                ForEach (self.fileInfo.meta) { meta in
                    HStack {
                        Text(meta.value.key)
                        Spacer()
                        Text(meta.value.value)
                    }
                }
            }
            Section(header: Text("Rem")) {
                ForEach (self.fileInfo.rem) { meta in
                    HStack {
                        Text(meta.value.key)
                        Spacer()
                        Text(meta.value.value)
                    }
                }
            }
            Section(header: Text("File : \(self.fileInfo.fileName)")) {
                ForEach (self.fileInfo.track) { track in
                    NavigationLink(destination: CueDetailTrackView(track)) {
                        Text("\(track.track.trackNum) : \(track.track.title)")
                    }
                }
            }
        }
    }
}
