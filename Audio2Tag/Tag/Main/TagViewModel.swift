//
//  TagViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/24.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import SwiftUI
import ID3TagEditor
import UniformTypeIdentifiers
import SwiftVgmdb

enum TagSheetEnum {
    case tagRequest
    case documentAudio
}


class TagViewModel : ObservableObject {
//    @Published var tagInfo = TagModel(tagVersion: .version2, tagFrame: .init())
//
    @Published var fileInfo = [TagModel]()
    
    @Published var openSheet = false
    var tagSheetEnum:TagSheetEnum = .tagRequest
    var searchEnum: TagSearchKind = .vgmDb
    
    @Published var openAlert = false
    @Published var openActionSheet = false
    
    // MARK: - Sheet Request
    
    func searchTagResult(album: VDAlbum, track: [[TagSearchTrackModel]]) {
        
    }
    
    // MARK: - View Action
    func tagRequest() {
        tagSheetEnum = .tagRequest
        openActionSheet = true
    }
    
    func audioRequest() {
        tagSheetEnum = .documentAudio
        openSheet = true
    }
    
    func selectMusicBrainz() {
        searchEnum = .musicBrainz
        openSheet = true
    }
    func selectVgmDb() {
        searchEnum = .vgmDb
        openSheet = true
    }
    
    // DocumentPicker 응답.
    // archive 정보일 경우 해당 파일 내용 검사 후 오디오만 걸러냄.
    // .audio인 경우 넘김.
    func selectAudioRequest(urls: [URL]) {
        // urls 순서대로 데이터 체크함.
        // 파일명 순서로 체크 할 필요?
        // 사용자에게 떠넘기자.
        
        
        for item in urls {
            var id3: Bool = false
            do {
                _ = try ID3TagEditor().read(from: item.path)
                id3 = true
            }catch {
                
            }
            fileInfo.append(TagModel(deviceFilePath: item,
                                     haveID3Tag: id3))
            
        }
        
        fileInfo.sort { $0.fileName < $1.fileName }        
    }
    
    func loadAudio(url: URL) {
        
//        guard let tag = (try? ID3TagEditor().read(from: url.path)) else {
//            openAlert = true
//            return
//        }
        
//        tagInfo = TagModel(tagVersion: .version2, tagFrame: tag.frames.map({ v in TagFrameModel(key: v.key, value: v.value)}))
        
    }
    
}
