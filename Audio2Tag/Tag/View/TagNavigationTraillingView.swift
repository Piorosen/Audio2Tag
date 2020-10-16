//
//  TagNavigationTraillingView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/26.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagNavigationTraillingView: View {
    private var audioRequest = { }
    private var tagRequest = { }
    
    func onAudioRequest(_ action: @escaping () -> Void) -> TagNavigationTraillingView {
        var copy = self
        copy.audioRequest = action
        return copy
    }
    
    func onTagReuqest(_ action: @escaping () -> Void) -> TagNavigationTraillingView {
        var copy = self
        copy.tagRequest = action
        return copy
    }
    
    var body: some View {
        Group {
            HStack {
                Button(action: audioRequest) {
                    Image(systemName: "plus.app")
                }.padding(10)
                Button(action: tagRequest) {
                    Image(systemName: "doc.on.doc")
                }.padding(10)
            }
        }
    }
}

