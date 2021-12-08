//
//  ViewController.swift
//  PiP-transcribe
//
//  Created by kazunori.aoki on 2021/12/08.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {

    // MARK: UI
    private var _startButton: UIButton!


    // MARK: Property
    private let _pipContent = VideoProvider()
    private var _pipController: AVPictureInPictureController?
    private let _bufferDisplayLayer = AVSampleBufferDisplayLayer()
    private var _pipPossibleObservation: NSKeyValueObservation?


    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }


    // MARK: Public
    func start() {

        if AVPictureInPictureController.isPictureInPictureSupported() {

            _pipController = AVPictureInPictureController(
                contentSource: .init(sampleBufferDisplayLayer: _pipContent.bufferDisplayLayer,
                                     playbackDelegate: self))
            _pipController?.delegate = self

            _pipPossibleObservation = _pipController?
                .observe(\AVPictureInPictureController.isPictureInPicturePossible,
                          options: [.initial, .new],
                          changeHandler: { [weak self] _, change in
                guard let _self = self else { return }

                if change.newValue ?? false {
                    _self._startButton.isEnabled = change.newValue ?? false
                }
            })
        }
    }

    @objc
    func toggle() {
        guard let _pipController = _pipController else { return }
        if !_pipController.isPictureInPictureActive {
            _pipController.startPictureInPicture()
        } else {
            _pipController.stopPictureInPicture()
        }
    }
}


// MARK: - Setup
private extension ViewController {

    func setup() {
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playback, mode: .moviePlayback)
        try! session.setActive(true)

        _startButton = {
            let button = UIButton()
            let margin = (view.bounds.width - 200) / 2
            button.frame = .init(x: margin, y: 80, width: 200, height: 30)
            button.addTarget(self, action: #selector(toggle), for: .touchUpInside)
            button.setTitle("Start PiP", for: .normal)
            return button
        }()
        view.addSubview(_startButton)

        let videoContainerView = UIView()
        let margin = (view.bounds.width - 200) / 2
        videoContainerView.frame = .init(x: margin, y: 200, width: 200, height: 30)
        view.addSubview(videoContainerView)

        let bufferDisplayLayer = _pipContent.bufferDisplayLayer
        bufferDisplayLayer.frame = videoContainerView.bounds
        bufferDisplayLayer.videoGravity = .resizeAspect
        videoContainerView.layer.addSublayer(bufferDisplayLayer)

        _pipContent.start()

        DispatchQueue.main.async {
            self.start()
        }
    }
}


extension ViewController: AVPictureInPictureControllerDelegate {

    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController,
                                    failedToStartPictureInPictureWithError error: Error) {
        print(#function)
        print("pip error: \(error)")
    }

    func pictureInPictureControllerWillStartPictureInPicture(
        _ pictureInPictureController: AVPictureInPictureController) {
        print(#function)
    }

    func pictureInPictureControllerWillStopPictureInPicture(
        _ pictureInPictureController: AVPictureInPictureController) {
        print(#function)
    }
}


extension ViewController: AVPictureInPictureSampleBufferPlaybackDelegate {
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController,
                                    setPlaying playing: Bool) {
        print(#function)
    }

    func pictureInPictureControllerTimeRangeForPlayback(
        _ pictureInPictureController: AVPictureInPictureController) -> CMTimeRange {
        print(#function)
        return CMTimeRange(start: .negativeInfinity, end: .positiveInfinity)
    }

    func pictureInPictureControllerIsPlaybackPaused(
        _ pictureInPictureController: AVPictureInPictureController) -> Bool {
        print(#function)
        return false
    }

    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController,
                                    didTransitionToRenderSize newRenderSize: CMVideoDimensions) {
        print(#function)
    }

    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, skipByInterval skipInterval: CMTime, completion completionHandler: @escaping () -> Void) {
        print(#function)
    }
}
