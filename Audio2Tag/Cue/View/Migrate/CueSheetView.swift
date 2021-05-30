//
//  CueSheetView.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/05/28.
//

import SwiftUI
import SwiftCueSheet

struct CueSheetView: View {
    @Binding var cueSheet: CueSheet?
    @Binding var mode: CueSheetDocument
    
    var newEvent: (() -> Void) = { }
    var discardEvent: (() -> Void) = { }
    
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
    
    func onDisacrd(_ action: @escaping () -> Void) -> CueSheetView {
        var copy = self
        copy.discardEvent = action
        return copy
    }
    
    var body: some View {
        Group {
            if cueSheet == nil && (mode == .none || mode == .editCueSheet) {
                Section(header: Text("Cue Sheet")) {
                    Button(action: newEvent, label: {
                        Text("New File")
                    })
                    Button(action: editEvent, label: {
                        Text("Edit File")
                    })
                }
            }else {
                Section(header: Text("Meta")) {
                    AddButton("New") {
                        
                    }
                }
                Section(header: Text("Rem")) {
                    AddButton("New") {
                        
                    }
                }
                Section(header: Text("Tracks")) {
                    AddButton("New") {
                        
                    }
                }
                
                Button(action: discardEvent, label: {
                    Text("Discard")
                })
            }
            
        }
        
    }
}
