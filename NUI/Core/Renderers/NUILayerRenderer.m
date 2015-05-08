
#import "NUILayerRenderer.h"
#import "NUICALayer.h"

@implementation NUILayerRenderer

+ (void)renderLayer:(CALayer *)layer withClass:(NSString *)className {
    
    NUICALayer *layerToRender = [[NUICALayer alloc] init];
    layerToRender.frame = layer.bounds;
    
    if ([NUISettings hasProperty:@"background-color" withClass:className]) {
        UIColor *backgroundColor = [NUISettings getColor:@"background-color" withClass:className];
        [layerToRender setCustomBackgroundColor:backgroundColor];
    }
    
    if ([NUISettings hasProperty:@"corners" withClass:className]) {
        UIRectCorner corners = [NUISettings getRectCorner:@"corners" withClass:className];
        [layerToRender setCustomCornerRadius:[NUISettings getFloat:@"corner-radius" withClass:className]];
        [layerToRender setCornerRect:corners];
    } else {
        if ([NUISettings hasProperty:@"corner-radius" withClass:className]) {
            [layerToRender setCustomCornerRadius:[NUISettings getFloat:@"corner-radius" withClass:className]];
            [layerToRender setCornerRect:UIRectCornerAllCorners];
        }
    }
    
    if ([NUISettings hasProperty:@"border-width" withClass:className]) {
        [layerToRender setCustomBorderWidth:[NUISettings getFloat:@"border-width" withClass:className]];
    }
    
    if ([NUISettings hasProperty:@"border-color" withClass:className]) {
        [layerToRender setCustomBorderColor:[NUISettings getColor:@"border-color" withClass:className]];
    }

    if ([NUISettings hasProperty:@"borders" withClass:className]) {
        UIRectEdge borders = [NUISettings getRectEdge:@"borders" withClass:className];
        [layerToRender setBorderRect:borders];
    }
    
    [layerToRender shouldUpdateSublayers];

    [layer addSublayer:layerToRender];
}

@end
