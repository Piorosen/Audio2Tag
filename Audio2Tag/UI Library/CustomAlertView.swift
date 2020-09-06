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
        ZStack {
            Group {
                VStack(spacing: 0) {
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
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.5)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(15)
                .shadow(radius: 100)
                
                .opacity(isPresent ? 1 : 0)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.spring())
    }
}
