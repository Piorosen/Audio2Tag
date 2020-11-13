//
//  CueEditView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/11/12.
//

import SwiftUI

struct CueEditView: View {
    private var requestExecute: () -> Void = { }
    private var requestStatus: () -> Void = { }
    
    
    func onRequestExecute(_ action: @escaping () -> Void) -> CueEditView {
        var copy = self
        copy.requestExecute = action
        return copy
    }
    
    func onRequestStatus(_ action: @escaping () -> Void) -> CueEditView {
        var copy = self
        copy.requestStatus = action
        return copy
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Meta")) {
                    EmptyView()
                }
                Section(header: Text("Meta")) {
                    EmptyView()
                }
                Section(header: Text("REM")) {
                    EmptyView()
                }
                Section(header: Text("FILE")) {
                    EmptyView()
                }
            }.navigationTitle("큐 편집기")
            .navigationBarItems(leading: HStack {
                Button(action: requestExecute) {
                    Image(systemName: "play")
                }
                Button(action: requestStatus) {
                    Image(systemName: "doc.on.doc")
                }
            }, trailing: HStack {
                Button(action: {
                    
                }) {
                    Image(systemName: "folder.badge.plus")
                }
            })
        }
    }
}

struct CueEditView_Previews: PreviewProvider {
    static var previews: some View {
        CueEditView()
    }
}
