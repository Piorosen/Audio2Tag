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
                if isPresent {
                    VStack {
                        content()
                        Divider()
                        Button(action: {
                            withAnimation {
                                isPresent.toggle()
                            }
                        }) {
                            Text("취소").padding(10).frame(maxWidth: .infinity)
                        }
                    }
                    
                    .frame(width: g.size.width * 0.7, height: g.size.height * 0.7)
                    .background(Color.red)
                    .cornerRadius(15)
                }
            }
    
    }
    
}
