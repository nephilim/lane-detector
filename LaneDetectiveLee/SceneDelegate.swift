//
//  SceneDelegate.swift
//  LaneDetectiveLee
//
//  Created by Dongwook Lee on 2019/12/25.
//  Copyright © 2019 Dable. All rights reserved.
//

import UIKit
import SwiftUI
import AVFoundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {

    var window: UIWindow?

    private var captureSession: AVCaptureSession = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    private func addCameraInput() {
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
        print("did receive frame")
    }
    
    func viewDidLoadLaa() {
        self.addCameraInput()
        self.getFrames()
        self.captureSession.startRunning()
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            self.viewDidLoadLaa()
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

