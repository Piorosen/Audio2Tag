//
//  AddButton.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/10/13.
//

import SwiftUI

struct AddButton: View {
    let title: String
    var down: () -> Void
    
    public init(_ title: String, _ down: @escaping () -> Void) {
        self.title = title
        self.down = down
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
                Text(title)
                Spacer()
                Image(systemName: "plus")
            }
        }
    }
}

