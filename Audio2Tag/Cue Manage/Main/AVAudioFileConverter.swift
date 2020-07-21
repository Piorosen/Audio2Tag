//
//  AVAudioFileConverter.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/20.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import AVFoundation

public final class AVAudioFileConverter {
    let asset:AVAsset
    
    let inputURL:URL
    let outputSettings: [String:Any]
    let outputURL:[(url:URL, range:CMTimeRange)]
    
    let dispatch = DispatchQueue(label: "split Music")
    let track: AVAssetTrack
    
    
    public init?(inputFileURL: URL, outputFileURL: [(url:URL, range:CMTimeRange)]) {
        inputURL = inputFileURL
        outputURL = outputFileURL
        asset = AVAsset(url: inputURL)
        
        guard let file = try? AVAudioFile(forReading: inputURL) else { return nil }
        guard let tracks = asset.tracks(withMediaType: .audio).first else { return nil }
        
        track = tracks
        outputSettings = file.fileFormat.settings
    }
    
    public func convert(callback: @escaping (_ index:Int, _ ownProgress:Float, _ totalProgress:Float) -> Void) {
        asset.loadValuesAsynchronously(forKeys: ["tracks"]) {
            var sum = [Float](repeating: 0, count: self.outputURL.count)
            
            for i in self.outputURL.indices {
                let _ = self.startAssetReaderAndWriter(value: self.outputURL[i]) { [i] p in
                    let _ = Float(i) / Float(self.outputURL.count)
                    let size = Float(1) / Float(self.outputURL.count) * p
                    sum[i] = size
                    callback(i, p, sum.reduce(0, +))
                }   
            }
        }
    }
    
    func startAssetReaderAndWriter(value: (url:URL, range:CMTimeRange), percentCallback: @escaping (Float) -> Void) -> Bool {
        guard let assetReader = try? AVAssetReader(asset: asset) else { return false }
        guard let assetWriter = try? AVAssetWriter(outputURL: value.url, fileType: .wav) else { return false }
        guard let assetAudioTrack = asset.tracks(withMediaType: .audio).first else { return false }
        guard let outputSettings = (try? AVAudioFile(forReading: inputURL))?.fileFormat.settings else { return false }
        
        let assetReaderAudioOutput = AVAssetReaderTrackOutput(track: assetAudioTrack, outputSettings: [AVFormatIDKey:Int(kAudioFormatLinearPCM)])
        assetReader.add(assetReaderAudioOutput)
        
        let assetWriterAudioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: outputSettings)
        assetWriter.add(assetWriterAudioInput)
        
        assetReader.timeRange = value.range
        assetWriter.startWriting()
        assetReader.startReading()
        assetWriter.startSession(atSourceTime: .zero)
        
        assetWriterAudioInput.requestMediaDataWhenReady(on: dispatch) {
            while(assetWriterAudioInput.isReadyForMoreMediaData ) {
                if let sampleBuffer = assetReaderAudioOutput.copyNextSampleBuffer() {
                    let timeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
                    let timeSecond = CMTimeGetSeconds(timeStamp - value.range.start)
                    let per = timeSecond / CMTimeGetSeconds(value.range.duration)
                    percentCallback(Float(per))
                    assetWriterAudioInput.append(sampleBuffer)
                }else {
                    assetWriterAudioInput.markAsFinished()
                    assetReader.cancelReading()
                    assetWriter.finishWriting {
                        print("Asset Writer Finished Writing")
                    }
                    break
                }
            }
            
            percentCallback(1)
        }
        return true
    }
}
