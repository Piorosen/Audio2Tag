//
//  TagFileDetailListViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/29.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import ID3TagEditor

extension FrameName {
    var caseName: String {
        return Mirror(reflecting: self).children.first?.label ?? String(describing: self)
    }
}

struct TagFileDetailListTextCell : Identifiable {
    let id = UUID()
    let title: FrameName
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
    
    @Published var addableTag = [FrameName]()
    
    var openAlertSaveEvent = false
    var openAlertSavedEvent = false
    
    
    // MARK: - UI Interaction
    let parentModel: TagModel
    
    
    @Published var selectText = ""
    var selectTitle: FrameName = FrameName.title
    var selectHint = ""
    
    func tagEditRequest(item: TagFileDetailListTextCell) {
        selectHint = item.text
        selectTitle = item.title
        openCustomEditAlert = true
    }
    
    func tagAddRequest(item: FrameName) {
        selectHint = ""
        selectTitle = item
        openCustomEditAlert = true
    }
    
    func tagNewRequest() {
        openCustomAlert = true
    }
    
    func tagSaveRequest() {
        openAlertSaveEvent = true
        openAlertSavedEvent = false
        openAlert = true
    }
    
    func tagSavedRequest() {
        openAlertSaveEvent = false
        openAlertSavedEvent = true
        openAlert = true
    }
    
    
    func tagSave() {
        var a = tagModel.tag.reduce(into: [FrameName:ID3Frame]()) {
            $0[$1.title] = ID3FrameWithStringContent(content: $1.text)
        }
        
        if let data = tagModel.image.jpegData(compressionQuality: 1.0) {
            a[.attachedPicture(.frontCover)] = ID3FrameAttachedPicture(picture: data, type: .frontCover, format: .jpeg)
        }
        
        do {
            
//            try ID3TagEditor().write(tag: ID3Tag(version: .version4, frames: a), to: parentModel.deviceFilePath.path, andSaveTo: self.parentModel.deviceFilePath.path)
            
            
        }catch {
            print(error)
        }
        DispatchQueue.main.async {
            self.tagSavedRequest()
        }
    }
    
    
    // MARK: - UI -> Model
    func editTag() {
        let title = selectTitle
        let text = selectText.isEmpty ? selectHint : selectText
        
        // 기존에 이미 태그가 존재하는 경우.
        if let index = tagModel.tag.firstIndex(where: { e in e.title.caseName == title.caseName }) {
            tagModel.tag[index].text = text
            print(tagModel.tag)
        }
        // 기존에 태그가 없어서, 추가해야하는 경우.
        else {
            tagModel.tag.append(TagFileDetailListTextCell(title: title, text: text))
            // 자동 정렬 및 추가 가능한 목록에서 삭제함.
            tagModel.tag.sort { $0.title.caseName > $1.title.caseName }
            addableTag = addableTag.filter { i in i != title }
        }
        
        selectText = ""
    }
    
    
    
    // MARK: - Initialize
    
    init(data: TagModel) {
        parentModel = data
        do {
            guard let tag = try ID3TagEditor().read(from: data.deviceFilePath.path) else {
                return
            }
            
            let getAllImage = ID3PictureType.allCases.compactMap({ type in (tag.frames[.attachedPicture(type)] as? ID3FrameAttachedPicture)})
            
            let frontImage = getAllImage.count > 0 ? UIImage(data: getAllImage[0].picture)! : UIImage()

            var tagAllCases = FrameName.allCases.map { $0 }.filter { !$0.caseName.lowercased().contains("picture") }
            
            let ownFrameKey = tag.frames.keys.filter { (tag.frames[$0] as? ID3FrameWithStringContent) != nil }.map { $0 }
            
//            _ = tag.frames.keys.filter { (tag.frames[$0] as? ID3FrameWithIntegerContent) != nil }.map { $0 }
            let text = ownFrameKey.map { TagFileDetailListTextCell(title: $0, text: (tag.frames[$0] as! ID3FrameWithStringContent).content) }
            
            // 남아 있는 태그 정리.
            ownFrameKey.forEach { (f:FrameName) in tagAllCases.removeAll(where: { $0 == f } ) }
            
            tagModel = TagFileDetailListModel(image: frontImage, tag: text)
            addableTag = tagAllCases.map { $0 }
            
        }catch {
            print(error)
            return
        }
    }
}
