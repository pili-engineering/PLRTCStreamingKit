//
//  PLPixelBufferProcessor.h
//  PLMediaStreamingKit
//
//  Created by WangSiyu on 9/11/16.
//  Copyright © 2016 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreVideo/CoreVideo.h>
#import "PLVideoCompositionDescription.h"
#import "PLPixelBuffer.h"
#import "PLRGBtoI420Processor.h"

/*!
 @protocol   PLPixelBufferProcessProtocol
 @abstract   PLPixelBufferProcessProtocol 用于对图像进行裁剪和缩放的协议
 
 @since      v2.1.2
 */
@protocol PLPixelBufferProcessProtocol <NSObject>

/**
 @brief 用于描述原始视频帧中裁剪的位置及在新图当中叠加的位置，需要注意的是传入之后该队列将按照 zOrder 进行升序重排再储存在 videoCompositionDescriptions 属性中。
 */
@property (nonatomic, strong) NSArray<PLVideoCompositionDescription *>* videoCompositionDescriptions;

/**
 @brief 新图的整体画幅大小
 */
@property (nonatomic, assign) CGSize destFrameSize;

/**
 @brief 初始化一个 PLPixelBufferProcessor 对象
 
 @param destFrameSize 新图的整体画幅大小
 @param videoCompositionDescriptions    用于描述原始视频帧中裁剪的位置及在新图当中叠加的位置，需要注意的是传入之后该队列将按照 zOrder 进行升序重排再储存在 videoCompositionDescriptions 属性中。
 
 @return 初始化后的 PLPixelBufferProcessor 对象
 */
- (instancetype)initWithDestFrameSize:(CGSize)destFrameSize videoCompositionDescriptions:(NSArray<PLVideoCompositionDescription *>*)videoCompositionDescriptions;

/**
 @brief 用于处理图像的接口
 
 @param sourceBuffers 原始图片的对象
 
 @return 处理之后的 CVPixelBufferRef 对象
 
 @discussion 使用该接口进行图像处理需要注意的是，为了保持图像处理的效率，减小开销，该类内部会持有一个 CVPixelBufferRef 并在每次都会返回该对象，因此在每次调用之后请确认对返回的数据已经使用完毕再进行下一次调用，否则会出现非预期的问题
 
 @warning 当传入的 sourceBuffers 的 count 与 videoCompositionDescriptions 的 count 不同时会直接抛错，请确保 videoCompositionDescriptions 的数量与 sourceBuffers 的数量始终一致
 */
- (CVPixelBufferRef)processSourceBuffers:(NSArray<PLPixelBuffer *> *)sourceBuffers;

- (PLI420PixelBufferRef)processI420SourceBuffers:(NSArray<PLPixelBuffer *> *)sourceBuffers;

@end

/*!
 @class      PLPixelBufferProcessor
 @abstract   PLPixelBufferProcessor 用于对图像进行裁剪和缩放
 
 @since      v2.1.2
 */
@interface PLPixelBufferProcessor : NSObject <PLPixelBufferProcessProtocol>

@end
