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

struct TagFileDetailView: View {
    @ObservedObject var viewModel: TagFileDetailViewModel
    
    init(bind: Binding<TagModel>) {
        viewModel = TagFileDetailViewModel()
    }
    
    var body: some View {
        TagFileDetailListView(model: $viewModel.tagModel)
            .navigationTitle("Detail View")
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    viewModel.openCustomAlert = true
                }) {
                    Text("Tag")
                }
                EditButton()
            })
            .customAlert(isPresent: $viewModel.openCustomAlert) {
                TagFileDetailCustomAlertView(tag: $viewModel.remainTag)
                    .onSelectedTag { item in
                        
                    }
            }
    }
}
