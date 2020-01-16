//
//  CapturedImageView.swift
//  LaneDetectiveLee
//
//  Created by Dongwook Lee on 2020/01/15.
//  Copyright © 2020 Dable. All rights reserved.
//

import SwiftUI
import AVFoundation

struct CameraCaptureImageView: UIViewRepresentable {
    
    @Binding var capturedImage:UIImage?
    
    func makeUIView(context: UIViewRepresentableContext<CameraCaptureImageView>) -> UIImageView {
        print("make ui view")
        let uiCameraCaptureImageView = UIImageView()
        return uiCameraCaptureImageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: UIViewRepresentableContext<CameraCaptureImageView>) {
        uiView.image = capturedImage
        print("update ui view")
    }
    
    func makeCoordinator() -> Coordinator {
        print("make coordinator")
        let coordinator = Coordinator.init(self)
        coordinator.startCameraCapture()
        return coordinator
    }

    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        
        @Binding private var capturedImage:UIImage?
        
        let cameraCaptureImageView: CameraCaptureImageView
        init(_ cameraCaptureImageView: CameraCaptureImageView) {
            self.cameraCaptureImageView = cameraCaptureImageView
            self._capturedImage = cameraCaptureImageView.$capturedImage
        }
    
        
        private var captureSession: AVCaptureSession = AVCaptureSession()
        private let videoDataOutput = AVCaptureVideoDataOutput()
        
        public func startCameraCapture() {
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
                    // print("-> captured!")
                    self.capturedImage = imageWithLaneOverlay
                }
            }
        }
        
    }
    
}
