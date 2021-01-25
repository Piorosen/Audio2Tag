//
//  EditSection.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2021/01/24.
//

import SwiftUI

struct EditSection: View {
    
    // MARK: - Binding Variable
    @Binding var meta: [CueSheetMeta]
    @Binding var rem: [CueSheetRem]
    @Binding var track: [CueSheetTrack]
    
    // MARK: - variable, Function Pointer
    var addEventMeta: (UUID) -> Void = { _ in }
    var addEventRem: (UUID) -> Void = { _ in }
    var addEventTrack: (UUID) -> Void = { _ in }
    
    var editEventMeta: (UUID) -> Void = { _ in }
    var editEventRem: (UUID) -> Void = { _ in }
    var editEventTrack: (UUID) -> Void = { _ in }
    
    // MARK: - Add Event
    func addMeta(_ action: @escaping (UUID) -> Void) -> Self {
        var copy = self
        copy.addEventMeta = action
        return copy
    }
    func addRem(_ action: @escaping (UUID) -> Void) -> Self {
        var copy = self
        copy.addEventRem = action
        return copy
    }
    func addTrack(_ action: @escaping (UUID) -> Void) -> Self {
        var copy = self
        copy.addEventTrack = action
        return copy
    }
    
    // MARK: - Edit Event
    func editMeta(_ action: @escaping (UUID) -> Void) -> Self {
        var copy = self
        copy.editEventMeta = action
        return copy
    }
    
    func editRem(_ action: @escaping (UUID) -> Void) -> Self {
        var copy = self
        copy.editEventRem = action
        return copy
    }
    func editTrack(_ action: @escaping (UUID) -> Void) -> Self {
        var copy = self
        copy.editEventTrack = action
        return copy
    }
    
    // MAKR: - View
    var body: some View {
        MusicSection()
        
        
        ItemSection(header: Text("Meta"), addText: "META 추가", bind: self.$meta) { item in
            HStack {
                Text("\(item.key.caseName)")
                Spacer()
                Text("\(item.value)")
            }
        }.addEvent {
            addEventMeta(UUID())
        }.editEvent { item in
            editEventMeta(item.id)
        }
        
        ItemSection(header: Text("Rem"), addText: "REM 추가", bind: self.$rem) { item in
            HStack {
                Text("\(item.key.caseName)")
                Spacer()
                Text("\(item.value)")
            }
        }.addEvent {
            addEventRem(UUID())
        }.editEvent { item in
            editEventRem(item.id)
        }
        
        ItemSection(header: Text("Track"), addText: "TRACK 추가", bind: self.$track) { item in
            HStack {
                Text("\(item.trackNum)")
                Spacer()
                Text("\(item.title)")
            }
        }.addEvent {
            addEventTrack(UUID())
        }.editEvent { item in
            editEventTrack(item.id)
        }
    
    }
}
