//
//  CustomAlertView+Protocol.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/10/17.
//


import SwiftUI

enum CustomAlert {
    case cancel
    case okCancel
    case yesNo
}


protocol ProtocolCustomAlertView: View {
    func onOk(_ action: @escaping () -> Void) -> Self
    func onCancel(_ action: @escaping () -> Void) -> Self
    func onYes(_ action: @escaping () -> Void) -> Self
    func onNo(_ action: @escaping () -> Void) -> Self
}

struct CustomAlertView: View {
    var body: AnyView
    
    init<Content: View>(isPresent: Binding<Bool>, title: String,
                        ok: (() -> Void)? = nil,
                        cancel: (() -> Void)? = nil,
                        @ViewBuilder content: @escaping () -> Content) {
        body = AnyView(
            CustomAlertView_Bool(isPresent: isPresent, title: title, state: .okCancel, content: content)
                .onOk(ok ?? { })
                .onCancel(cancel ?? { }))
    }
    init<Content: View>(isPresent: Binding<Bool>, title: String,
                        cancel: (() -> Void)?,
                        @ViewBuilder content: @escaping () -> Content) {
        body = AnyView(
            CustomAlertView_Bool(isPresent: isPresent, title: title, state: .cancel, content: content)
                .onCancel(cancel ?? { }))
    }
    init<Content: View>(isPresent: Binding<Bool>, title: String,
                        yes: (() -> Void)?,
                        no: (() -> Void)?,
                        @ViewBuilder content: @escaping () -> Content) {
        body = AnyView(
            CustomAlertView_Bool(isPresent: isPresent, title: title, state: .yesNo, content: content)
                .onYes(yes ?? { })
                .onNo(no ?? { }))
    }
    
    
    init<Content: View, Item: Identifiable & Equatable>(item: Binding<Item?>, title: String,
                        ok: (() -> Void)? = nil,
                        cancel: (() -> Void)? = nil,
                        @ViewBuilder content: @escaping (Item) -> Content) {
        body = AnyView(
            CustomAlertView_Any(item: item, title: title, state: .okCancel, content: content)
                .onOk(ok ?? { })
                .onCancel(cancel ?? { }))
    }
    init<Content: View, Item: Identifiable & Equatable>(item: Binding<Item?>, title: String,
                        cancel: (() -> Void)? = nil,
                        @ViewBuilder content: @escaping (Item) -> Content) {
        body = AnyView(
            CustomAlertView_Any(item: item, title: title, state: .cancel, content: content)
                .onCancel(cancel ?? { }))
    }
    init<Content: View, Item: Identifiable & Equatable>(item: Binding<Item?>, title: String,
                        yes: (() -> Void)? = nil,
                        no: (() -> Void)? = nil,
                        @ViewBuilder content: @escaping (Item) -> Content) {
        body = AnyView(
            CustomAlertView_Any(item: item, title: title, state: .yesNo, content: content)
                .onYes(yes ?? { })
                .onNo(no ?? { }))
    }
    
}

// MARK: - Bool Type
fileprivate struct CustomAlertView_Bool<Content: View>: ProtocolCustomAlertView {
    @Binding var isPresent: Bool
    var content: () -> Content
    
    let title: String
    let state: CustomAlert
    
    private var funcOk = { }
    private var funcCancel = { }
    private var funcYes = { }
    private var funcNo = { }
    
    func onOk(_ action: @escaping () -> Void) -> CustomAlertView_Bool {
        var copy = self
        copy.funcOk = action
        return copy
    }
    func onCancel(_ action: @escaping () -> Void) -> CustomAlertView_Bool {
        var copy = self
        copy.funcCancel = action
        return copy
    }
    func onYes(_ action: @escaping () -> Void) -> CustomAlertView_Bool {
        var copy = self
        copy.funcYes = action
        return copy
    }
    func onNo(_ action: @escaping () -> Void) -> CustomAlertView_Bool {
        var copy = self
        copy.funcNo = action
        return copy
    }
    
    init(isPresent: Binding<Bool>, title: String, state:CustomAlert, @ViewBuilder content: @escaping () -> Content) {
        self._isPresent = isPresent
        
        self.title = title
        self.state = state
        self.content = content
    }
    
    var body: some View {
        Group {
            VStack{
                Text(title).padding(.top, 15)
                Divider()
                if isPresent {
                    content()
                }
                Divider()
                HStack {
                    if (state == .cancel) {
                        Button(action: {
                            funcCancel()
                            withAnimation {
                                isPresent.toggle()
                            }
                        }) {
                            Text("취소").padding(10).frame(maxWidth: .infinity)
                        }
                    }else if (state == .okCancel) {
                        Button(action: {
                            funcCancel()
                            withAnimation {
                                isPresent.toggle()
                            }
                        }) {
                            Text("취소").padding(10).frame(maxWidth: .infinity)
                        }
                        Divider()
                        Button(action: {
                            funcOk()
                            withAnimation {
                                isPresent.toggle()
                            }
                        }) {
                            Text("확인").padding(10).frame(maxWidth: .infinity)
                        }
                    }else {
                        Button(action: {
                            funcNo()
                            withAnimation {
                                isPresent.toggle()
                            }
                        }) {
                            Text("아니요").padding(10).frame(maxWidth: .infinity)
                        }
                        Divider()
                        Button(action: {
                            funcYes()
                            withAnimation {
                                isPresent.toggle()
                            }
                        }) {
                            Text("예").padding(10).frame(maxWidth: .infinity)
                        }
                    }
                }
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 100)
            .opacity(isPresent ? 1 : 0)
            .onChange(of: isPresent) { newValue in
                if !newValue {
                    UIApplication.shared.endEditing(true)
                }
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
        .animation(.spring())
    }
}


// MARK: - AnyType
fileprivate struct CustomAlertView_Any<Content: View, Item: Identifiable & Equatable>: ProtocolCustomAlertView {
    @Binding var item: Item?

    var content: ((Item) -> Content)
    
    let title: String
    let state: CustomAlert
    
    private var funcOk = { }
    private var funcCancel = { }
    private var funcYes = { }
    private var funcNo = { }
    
    func onOk(_ action: @escaping () -> Void) -> CustomAlertView_Any {
        var copy = self
        copy.funcOk = action
        return copy
    }
    func onCancel(_ action: @escaping () -> Void) -> CustomAlertView_Any {
        var copy = self
        copy.funcCancel = action
        return copy
    }
    func onYes(_ action: @escaping () -> Void) -> CustomAlertView_Any {
        var copy = self
        copy.funcYes = action
        return copy
    }
    func onNo(_ action: @escaping () -> Void) -> CustomAlertView_Any {
        var copy = self
        copy.funcNo = action
        return copy
    }
    
    init(item: Binding<Item?>, title: String, state:CustomAlert, @ViewBuilder content: @escaping (Item) -> Content) {
        self._item = item
        
        self.title = title
        self.state = state
        self.content = content
    }
    
    
    var body: some View {
        Group {
            VStack{
                Text(title).padding(.top, 15)
                Divider()
                if let item = self.item {
                    content(item)
                }
                Divider()
                HStack {
                    if (state == .cancel) {
                        Button(action: {
                            funcCancel()
                            withAnimation {
                                item = nil
                            }
                        }) {
                            Text("취소").padding(10).frame(maxWidth: .infinity)
                        }
                    }else if (state == .okCancel) {
                        Button(action: {
                            funcCancel()
                            withAnimation {
                                item = nil
                            }
                        }) {
                            Text("취소").padding(10).frame(maxWidth: .infinity)
                        }
                        Divider()
                        Button(action: {
                            funcOk()
                            withAnimation {
                                item = nil
                            }
                        }) {
                            Text("확인").padding(10).frame(maxWidth: .infinity)
                        }
                    }else {
                        Button(action: {
                            funcNo()
                            withAnimation {
                                item = nil
                            }
                        }) {
                            Text("아니요").padding(10).frame(maxWidth: .infinity)
                        }
                        Divider()
                        Button(action: {
                            funcYes()
                            withAnimation {
                                item = nil
                            }
                        }) {
                            Text("예").padding(10).frame(maxWidth: .infinity)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 100)
            .opacity(item != nil ? 1 : 0)
            .onChange(of: item) { newValue in
                if newValue == nil {
                    UIApplication.shared.endEditing(true)
                }
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
        .animation(.spring())
    }
}
