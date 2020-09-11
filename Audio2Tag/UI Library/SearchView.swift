//
//  SearchView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/29.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @State var text:String = ""
    
//    init(text: Binding<String>) {
//        _text = text
//    }
    
    @State private var showCancelButton: Bool = false
    private var commit = { (_:String) in }
    
    func onCommit(_ action: @escaping (String) -> Void) -> SearchView {
        var copy = self
        copy.commit = action
        return copy
    }
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("search", text: self.$text, onEditingChanged: { isEditing in
                    self.showCancelButton = true
                }, onCommit: {
                    commit(text)
                }).foregroundColor(.primary)
                
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(text == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
            .animation(.spring())
            if showCancelButton  {
                Button("Cancel") {
                    UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                    self.text = ""
                    self.showCancelButton = false
                }
                .foregroundColor(Color(.systemBlue))
            }
        }
        .padding(EdgeInsets(top: showCancelButton ? 20 : 8, leading: 8, bottom: 8, trailing: 8))
        .navigationBarHidden(showCancelButton) // .animation(.default) // animation does not work properly
        .animation(.spring())
    }
}
