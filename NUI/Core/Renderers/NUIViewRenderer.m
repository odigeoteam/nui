//
//  NUIViewRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUIViewRenderer.h"
#import "NUILayerRenderer.h"

@implementation NUIViewRenderer

+ (void)render:(UIView*)view withClass:(NSString*)className
{
    if ([NUISettings hasProperty:@"background-image" withClass:className]) {
        if ([NUISettings hasProperty:@"background-repeat" withClass:className] && ![NUISettings getBoolean:@"background-repeat" withClass:className]) {
            view.layer.contents = (__bridge id)[NUISettings getImage:@"background-image" withClass:className].CGImage;
        } else {
            [view setBackgroundColor: [NUISettings getColorFromImage:@"background-image" withClass: className]];
        }
    } else if ([NUISettings hasProperty:@"background-color" withClass:className]) {
        [view setBackgroundColor: [NUISettings getColor:@"background-color" withClass: className]];
    }

    if ([NUISettings hasProperty:@"tint-color" withClass:className]) {
        [view setTintColor:[NUISettings getColor:@"tint-color" withClass:className]];
    }
    
    if ([NUISettings hasProperty:@"hidden" withClass:className]) {
        [view setHidden:[NUISettings getBoolean:@"hidden" withClass:className]];
    }
    
    [self renderSize:view withClass:className];
    [self renderBorderAndCorner:view withClass:className];
    [self renderShadow:view withClass:className];
}

+ (void)renderBorderAndCorner:(UIView*)view withClass:(NSString*)className
{
    CALayer *layer = [view layer];

    if ([NUISettings hasProperty:@"borders" withClass:className]) {
        
        [NUILayerRenderer renderLayer:layer withClass:className];
        // Set the view backgroundColor to clearColor because the color has been transferred to the Layer
        [view setBackgroundColor:[UIColor clearColor]];
    } else {
        if ([NUISettings hasProperty:@"border-color" withClass:className]) {
            [layer setBorderColor:[[NUISettings getColor:@"border-color" withClass:className] CGColor]];
        }
    
        if ([NUISettings hasProperty:@"border-width" withClass:className]) {
            [layer setBorderWidth:[NUISettings getFloat:@"border-width" withClass:className]];
        }
        
        if ([NUISettings hasProperty:@"corners" withClass:className]) {
            UIEdgeInsets corners = [NUISettings getEdgeInsets:@"corners" withClass:className];
            float cornerRadius = [self calculateCornerRadius:corners withClass:className];
            [self renderRoundCorners:view onTopLeft:corners.top > 0 topRight:corners.right > 0 bottomLeft:corners.left > 0 bottomRight:corners.bottom > 0 radius:cornerRadius];
        } else {
            if ([NUISettings hasProperty:@"corner-radius" withClass:className]) {
                [layer setCornerRadius:[NUISettings getFloat:@"corner-radius" withClass:className]];
                layer.masksToBounds = YES;
            }
        }
    }
}

+ (void)renderRoundCorners:(UIView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius {

    if (tl || tr || bl || br) {
        UIRectCorner corner = 0; //holds the corner
        //Determine which corner(s) should be changed
        if (tl) {
            corner = corner | UIRectCornerTopLeft;
        }
        if (tr) {
            corner = corner | UIRectCornerTopRight;
        }
        if (bl) {
            corner = corner | UIRectCornerBottomLeft;
        }
        if (br) {
            corner = corner | UIRectCornerBottomRight;
        }

        UIView *roundedView = view;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = roundedView.bounds;
        maskLayer.path = maskPath.CGPath;
        roundedView.layer.mask = maskLayer;

        CAShapeLayer *frameLayer = [CAShapeLayer layer];
        frameLayer.frame = roundedView.bounds;
        frameLayer.path = maskPath.CGPath;
        frameLayer.strokeColor = roundedView.layer.borderColor;
        frameLayer.lineWidth = roundedView.layer.borderWidth*2;
        frameLayer.fillColor = nil;

        [view.layer addSublayer:frameLayer];
    }
}

+ (float)calculateCornerRadius:(UIEdgeInsets)corners withClass:(NSString *)className {

    if ([NUISettings hasProperty:@"corner-radius" withClass:className]) {
        return [NUISettings getFloat:@"corner-radius" withClass:className];
    }

    NSArray *cornersArray = @[@(corners.top), @(corners.left), @(corners.right), @(corners.bottom)];

    return [[cornersArray valueForKeyPath:@"@max.self"] floatValue];
}

+ (void)renderShadow:(UIView*)view withClass:(NSString*)className
{
    CALayer *layer = [view layer];

    if ([NUISettings hasProperty:@"shadow-radius" withClass:className]) {
        [layer setShadowRadius:[NUISettings getFloat:@"shadow-radius" withClass:className]];
    }

    if ([NUISettings hasProperty:@"shadow-offset" withClass:className]) {
        [layer setShadowOffset:[NUISettings getSize:@"shadow-offset" withClass:className]];
    }

    if ([NUISettings hasProperty:@"shadow-color" withClass:className]) {
        [layer setShadowColor:[NUISettings getColor:@"shadow-color" withClass:className].CGColor];
    }

    if ([NUISettings hasProperty:@"shadow-opacity" withClass:className]) {
        [layer setShadowOpacity:[NUISettings getFloat:@"shadow-opacity" withClass:className]];
    }
}

+ (void)renderSize:(UIView*)view withClass:(NSString*)className
{
    CGFloat height = view.frame.size.height;
    if ([NUISettings hasProperty:@"height" withClass:className]) {
        height = [NUISettings getFloat:@"height" withClass:className];
    }

    CGFloat width = view.frame.size.width;
    if ([NUISettings hasProperty:@"width" withClass:className]) {
        width = [NUISettings getFloat:@"width" withClass:className];
    }

    if (height != view.frame.size.height || width != view.frame.size.width) {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, width, height);
    }
}

+ (BOOL)hasShadowProperties:(UIView*)view withClass:(NSString*)className {

    BOOL hasAnyShadowProperty = NO;
    for (NSString *property in @[@"shadow-radius", @"shadow-offset", @"shadow-color", @"shadow-opacity"]) {
        hasAnyShadowProperty |= [NUISettings hasProperty:property withClass:className];
    }
    return hasAnyShadowProperty;
}

@end
