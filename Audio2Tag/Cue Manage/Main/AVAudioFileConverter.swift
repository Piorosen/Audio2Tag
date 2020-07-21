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
        guard let tracks = asset.tracks(withMediaType: AVMediaType.audio).first else { return nil }
        
        track = tracks
        outputSettings = file.fileFormat.settings
    }
    
    public func convert(callback: @escaping (_ index:Int, _ ownProgress:Float, _ totalProgress:Float) -> Void) {
        asset.loadValuesAsynchronously(forKeys: ["tracks"]) {
            var progress = [Float](repeating: 0, count: self.outputURL.count)
            for i in self.outputURL.indices {
                var localError:NSError?
                var success = self.asset.statusOfValue(forKey: "tracks", error: &localError) == AVKeyValueStatus.loaded
                assert(success, "Ha..")
                
                
                let result = self.startAssetReaderAndWriter(value: self.outputURL[i]) { [i] p in
                    progress[i] = Float(1) / Float(self.outputURL.count) * p
                    callback(i, p, progress.reduce(0, +))
                }
                print("\(result)")
            }
        }
    }
    
    func startAssetReaderAndWriter(value: (url:URL, range:CMTimeRange), percentCallback: @escaping (Float) -> Void) -> Bool {
        guard let assetWriter = try? AVAssetWriter(outputURL: value.url, fileType: .wav) else {
            return false
        }
        
        guard let assetReader = try? AVAssetReader(asset: asset) else {
            return false
        }
        
        let assetReaderAudioOutput = AVAssetReaderTrackOutput(track: track, outputSettings: [AVFormatIDKey:Int(kAudioFormatLinearPCM)])
        assetReader.add(assetReaderAudioOutput)
        
        let assetWriterAudioInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: outputSettings)
        assetWriter.add(assetWriterAudioInput)
        assetWriter.startWriting()
        assetWriter.startSession(atSourceTime: CMTime.zero)
        
        assetWriterAudioInput.requestMediaDataWhenReady(on: dispatch) {
            assetReader.timeRange = value.range
            assetReader.startReading()
            
            while(assetWriterAudioInput.isReadyForMoreMediaData) {
                if let sampleBuffer = assetReaderAudioOutput.copyNextSampleBuffer() {
                    let timeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
                    let timeSecond = CMTimeGetSeconds(timeStamp - value.range.start)
                    
                    let per = timeSecond / CMTimeGetSeconds(value.range.duration)
                    percentCallback(Float(per))
                    
                    assetWriterAudioInput.append(sampleBuffer)
                    continue
                }else {
                    assetWriterAudioInput.markAsFinished()
                    assetReader.cancelReading()
                    assetWriter.finishWriting {
                        percentCallback(1)
                    }
                    break
                }
            }
        }
        
        return true
    }
}
