//
//  LaneDetectorBridge.m
//  LaneDetectiveLee
//
//  Created by Dongwook Lee on 2019/12/25.
//  Copyright © 2019 Dable. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <Foundation/Foundation.h>
#import "LaneDetectorBridge.h"
#include "LaneDetector.hpp"

@implementation LaneDetectorBridge

- (UIImage *) detectLaneIn: (UIImage *) image {
    
    // convert uiimage to mat
    cv::Mat opencvImage;
    UIImageToMat(image, opencvImage, true);
    
    // convert colorspace to the one expected by the lane detector algorithm (RGB)
    cv::Mat convertedColorSpaceImage;
    cv::cvtColor(opencvImage, convertedColorSpaceImage, COLOR_RGBA2RGB);
    
    // Run lane detection
    LaneDetector laneDetector;
    cv::Mat imageWithLaneDetected = laneDetector.detect_lane(convertedColorSpaceImage);
    
    // convert mat to uiimage and return it to the caller
    return MatToUIImage(imageWithLaneDetected);
}

@end
