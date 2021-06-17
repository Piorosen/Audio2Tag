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

import SwiftVgmdb

enum TagSheetEnum : Identifiable {
    var id: Int {
        switch self {
        case .documentAudio(_):
            return 0
        case .tagRequest(_):
            return 1
        }
    }
    
    case tagRequest(TagSearchKind)
    case documentAudio(Int)
}

extension Array {
    func exsist(where prediction: (Element) throws -> Bool) rethrows -> Bool {
        return try self.firstIndex(where: prediction) == nil ? false : true
    }
}


class TagViewModel : ObservableObject {
    @Published var trackAudio = [[TagModel]]()
    @Published var openSheet: TagSheetEnum? = nil
    @Published var openActionSheet = false
    
    // MARK: - Sheet Request
    
    func searchTagResult(album: VDAlbum, track: [[TagSearchTrackModel]]) {
        
    }
    
    // MARK: - View Action
    func tagRequest() {
        openActionSheet = true
    }
    
    func audioRequest(index: Int) {
        openSheet = .documentAudio(index)
    }
    
    func trackRequest() {
        trackAudio.append([TagModel]())
    }
    
    func selectMusicBrainz() {
        openSheet = .tagRequest(.musicBrainz)
    }
    func selectVgmDb() {
        openSheet = .tagRequest(.vgmDb)
    }
    
    // DocumentPicker 응답.
    // archive 정보일 경우 해당 파일 내용 검사 후 오디오만 걸러냄.
    // .audio인 경우 넘김.
    func selectAudioRequest(urls: [URL], section: Int) {
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
            if !trackAudio[section].exsist(where: { $0.deviceFilePath == item }) {
                trackAudio[section].append(TagModel(deviceFilePath: item, haveID3Tag: id3))
            }
            
        }
    }
    
    func loadAudio(url: URL) {
        
    }
    
}
