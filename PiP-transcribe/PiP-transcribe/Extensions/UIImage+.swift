//
//  UIImage+.swift
//  PiP-transcribe
//
//  Created by kazunori.aoki on 2021/12/08.
//

import UIKit
import AVKit
import AVFoundation

extension UIImage {

    var cmSampleBuffer: CMSampleBuffer? {
        guard let jpegData = jpegData(compressionQuality: 1) else { return nil }
        return sampleBufferFromJPEGData(jpegData)
    }

    private func sampleBufferFromJPEGData(_ jpegData: Data) -> CMSampleBuffer? {

        guard let cgImage = cgImage else { return nil }
        let rawPixelSize = CGSize(width: cgImage.width, height: cgImage.height)

        var format: CMFormatDescription? = nil
        _ = CMVideoFormatDescriptionCreate(allocator: kCFAllocatorDefault,
                                           codecType: kCMVideoCodecType_JPEG,
                                           width: Int32(rawPixelSize.width),
                                           height: Int32(rawPixelSize.height),
                                           extensions: nil,
                                           formatDescriptionOut: &format)

        do {
            let cmBlockBuffer = try jpegData.toCMBlockBuffer()
            var size = jpegData.count
            var sampleBuffer: CMSampleBuffer? = nil
            let nowTime = CMTime(seconds: CACurrentMediaTime(), preferredTimescale: 60)
            let _1_60_s = CMTime(value: 1, timescale: 60)

            var timingInfo = CMSampleTimingInfo(duration: _1_60_s,
                                                presentationTimeStamp: nowTime,
                                                decodeTimeStamp: .invalid)

            _ = CMSampleBufferCreateReady(allocator: kCFAllocatorDefault,
                                          dataBuffer: cmBlockBuffer,
                                          formatDescription: format,
                                          sampleCount: 1,
                                          sampleTimingEntryCount: 1,
                                          sampleTimingArray: &timingInfo,
                                          sampleSizeEntryCount: 1,
                                          sampleSizeArray: &size,
                                          sampleBufferOut: &sampleBuffer)

            if sampleBuffer != nil {
                return sampleBuffer
            } else {
                print("sample buffer is nil")
                return nil
            }

        } catch {
            print("error ugh", error)
            return nil
        }
    }
}
