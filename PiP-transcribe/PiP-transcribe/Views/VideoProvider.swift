//
//  VideoProvider.swift
//  PiP-transcribe
//
//  Created by kazunori.aoki on 2021/12/08.
//

import UIKit
import AVKit
import AVFoundation

class VideoProvider: NSObject {

    // MARK: UI
    private let _label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.frame = .init(x: 0, y: 0, width: 200, height: 30)
        label.font = .boldSystemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = .black

        return label
    }()


    // MARK: Property
    private var timer: Timer!
    var bufferDisplayLayer = AVSampleBufferDisplayLayer()


    // MARK: Public
    // 現在時刻を表示
    func nextBuffer() -> UIImage {
        _label.text = "\(Date())"
        return _label.uiImage
    }

    func start() {
        let timerBlock: ((Timer) -> ()) = { [weak self] timer in
            guard let buffer = self?.nextBuffer().cmSampleBuffer else { return }
            self?.bufferDisplayLayer.enqueue(buffer)
        }

        timer = Timer(timeInterval: 0.3, repeats: true, block: timerBlock)
        RunLoop.main.add(timer, forMode: .default)
    }

    func stop() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }

    func isRunning() -> Bool {
        return timer != nil
    }
}
