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
            .customAlert(isPresent: $viewModel.openCustomAlert)
            {
                VStack {
                    Text("추가 태그 선택").padding(.top, 15)
                    Divider()
                    List (viewModel.remainTag , id: \.self) { item in
                        Button(item) {
                            viewModel.selectTag(item)
                        }
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
    }
}
