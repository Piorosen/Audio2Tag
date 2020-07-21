//
//  CueFileInfoView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/21.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct CueFileInfoView: View {
    @Binding metaData: [metaModel]
    @Binding remData: [remModel]
    @Binding trackData: [trackModel]
    
    
    var body: some View {
        List {
            Section(header: Text("Meta")) {
                ForEach (self.viewModel.metaData) { meta in
                    HStack {
                        Text(meta.value.key)
                        Spacer()
                        Text(meta.value.value)
                    }
                }
            }
            Section(header: Text("Rem")) {
                ForEach (self.viewModel.remData) { meta in
                    HStack {
                        Text(meta.value.key)
                        Spacer()
                        Text(meta.value.value)
                    }
                }
            }
            Section(header: Text("File : \(self.viewModel.fileName)")) {
                ForEach (0..<self.viewModel.track.count, id: \.self) { index in
                    NavigationLink(destination: CueDetailTrackView(self.viewModel.track[index])) {
                        Text("\(index + 1) : \(self.viewModel.track[index].track.title)")
                    }
                }
            }
        }
    }
}

struct CueFileInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CueFileInfoView()
    }
}
