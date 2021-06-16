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
        if viewModel.openAlertSaveEvent {
            return Alert(title: Text("저장 하시겠습니까?"), primaryButton: .default(Text("예")) { self.viewModel.tagSave() }, secondaryButton: .cancel(Text("아니요")))
        }else if viewModel.openAlertSavedEvent {
            return Alert(title: Text("태그가 정상적으로 저장이 되었습니다."), dismissButton: .default(Text("확인")))
        }else {
            return Alert(title: Text("잘못된 요청입니다."))
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
            .onEditRequest(viewModel.tagEditRequest)
            .alert(isPresented: $viewModel.openAlert, content: makeAlert)
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
            .customAlertView(
                [
                    CustomAlertView(isPresent: $viewModel.openCustomAlert, title: "추가 태그 선택")
                    {
                        TagFileDetailCustomAlertView(tag: $viewModel.addableTag)
                            .onSelectedTag(viewModel.tagAddRequest)
                    },
                    CustomAlertView(isPresent: $viewModel.openCustomEditAlert, title: "태그 편집", ok: viewModel.editTag)
                    {
                        TagFileDetailEditCustomAlertView(title: viewModel.selectTitle, hint: viewModel.selectHint, text: $viewModel.selectText)
                    }
                ])
            
    }
}
