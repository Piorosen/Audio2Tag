//
//  TagView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/10.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

extension TagView {
    
    func makeSheet(item: TagSheetEnum) -> some View {
        Group {
            switch item {
            case TagSheetEnum.documentAudio(let index):
                DocumentPicker()
                    .setConfig(folderPicker: false, allowMultiple: true)
                    .setUTType(type: [.audio])
                    .onSelectFiles {
                        viewModel.selectAudioRequest(urls: $0, section: index)
                    }
            case TagSheetEnum.tagRequest(let kind):
                TagSearchView(kind: kind)
                    .onSelectTag(viewModel.searchTagResult)
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
            TagListView(models: $viewModel.trackAudio)
                .onAudioRequest { self.viewModel.audioRequest(index: $0) } 
                .navigationTitle("Tag Editor")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: TagNavigationTraillingView()
                                        .onTagReuqest(self.viewModel.tagRequest)
                                        .onTrackRequest(self.viewModel.trackRequest)
                                    ,
                                    trailing: EditButton())
            
        }
        // 음악 파일 선택 및 태그 검색 하기 위하 시트
        .sheet(item: $viewModel.openSheet) { makeSheet(item: $0) }
        // Tag 검색 기능을 위한 시트, 선택지 입니다.
        .actionSheet(isPresented: $viewModel.openActionSheet) { makeActionSheet() }
    }
}
