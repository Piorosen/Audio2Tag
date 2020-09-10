//
//  CustomAlertView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/30.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

enum CustomAlert {
    case cancel
    case okCancel
    case yesNo
}

struct CustomAlertView<Content>: View where Content : View {
    @Binding var isPresent:Bool
    var content: () -> Content
    let title: String
    let state: CustomAlert
    
    init(isPresent: Binding<Bool>, title: String, state:CustomAlert, @ViewBuilder content: @escaping () -> Content) {
        self._isPresent = isPresent
        self.content = content
        self.title = title
        self.state = state
    }
    
    var body: some View {
        ZStack {
            Group {
                VStack{
                    Text(title).padding(.top, 15)
                    Divider()
                    content()
                    Divider()
                    HStack {
                        if (state == .cancel) {
                            Button(action: {
                                withAnimation {
                                    isPresent.toggle()
                                }
                            }) {
                                Text("취소").padding(10).frame(maxWidth: .infinity)
                            }
                        }else if (state == .okCancel) {
                            Button(action: {
                                withAnimation {
                                    isPresent.toggle()
                                }
                            }) {
                                Text("취소").padding(10).frame(maxWidth: .infinity)
                            }
                            Divider()
                            Button(action: {
                                withAnimation {
                                    isPresent.toggle()
                                }
                            }) {
                                Text("확인").padding(10).frame(maxWidth: .infinity)
                            }
                        }else {
                            Button(action: {
                                withAnimation {
                                    isPresent.toggle()
                                }
                            }) {
                                Text("아니요").padding(10).frame(maxWidth: .infinity)
                            }
                            Divider()
                            Button(action: {
                                withAnimation {
                                    isPresent.toggle()
                                }
                            }) {
                                Text("예").padding(10).frame(maxWidth: .infinity)
                            }
                        }
                        
                    }
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8, maxHeight: UIScreen.main.bounds.height * 0.5)
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
