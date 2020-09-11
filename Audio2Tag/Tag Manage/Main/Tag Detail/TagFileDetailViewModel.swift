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
    @Published var openSheet = false
    @Published var openCustomAlert = false
    @Published var openCustomEditAlert = false
    @Published var openAlert = false
    
    @Published var remainTag = [String]()
    @Published var selectTitle = ""
    
    var selectedTagTitle = ""
    var selectedTagText = ""
    
    
    init(data: TagModel) {
        do {
            
            guard let tag = try ID3TagEditor().read(from: data.deviceFilePath.path) else {
                return
            }
            
            let getAllImage = ID3PictureType.allCases.compactMap({ type in (tag.frames[.AttachedPicture(type)] as? ID3FrameAttachedPicture)})
            
            //            print(getAllImage)
            let frontImage = getAllImage.count > 0 ? UIImage(data: getAllImage[0].picture)! : UIImage()
            var aa = FrameName.allCases.map { $0 }
            
            let p = tag.frames.keys.filter { (tag.frames[$0] as? ID3FrameWithStringContent) != nil }.map { $0 }
            
            _ = tag.frames.keys.filter { (tag.frames[$0] as? ID3FrameWithIntegerContent) != nil }.map { $0 }
            let text = p.map { TagFileDetailListTextCell(title: $0.caseName, text: (tag.frames[$0] as! ID3FrameWithStringContent).content) }
            
            p.forEach { (f:FrameName) in aa.removeAll(where: { $0 == f } ) }
            
            tagModel = TagFileDetailListModel(image: frontImage, tag: text)
            remainTag = aa.map { $0.caseName }
            
        }catch {
            print(error)
        }
    }
    
    func editTag(_ title:String, _ text:String){
        if let index = tagModel.tag.firstIndex(where: { e in e.title == title }) {
            tagModel.tag[index].text = text
            print(tagModel.tag)
        }
        remainTag = remainTag.filter { i in i != title }
        
    }
    
    func selectTag(_ item: String) {
        selectTitle = item
        openSheet = true
    }
    
}
