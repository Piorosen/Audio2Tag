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
                    callback(i, size, sum.reduce(0, +))
                }
                
            }
        }
    }
    
    func startAssetReaderAndWriter(value: (url:URL, range:CMTimeRange), percentCallback: @escaping (Float) -> Void) -> Bool {
        let assetReader = try? AVAssetReader(asset: asset)
        let assetWriter = try? AVAssetWriter(outputURL: value.url, fileType: .wav)
        
        var assetAudioTrack:AVAssetTrack? = nil
        let audioTracks = asset.tracks(withMediaType: .audio)
        
        if (audioTracks.count > 0) {
            assetAudioTrack = audioTracks[0]
        }
        
        guard let file = try? AVAudioFile(forReading: inputURL) else {
            return false
        }
        let outputSettings = file.fileFormat.settings
        
        if (assetAudioTrack == nil) {
            return false
        }
        
        let assetReaderAudioOutput = AVAssetReaderTrackOutput(track: assetAudioTrack!, outputSettings: [AVFormatIDKey:Int(kAudioFormatLinearPCM)])
        
        assetReader!.add(assetReaderAudioOutput)
        
        let assetWriterAudioInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: outputSettings)
        
        assetWriter!.add(assetWriterAudioInput)
        
        
        // MARK: - ga
        let delay = DispatchSemaphore(value: 0)
        print("STARTING ASSET WRITER")
        
        assetReader!.timeRange = value.range
        
        assetWriter!.startWriting()
        assetReader!.startReading()
        assetWriter!.startSession(atSourceTime: CMTime.zero)
        //    assetWriter.endSession(atSourceTime: CMTime(seconds: 1000, preferredTimescale: 1))
        //    assetWriter.endSession(atSourceTime: CMTime(seconds: 100, preferredTimescale: 1))
        
        assetWriterAudioInput.requestMediaDataWhenReady(on: DispatchQueue(label: "gogogo")) {
            while(assetWriterAudioInput.isReadyForMoreMediaData ) {
                var sampleBuffer = assetReaderAudioOutput.copyNextSampleBuffer()
                
                if(sampleBuffer != nil) {
                    let timeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer!)
                    let timeSecond = CMTimeGetSeconds(timeStamp - value.range.start)
                    
                    let per = timeSecond / CMTimeGetSeconds(value.range.duration)
                    percentCallback(Float(per))
                    
                    assetWriterAudioInput.append(sampleBuffer!)
                    sampleBuffer = nil
                } else {
                    assetWriterAudioInput.markAsFinished()
                    assetReader!.cancelReading()
                    assetWriter!.finishWriting {
                        delay.signal()
                        print("Asset Writer Finished Writing")
                    }
                    break
                }
            }
            
            percentCallback(1)
        }
        
        delay.wait()
        return true
    }
}
