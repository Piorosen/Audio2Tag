//
//  ItemSection.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2021/01/24.
//

import SwiftUI
import SwiftCueSheet

struct ItemSection<T:View, B: Identifiable, Content: View>: View {
    let header: T
    let addText: String
    @Binding var bind: [B]
    
    var drawHStack: ((B) -> Content)
    
    var add = { }
    var edit: (B) -> Void = { _ in }
    
    func addEvent(_ event: @escaping () -> Void) -> ItemSection {
        var copy = self
        copy.add = event
        return copy
    }
    func editEvent(_ event: @escaping (B) -> Void) -> ItemSection {
        var copy = self
        copy.edit = event
        return copy
    }
    
    var body: some View {
        Section(header: header) {
            ForEach(bind) { item in
                Button(action: { edit(item) }) {
                    drawHStack(item)
                }
            }
            AddButton(addText, add)
        }
    }
}

struct ItemSection_Previews: PreviewProvider {
    @State static var item: [CueSheetRem] = [CueSheetRem(key: .genre, value: "anime"), CueSheetRem(key: .genre, value: "anime"), CueSheetRem(key: .genre, value: "anime")]
    @State static var text = "hi"
    static var previews: some View {
        List {
            ItemSection(header: Text("AA"), addText: "META ADD", bind: self.$item, drawHStack: { i in
              Text(text)
            }).addEvent {
                text = "add"
            }.editEvent { item in
                text = "edit"
            }
        }
        
    }
}
