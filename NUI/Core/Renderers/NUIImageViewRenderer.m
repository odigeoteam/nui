//
//  NUIImageViewRenderer.m
//  Pods
//
//  Created by Victor Rodriguez on 14/07/15.
//
//

#import "NUIImageViewRenderer.h"

@implementation NUIImageViewRenderer

+ (void)renderImageView:(UIImageView*)imageView withClass:(NSString*)className
{
    [self render:imageView withClass:className withSuffix:@""];
}

+ (void)render:(UIImageView*)imageView withClass:(NSString*)className withSuffix:(NSString*)suffix
{
    if (![suffix isEqualToString:@""]) {
        className = [NSString stringWithFormat:@"%@%@", className, suffix];
    }
    
    if ([NUISettings hasProperty:@"tint-color" withClass:className]) {
        imageView.tintColor = [NUISettings getColor:@"tint-color" withClass:className];
    }
    
    if ([NUISettings hasProperty:@"image-name" withClass:className]) {
        
        UIImage *image = [NUISettings getImage:@"image-name" withClass:className];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [imageView setImage:image];
    }
}

@end
