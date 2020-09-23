//
//  TagFileDetailListViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/29.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import ID3TagEditor

extension FrameName : CaseIterable {
    public static var allCases: [FrameName] {
        return [.Album, .AlbumArtist, .Artist, .Composer, .Conductor, .ContentGrouping, .Copyright, .DiscPosition, .EncodedBy, .EncoderSettings ,.FileOwner,.Genre,.Lyricist,.MixArtist,.Publisher,.RecordingDateTime,.RecordingDayMonth,.RecordingHourMinute,.RecordingYear,.Subtitle,.Title,.TrackPosition]
    }
    
    var caseName: String {
        return Mirror(reflecting: self).children.first?.label ?? String(describing: self)
    }
}

struct TagFileDetailListTextCell : Identifiable {
    let id = UUID()
    let title: String
    var text = String()
}

struct TagFileDetailListModel : Identifiable {
    let id = UUID()
    
    var image = UIImage()
    var tag = [TagFileDetailListTextCell]()
}

class TagFileDetailViewModel : ObservableObject {
    @Published var tagModel = TagFileDetailListModel()
    @Published var openCustomAlert = false
    @Published var openCustomEditAlert = false
    @Published var openAlert = false
    
    @Published var addableTag = [String]()
    
    
    // MARK: - UI Interaction
    
    @Published var selectText = ""
    var selectTitle = ""
    var selectHint = ""
    
    func tagEditRequest(item: TagFileDetailListTextCell) {
        selectHint = item.text
        selectTitle = item.title
        openCustomEditAlert = true
    }
    
    func tagAddRequest(item: String) {
        selectHint = ""
        selectTitle = item
        openCustomEditAlert = true
    }
    
    func tagNewRequest() {
        openCustomAlert = true
    }
    
    func tagSaveRequest() {
        openAlert = true
    }
    
    
    // MARK: - UI -> Model
    func editTag() {
        let title = selectTitle
        let text = selectText.isEmpty ? selectHint : selectText
        
        // 기존에 이미 태그가 존재하는 경우.
        if let index = tagModel.tag.firstIndex(where: { e in e.title == title }) {
            tagModel.tag[index].text = text
            print(tagModel.tag)
        }
        // 기존에 태그가 없어서, 추가해야하는 경우.
        else {
            tagModel.tag.append(TagFileDetailListTextCell(title: title, text: text))
            // 자동 정렬 및 추가 가능한 목록에서 삭제함.
            tagModel.tag.sort { $0.title > $1.title }
            addableTag = addableTag.filter { i in i != title }
        }
    }
    
    
    
    // MARK: - Initialize
    
    init(data: TagModel) {
        do {
            guard let tag = try ID3TagEditor().read(from: data.deviceFilePath.path) else {
                return
            }
            
            let getAllImage = ID3PictureType.allCases.compactMap({ type in (tag.frames[.AttachedPicture(type)] as? ID3FrameAttachedPicture)})
            
            let frontImage = getAllImage.count > 0 ? UIImage(data: getAllImage[0].picture)! : UIImage()
            var tagAllCases = FrameName.allCases.map { $0 }
            
            let ownFrameKey = tag.frames.keys.filter { (tag.frames[$0] as? ID3FrameWithStringContent) != nil }.map { $0 }
            
//            _ = tag.frames.keys.filter { (tag.frames[$0] as? ID3FrameWithIntegerContent) != nil }.map { $0 }
            let text = ownFrameKey.map { TagFileDetailListTextCell(title: $0.caseName, text: (tag.frames[$0] as! ID3FrameWithStringContent).content) }
            
            // 남아 있는 태그 정리.
            ownFrameKey.forEach { (f:FrameName) in tagAllCases.removeAll(where: { $0 == f } ) }
            
            tagModel = TagFileDetailListModel(image: frontImage, tag: text)
            addableTag = tagAllCases.map { $0.caseName }
            
        }catch {
            print(error)
        }
    }
    
    
    
    
}
