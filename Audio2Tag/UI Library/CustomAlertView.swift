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
    
    private var funcOk = { }
    private var funcCancel = { }
    private var funcYes = { }
    private var funcNo = { }
    
    func onOk(_ action: @escaping () -> Void) -> CustomAlertView {
        var copy = self
        copy.funcOk = action
        return copy
    }
    func onCancel(_ action: @escaping () -> Void) -> CustomAlertView {
        var copy = self
        copy.funcCancel = action
        return copy
    }
    func onYes(_ action: @escaping () -> Void) -> CustomAlertView {
        var copy = self
        copy.funcYes = action
        return copy
    }
    func onNo(_ action: @escaping () -> Void) -> CustomAlertView {
        var copy = self
        copy.funcNo = action
        return copy
    }
    
    
    init(isPresent: Binding<Bool>, title: String, state:CustomAlert, @ViewBuilder content: @escaping () -> Content) {
        self._isPresent = isPresent
        self.content = content
        self.title = title
        self.state = state
    }
    
    var body: some View {
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
                            funcCancel()
                        }) {
                            Text("취소").padding(10).frame(maxWidth: .infinity)
                        }
                    }else if (state == .okCancel) {
                        Button(action: {
                            withAnimation {
                                isPresent.toggle()
                            }
                            funcCancel()
                        }) {
                            Text("취소").padding(10).frame(maxWidth: .infinity)
                        }
                        Divider()
                        Button(action: {
                            withAnimation {
                                isPresent.toggle()
                            }
                            funcOk()
                        }) {
                            Text("확인").padding(10).frame(maxWidth: .infinity)
                        }
                    }else {
                        Button(action: {
                            withAnimation {
                                isPresent.toggle()
                            }
                            funcNo()
                        }) {
                            Text("아니요").padding(10).frame(maxWidth: .infinity)
                        }
                        Divider()
                        Button(action: {
                            withAnimation {
                                isPresent.toggle()
                            }
                            funcYes()
                        }) {
                            Text("예").padding(10).frame(maxWidth: .infinity)
                        }
                    }
                }.frame(maxWidth: .infinity, maxHeight: 50)
            }
//            .background(Color.red)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 100)
            .opacity(isPresent ? 1 : 0)
            .onChange(of: isPresent) { newValue in
                UIApplication.shared.endEditing(true)
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
        .animation(.spring())
    }
}
