//
//  PLRGBtoI420Processor.h
//  PLMediaStreamingKit
//
//  Created by suntongmian on 16/10/26.
//  Copyright © 2016年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreVideo/CoreVideo.h>

/*!
 @struct	PLI420PixelBuffer
 @abstract   I420 data.
 
 @since      v2.1.3
 */
typedef struct {
    int width;
    int height;
    int stride[3]; // Y, U, V Stride 行跨度
    void* baseAddress;
    void* baseAddressOfPlane[3]; // Y, U, V Buffer
} PLI420PixelBuffer;

/*!
 @typedef	PLI420PixelBufferRef
 @abstract   Based on the image buffer type. The pixel buffer implements the memory storage for an image buffer.
 
 @since      v2.1.3
 */
typedef PLI420PixelBuffer* PLI420PixelBufferRef;

#if defined __cplusplus
extern "C" {
#endif
    int PLI420PixelBufferNew(int width, int height, int y_stride, int u_stride, int v_stride, PLI420PixelBufferRef* pixelBufferOut);
    int PLI420PixelBufferCreate(int width, int height, PLI420PixelBufferRef* pixelBufferOut); // 通过图像的宽度和高度来分配内存
    int PLI420PixelBufferCreateWithStride(int width, int height, PLI420PixelBufferRef* pixelBufferOut); // 通过图像的跨度（图像宽度＋填充宽度）和高度分配内存
    void PLI420PixelBufferRelease(PLI420PixelBufferRef pixelBuffer);
    void* PLI420PixelBufferGetBaseAddress(PLI420PixelBufferRef pixelBuffer);
    void* PLI420PixelBufferGetBaseAddressOfPlane(PLI420PixelBufferRef pixelBuffer, int planeIndex);
    int PLI420PixelBufferGetStrideOfPlane(PLI420PixelBufferRef pixelBuffer, int planeIndex);
#if defined __cplusplus
};
#endif


/*!
 @class      PLRGBtoI420Processor
 @abstract   PLRGBtoI420Processor 用于将 BGRA32 图像转为 I420 图像
 
 @since      v2.1.3
 */
@interface PLRGBtoI420Processor : NSObject

/**
 @brief 用于处理图像的接口
 
 @param pixelBuffer 原始图像的对象
 
 @return 处理之后的 PLI420PixelBufferRef 对象
 
 @discussion 使用该接口进行图像处理需要注意的是，为了保持图像处理的效率，减小开销，该类内部会持有一个 CVPixelBufferRef 并在每次都会返回该对象，因此在每次调用之后请确认对返回的数据已经使用完毕再进行下一次调用，否则会出现非预期的问题
 */
- (PLI420PixelBufferRef)process:(CVPixelBufferRef)pixelBuffer;

@end
