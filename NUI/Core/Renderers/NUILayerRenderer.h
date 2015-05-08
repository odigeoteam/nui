//
//  NUILayerRenderer.h
//  Pods
//
//  Created by Pablo Lerma on 06/05/15.
//
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "NUISettings.h"

@interface NUILayerRenderer : NSObject

+ (void)renderLayer:(CALayer *)layerToRender withClass:(NSString *)className;

@end
