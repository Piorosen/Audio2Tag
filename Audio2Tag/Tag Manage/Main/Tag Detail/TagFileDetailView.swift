//
//  TagFileDetailListView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/28.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import ID3TagEditor

extension View {
    func customAlert<Content>(isPresent:Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        ZStack {
            self;
            CustomAlertView(isPresent: isPresent, content: content)
        }
        
    }
}

extension TagFileDetailView {
    func makeAlert() -> Alert {
        Alert(title: Text("저장 하시겠습니까?"), primaryButton: .default(Text("예")), secondaryButton: .cancel())
    }
//    @ViewBuilder
    func makeCustomAlert() -> some View {
        return TagFileDetailCustomAlertView(tag: $viewModel.remainTag)
            .onSelectedTag { item in
                
            }
    }
}

struct TagFileDetailView: View {
    @ObservedObject var viewModel: TagFileDetailViewModel
    
    init(bind: TagModel) {
        viewModel = TagFileDetailViewModel(data: bind)
    }
    
    var body: some View {
        TagFileDetailListView(model: $viewModel.tagModel)
            .navigationTitle("Detail View")
            .navigationBarItems(
                trailing:
                    HStack {
                        EditButton().hidden()
                        
                        Button(action: {
                            viewModel.openCustomAlert = true
                        }) {
                            Text("Tag")
                        }
                        
                        Button(action: {
                            
                        }) {
                            Text("Save")
                        }
                    })
            .alert(isPresented: $viewModel.openAlert, content: makeAlert)
            .customAlert(isPresent: $viewModel.openCustomAlert, content: makeCustomAlert)
    }
}
