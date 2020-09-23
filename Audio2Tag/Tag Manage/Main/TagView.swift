//
//  TagView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/10.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

extension TagView {
    func makeSheet() -> some View {
        return Group {
            if viewModel.tagSheetEnum == .tagRequest {
                TagSearchView(kind: viewModel.searchEnum)
                    .onSelectTag(viewModel.searchTagResult)
                
            }else if viewModel.tagSheetEnum == .documentAudio {
                DocumentPicker()
                    .setConfig(folderPicker: false, allowMultiple: true)
                    .setUTType(type: [.audio])
                    .onSelectFiles(completeHanlder: viewModel.selectAudioRequest)
            }else {
                EmptyView()
            }
        }
    }
    
    func makeActionSheet() -> ActionSheet {
        ActionSheet(title: Text("검색"), message: Text("Tag 정보를 검색합니다."), buttons: [
            .default(Text("VgmDB"), action: viewModel.selectVgmDb),
            .default(Text("MusicBrainz"), action: viewModel.selectMusicBrainz),
            .cancel()
        ])
    }
}

struct TagView: View {
    @ObservedObject var viewModel = TagViewModel()
    
    // File List -> 선택시 해당 파일 제목 -> 태그 정보 -> 태그정보 선택 -> 수정
    // 단일 파일 == 해당 파일 제목 -> 태그정보
    var body: some View {
        NavigationView {
            TagListView(models: $viewModel.fileInfo)
                .navigationTitle("Tag Info")
                .navigationBarItems(trailing: TagNavigationTraillingView()
                                    .onTagReuqest(self.viewModel.tagRequest)
                                    .onAudioRequest(self.viewModel.audioRequest))
        }
        // 음악 파일 선택 및 태그 검색 하기 위하 시트
        .sheet(isPresented: $viewModel.openSheet, content: makeSheet)
        // Tag 검색 기능을 위한 시트, 선택지 입니다.
        .actionSheet(isPresented: $viewModel.openActionSheet, content: makeActionSheet)
    }
}
