//
//  ODGCALayer.h
//  ios-whitelabel
//
//  Created by Jorge Salgado on 28/02/14.
//  Copyright (c) 2014 ODIGEO. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface NUICALayer : CALayer

@property(nonatomic, strong) UIColor *customBorderColor;
@property(nonatomic, strong) UIColor *customBackgroundColor;

@property(nonatomic, assign) UIRectCorner cornerRect;
@property(nonatomic, assign) UIRectEdge borderRect;
@property(nonatomic, assign) CGFloat customCornerRadius;

@property(nonatomic, assign) CGFloat customBorderWidth;
@property(nonatomic, assign) CGFloat bottomLeftOffset;

- (void)shouldUpdateSublayers;

@end
