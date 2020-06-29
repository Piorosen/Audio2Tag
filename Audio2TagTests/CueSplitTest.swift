//
//  Audio2TagTests.swift
//  Audio2TagTests
//
//  Created by Aoikazto on 2020/06/04.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import XCTest
import CueSheet


@testable import Audio2Tag

class Audio2TagTests: XCTestCase {
    func getResources() -> URL {
        return Bundle(for: type(of: self)).bundleURL.appendingPathComponent("Contents").appendingPathComponent("Resources")
    }
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    func testCueSplit() {
        
    }
    
    func testCueRead() {
        let resources = getResources()
        
        guard let list = try? FileManager.default.contentsOfDirectory(at: resources, includingPropertiesForKeys: nil) else {
            XCTFail("not found : resource folder")
            return
        }
        
        for i in list {
            let fileDir = resources.appendingPathComponent(i.lastPathComponent, isDirectory: true)
            
            guard let list = try? FileManager.default.contentsOfDirectory(at: fileDir, includingPropertiesForKeys: nil) else {
                XCTFail("not found : test resource folder list")
                return
            }
            
            guard let name = list.first(where: { url in url.pathExtension.lowercased() == "cue" }) else {
                XCTFail("not found : cue file")
                return
            }
            
            let parser = CueSheetParser()
            guard let cue = parser.Load(path: name) else {
                XCTFail("load fail : cue file")
                return
            }
            let music = name.deletingLastPathComponent().appendingPathComponent(cue.file.fileName)
            
            guard parser.loadFile(pathOfMusic: music, pathOfCue: name)?.info != nil else {
                XCTFail("load fail : cue file and Music file")
                return
            }
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
