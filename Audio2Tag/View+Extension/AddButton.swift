//
//  AddButton.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/10/13.
//

import SwiftUI

struct AddButton: View {
    let title: String
    let content: (() -> AnyView)?
    
    var down: () -> Void
    
    public init(_ title: String, _ down: @escaping () -> Void) {
        self.title = title
        content = nil
        self.down = down
    }
    
    public init<Content: View>(_ content: @escaping () -> Content, _ down: @escaping () -> Void) {
        title = ""
        self.down = down
        self.content = { return AnyView(content()) }
        
    }
    
    
    func onDown(_ action: @escaping () -> Void) -> AddButton {
        var copy = self
        copy.down = action
        return copy
    }
    
    var body: some View {
        Button(action: {
            down()
        }) {
            HStack {
                if let c = content {
                    c()
                }else
                {
                    Text(title)
                }
                Spacer()
                Image(systemName: "plus")
            }
        }
    }
}

