//
//  CueSheetView.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/05/28.
//

import SwiftUI

struct CueSheetView: View {
    @Binding var cueSheet: URL?
    @Binding var mode: CueSheetDocument
    
    var newEvent: (() -> Void) = { }
    
    func onNew(_ action: @escaping () -> Void) -> CueSheetView {
        var copy = self
        copy.newEvent = action
        return copy
    }
    
    var editEvent: (() -> Void) = { }
    func onEdit(_ action: @escaping () -> Void) -> CueSheetView {
        var copy = self
        copy.editEvent = action
        return copy
    }
    
    var body: some View {
        Section(header: Text("Cue Sheet")) {
            if mode == .none {
                Button(action: newEvent, label: {
                    Text("New File")
                })
                Button(action: editEvent, label: {
                    Text("Edit File")
                })
            }else {
                Button(action: editEvent, label: {
                    Text("Discard")
                })
            }
            
        }
    }
}
