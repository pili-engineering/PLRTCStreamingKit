//
//  PLVideoCompositionDescription.h
//  PLMediaStreamingKit
//
//  Created by WangSiyu on 28/09/2016.
//  Copyright © 2016 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PLVideoCompositionDescription : NSObject <NSCopying>

/**
 @brief 当被裁剪的部分比例与在新图中需要安放的位置的比例不同时选择的填充模式
 */
typedef NS_ENUM(NSInteger, PLPixelAspectMode)
{
    /**
     @brief 保持原图比例并嵌入新图来填充
     */
    PLPixelAspectModeFit,
    
    /**
     @brief 保持原图比例并将新图填充满
     */
    PLPixelAspectModeFill
};

/**
 @brief 需要从原始图片中裁剪出来的部分的位置和大小
 */
@property (nonatomic, assign) CGRect sourceRect;

/**
 @brief 裁剪出来的部分放置在新图之中的位置和大小
 */
@property (nonatomic, assign) CGRect destRect;

/**
 @brief 在新图中叠加时使用的 Z 坐标，当叠加时，Z 坐标较大者将覆盖 Z 坐标较小者
 */
@property (nonatomic, assign) NSUInteger zOrder;

/**
 @brief 当被裁剪的部分比例与在新图中需要安放的位置的比例不同时选择的填充模式
 */
@property (nonatomic, assign) PLPixelAspectMode aspectMode;

/**
 @brief 用于初始化 PLVideoCompositionDescription 对象的方法
 
 @param sourceRect 需要从原始图片中裁剪出来的部分的位置和大小
 
 @param destRect 裁剪出来的部分放置在新图之中的位置和大小

 @param zOrder 在新图中叠加时使用的 Z 坐标，当叠加时，Z 坐标较大者将覆盖 Z 坐标较小者

 @param aspectMode 当被裁剪的部分比例与在新图中需要安放的位置的比例不同时选择的填充模式

 @return 初始化后的 PLVideoCompositionDescription 对象
 */
- (instancetype)initWithSourceRect:(CGRect)sourceRect destRect:(CGRect)destRect zOrder:(CGFloat)zOrder aspectMode:(PLPixelAspectMode)aspectMode;

@end
