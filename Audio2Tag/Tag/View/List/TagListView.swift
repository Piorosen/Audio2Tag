//
//  TagFileList.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/28.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import SwiftUIListSeparator

struct TagListView: View {
    @Binding var models: [[TagModel]]
    
    var audioRequest: (Int) -> Void = { _ in }
    func onAudioRequest(_ action: @escaping (Int) -> Void) -> Self {
        var copy = self
        copy.audioRequest = action
        return copy
    }
    
    var body: some View {
        List {

            ForEach (models.indices, id: \.self) { trackIdx in
                Section(header: Button(action: { audioRequest(trackIdx) }) {
                    HStack {
                        Image(systemName: "plus.app")
                        Text("Track : \(trackIdx + 1)")
                    }
                }) {
                    ForEach (models[trackIdx].indices, id: \.self) { audioIdx in
                        Group {
                            if models[trackIdx][audioIdx].haveID3Tag {
                                NavigationLink(destination: TagFileDetailView(bind: models[trackIdx][audioIdx])) {
                                    TagListCellView(item: models[trackIdx][audioIdx])
                                }
                            }else {
                                TagListCellView(item: models[trackIdx][audioIdx])
                            }
                        }
                    }
                    .onMove {
                        models[trackIdx].move(fromOffsets: $0, toOffset: $1)
                    }
                    .onDelete {
                        models[trackIdx].remove(atOffsets: $0)
                    }
                }
            }
        }
    }
}
