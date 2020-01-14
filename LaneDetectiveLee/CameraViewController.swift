//
// Created by Dongwook Lee on 2020/01/14.
// Copyright (c) 2020 Dable. All rights reserved.
//

import UIKit
import SwiftUI
import AVFoundation

class CameraViewController: UIHostingController<ContentView>, AVCaptureVideoDataOutputSampleBufferDelegate {

    private var captureSession: AVCaptureSession = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()

    @State var capturedImage: UIImage = UIImage(named:"camera_icon")!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let contentView = ContentView(cameraImage:self.$capturedImage)
        self.rootView = contentView //?
    }

    public init() {
        super.init(rootView)
        let contentView = ContentView(cameraImage:self.$capturedImage)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func prepareCameraCapture() {
        self.addCameraInput()
        self.getFrames()
        self.captureSession.startRunning()
    }

    private func addCameraInput() {
        print("add camera input")
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera,
                                                                          .builtInDualCamera,
                                                                          .builtInTrueDepthCamera],
                mediaType: .video,
                position: .back).devices.first else {
            fatalError("No back camera found. 진짜 기기에서 동작하고 있나요?")
        }
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        self.captureSession.addInput(cameraInput)
    }

    private func getFrames() {
        print("get frames")
        videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera.frame.processing.queue"))
        self.captureSession.addOutput(videoDataOutput)
        guard let connection = self.videoDataOutput.connection(with: AVMediaType.video),
              connection.isVideoOrientationSupported else { return }
        connection.videoOrientation = .portrait
    }

    func captureOutput(
            _ output: AVCaptureOutput,
            didOutput sampleBuffer: CMSampleBuffer,
            from connection: AVCaptureConnection) {
        // here we can process the frame
        print("captureOutput")

        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags.readOnly)

        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        guard let quartzImage = context?.makeImage() else { return }
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags.readOnly)
        let image = UIImage(cgImage: quartzImage)
        let imageWithLaneOverlay = LaneDetectorBridge().detectLane(in: image)
        DispatchQueue.main.async {
            if (imageWithLaneOverlay != nil) {
                self.capturedImage = imageWithLaneOverlay!
                print(capture)
            }
        }
    }
}
