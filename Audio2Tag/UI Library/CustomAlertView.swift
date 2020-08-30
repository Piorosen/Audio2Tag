//
//  CustomAlertView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/30.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct CustomAlertView<Content>: View where Content : View {
    @Binding var isPresent:Bool
    var content: () -> Content
    
    init(isPresent: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self._isPresent = isPresent
        self.content = content
    }
    
    
    var body: some View {
        GeometryReader { (g:GeometryProxy) in
            ZStack {
                content()
                
                Divider()
                Button(action: {
                    withAnimation {
                        isPresent.toggle()
                    }
                }) {
                    Text("취소")
                }
            }.opacity(isPresent ? 1 : 0)
        }
    }
}

