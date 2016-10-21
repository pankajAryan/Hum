//
//  UIImage+Scale.h
//  FabFurnish
//
//  Created by Avneesh.minocha on 20/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)
//- (UIImage *)imagescaledToSize:(CGSize)newSize;
//+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;
+(UIImage *)ffplaceHolder;
+(UIImage *)ffplaceHolderWhiteBackground;
+(UIImage *)ffplaceHolderWithSquareDimension;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end
