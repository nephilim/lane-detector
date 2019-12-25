//
//  LaneDetectorBridege.h
//  LaneDetectiveLee
//
//  Created by Dongwook Lee on 2019/12/25.
//  Copyright © 2019 Dable. All rights reserved.
//

#ifndef LaneDetectorBridege_h
#define LaneDetectorBridege_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LaneDetectorBridge : NSObject

- (UIImage *) detectLaneIn: (UIImage *) image;

@end

#endif /* LaneDetectorBridege_h */
