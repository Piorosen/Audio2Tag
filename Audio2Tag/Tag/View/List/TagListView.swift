//
//  TagFileList.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/28.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

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
                TagListTrackSectionlView(index: trackIdx, models: $models[trackIdx])
                    .onSectionTap { audioRequest($0) }
                    .onRemoveSection { models.remove(at: $0) }
            }
        }
        
    }
}
