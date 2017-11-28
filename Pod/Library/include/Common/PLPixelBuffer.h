//
//  PLPixelBuffer.h
//  PLMediaStreamingKit
//
//  Created by WangSiyu on 28/09/2016.
//  Copyright © 2016 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "PLRGBtoI420Processor.h"

@interface PLPixelBuffer : NSObject

@property(nonatomic, assign) CVPixelBufferRef pixelBuffer;
@property(nonatomic, assign) PLI420PixelBufferRef i420pixelBuffer;
@property(nonatomic, assign) BOOL freeWhenDone;

- (instancetype)initWithCVPixelBuffer:(CVPixelBufferRef)pixelBuffer;
- (instancetype)initWithI420PixelBuffer:(PLI420PixelBufferRef)pixelBuffer freeWhenDone:(BOOL)freeWhenDone;

@end
