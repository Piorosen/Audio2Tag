//
//  TagFileDetailListView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/28.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import ID3TagEditor

extension TagFileDetailView {
    func makeAlert() -> Alert {
        Alert(title: Text("저장 하시겠습니까?"), primaryButton: .default(Text("예")), secondaryButton: .cancel())
    }
}

struct TagFileDetailView: View {
    @ObservedObject var viewModel: TagFileDetailViewModel
    
    init(bind: TagModel) {
        viewModel = TagFileDetailViewModel(data: bind)
    }
    
    var body: some View {
        ZStack {
            TagFileDetailListView(model: $viewModel.tagModel)
                .onEditRequest(viewModel.tagEditRequest)
                .navigationTitle("Detail View")
                .navigationBarItems(
                    trailing:
                        HStack {
                            EditButton().hidden()
                            
                            Button(action: viewModel.tagNewRequest) {
                                Text("Tag")
                            }
                            
                            Button(action: viewModel.tagSaveRequest) {
                                Text("Save")
                            }
                        })
                .alert(isPresented: $viewModel.openAlert, content: makeAlert)
            
            CustomAlertView(isPresent: $viewModel.openCustomAlert, title: "추가 태그 선택", state: .cancel) {
                TagFileDetailCustomAlertView(tag: $viewModel.addableTag)
                    .onSelectedTag(viewModel.tagAddRequest)
            }
            CustomAlertView(isPresent: $viewModel.openCustomEditAlert, title: "태그 편집", state: .okCancel) {
                TagFileDetailEditCustomAlertView(title: viewModel.selectTitle, hint: viewModel.selectHint, text: $viewModel.selectText)
            }.onOk(viewModel.editTag)
        }
    }
}
