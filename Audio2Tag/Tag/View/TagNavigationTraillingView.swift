//
//  TagNavigationTraillingView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/26.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagNavigationTraillingView: View {
    private var makeTrackRequest = { }
    private var tagRequest = { }
    
    func onTrackRequest(_ action: @escaping () -> Void) -> TagNavigationTraillingView {
        var copy = self
        copy.makeTrackRequest = action
        return copy
    }

    func onTagReuqest(_ action: @escaping () -> Void) -> TagNavigationTraillingView {
        var copy = self
        copy.tagRequest = action
        return copy
    }

    var body: some View {
        HStack {
            Button(action: makeTrackRequest) {
                Image(systemName: "externaldrive.badge.plus")
            }
            Button(action: tagRequest) {
                Image(systemName: "doc.on.doc")
            }
        }
    }
}

