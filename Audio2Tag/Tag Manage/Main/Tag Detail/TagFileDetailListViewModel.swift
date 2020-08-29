//
//  TagFileDetailListViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/29.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import ID3TagEditor


class ID3TagVersionParser {
    private let versionBytesOffset = 3;
    
    func parse(mp3: Data) -> ID3Version {
        let version = ID3Version.version3
        if let validVersion = tryToGetVersionFrom(mp3: mp3) {
            return validVersion
        }
        return version
    }
    
    private func tryToGetVersionFrom(mp3: Data) -> ID3Version? {
        let version = [UInt8](mp3)[versionBytesOffset]
        return ID3Version(rawValue: version)
    }
}

class ID3TagConfiguration {
    private let headers: [ID3Version : [UInt8]] = [
        .version2 : [UInt8]("ID3".utf8) + [0x02, 0x00],
        .version3 : [UInt8]("ID3".utf8) + [0x03, 0x00],
        .version4 : [UInt8]("ID3".utf8) + [0x04, 0x00]
    ]
    private let tagHeaderSizeInBytes = 10

    func headerSize() -> Int {
        return tagHeaderSizeInBytes
    }

    func headerFor(version: ID3Version) -> [UInt8] {
        return [0, 0,0, 24, 102]
    }
}

class TagFileDetailListViewModel : ObservableObject {
    @Published var image = UIImage()
    
    init() {
        let p = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil)
        

        do {
            var data = try? Data(contentsOf: p![0])
            let tag = try ID3TagEditor().read(mp3: data!)
            print(tag)
        }catch {
            print(error)
        }
    }

    
}
