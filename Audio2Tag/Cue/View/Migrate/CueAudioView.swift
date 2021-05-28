//
//  CueAudioView.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/05/28.
//

import SwiftUI
import SwiftCueSheet

struct CueAudioView: View {
    @Binding var audio: URL?
    
    var loadEvent: (() -> Void) = { }
    
    func onLoad(_ action: @escaping () -> Void) -> CueAudioView {
        var copy = self
        copy.loadEvent = action
        return copy
    }
    
    var body: some View {
        Section(header: Text("Audio Files")) {
            if audio == nil {
                Button(action: loadEvent, label: {
                    Text("Load File")
                })
            }else {
                Button(action: loadEvent, label: {
                    Text("Discard")
                })
            }
        }
    }
}
