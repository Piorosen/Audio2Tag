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
    //    public static allCases: [FrameName] {
    ////        return
    //
    //    }
}

struct TagFileDetailListModel : Identifiable {
    let id = UUID()
    let title :String
    var text: String = ""
}

class TagFileDetailListViewModel : ObservableObject {
    @Published var frontImage = UIImage()
    @Published var text = [TagFileDetailListModel]()
    @Published var openSheet = false
    
    @Published var remainTag = [String]()
    
    
    
    init() {
        let p = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil)
        
        do {
            guard let tag = try ID3TagEditor().read(from: p![0].path) else {
                return
            }
            
            let getAllImage = ID3PictureType.allCases.compactMap({ type in (tag.frames[.AttachedPicture(type)] as? ID3FrameAttachedPicture)})
            
            //            print(getAllImage)
            frontImage = getAllImage.count > 0 ? UIImage(data: getAllImage[0].picture)! : UIImage()
            var aa = FrameName.allCases.map { $0 }
            
            let p = tag.frames.keys.filter { (tag.frames[$0] as? ID3FrameWithStringContent) != nil }.map { $0 }
            
            let p1 = tag.frames.keys.filter { (tag.frames[$0] as? ID3FrameWithIntegerContent) != nil }.map { $0 }
            text = p.map { TagFileDetailListModel(title: $0.caseName, text: (tag.frames[$0] as! ID3FrameWithStringContent).content) }
            
            p.forEach { (f:FrameName) in aa.removeAll(where: { $0 == f } ) }
            
            remainTag = aa.map { $0.caseName }
            
            
        }catch {
            print(error)
        }
    }
    
    
}
