//
//  UIButton+NUI.m
//  NUIDemo
//
//  Created by Tom Benner on 12/8/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "UIButton+NUI.h"

@interface UIButton ()

@property (strong, nonatomic) UIColor *normalBorderColor;
@property (strong, nonatomic) UIColor *highlightedBorderColor;
@property (strong, nonatomic) UIColor *disabledBorderColor;
@property (strong, nonatomic) UIColor *selectedBorderColor;

@end

@implementation UIButton (NUI)

- (void)initNUI
{
    if (!self.nuiClass) {
        self.nuiClass = @"Button";
    }
}

- (void)applyNUI
{
    [self initNUI];
    BOOL forceRender = NO;
    NSString *selfClass = NSStringFromClass([self class]);
    NSString *superviewClass = NSStringFromClass([[self superview] class]);
    NSArray *bypassedClasses = [NSArray arrayWithObjects:@"UINavigationButton", nil];
    NSArray *bypassedSuperviewClasses = [NSArray arrayWithObjects:
                                         @"UICalloutBar",
                                         @"UISearchBarTextField",
                                         @"UIToolbarTextButton",
                                         nil];
    // By default, render UINavigationButtons in UISearchBar as BarButtons
    if ([selfClass isEqualToString:@"UINavigationButton"] &&
        [superviewClass isEqualToString:@"UISearchBar"]) {
        if ([self.nuiClass isEqualToString:@"Button"]) {
            self.nuiClass = @"BarButton:SearchBarButton";
        }
        forceRender = YES;
    }
    if (![self.nuiClass isEqualToString:kNUIClassNone]) {
        if ((![bypassedClasses containsObject:selfClass] &&
             ![bypassedSuperviewClasses containsObject:superviewClass]) ||
            forceRender) {
            [NUIRenderer renderButton:self withClass:self.nuiClass];
            [self transformText];
        }
    }
    self.nuiApplied = YES;
}

- (void)transformText
{
    if (![NUIRenderer needsTextTransformWithClass:self.nuiClass]) {
        return;
    }
    
    [self transformTitleForState:UIControlStateNormal];
    [self transformTitleForState:UIControlStateSelected];
    [self transformTitleForState:UIControlStateHighlighted];
    [self transformTitleForState:UIControlStateDisabled];
}

- (void)transformTitleForState:(UIControlState)state
{
    if ((NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_6_0)) {
        NSAttributedString *attributedTitle = [self attributedTitleForState:state];
        
        if (attributedTitle) {
            [self setAttributedTitle:attributedTitle forState:state];
        } else {
            [self setTitle:[self titleForState:state] forState:state];
        }
    } else {
        [self setTitle:[self titleForState:state] forState:state];
    }
}

- (void)override_didMoveToWindow
{
    if (!self.isNUIApplied) {
        [self applyNUI];
    }
    [self override_didMoveToWindow];
}

- (void)override_setTitle:(NSString *)title forState:(UIControlState)state
{
    NSString *transformedTitle = title;
    
    if (title && self.nuiClass && ![self.nuiClass isEqualToString:kNUIClassNone]) {
        transformedTitle = [NUIRenderer transformText:title withClass:self.nuiClass];
    }
    
    [self override_setTitle:transformedTitle forState:state];
}

- (void)override_setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state
{
    NSAttributedString *transformedTitle = title;
    
    if (title && self.nuiClass && ![self.nuiClass isEqualToString:kNUIClassNone]) {
        transformedTitle = [NUIRenderer transformAttributedText:title withClass:self.nuiClass];
    }
    
    [self override_setAttributedTitle:transformedTitle forState:state];
}

- (void)setGradientLayer:(CALayer *)gradientLayer
{
    objc_setAssociatedObject(self, kNUIAssociatedGradientLayerKey, gradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)gradientLayer
{
    return objc_getAssociatedObject(self, kNUIAssociatedGradientLayerKey);
}


- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if ([self isHighlighted]) {
        
        if (self.highlightedBorderColor) {
            [self.layer setBorderColor:self.highlightedBorderColor.CGColor];
        }
    } else {
        
        if (self.highlightedBorderColor) {
            [self.layer setBorderColor:self.normalBorderColor.CGColor];
        }
    }
}

- (void)setEnabled:(BOOL)enabled {
    
    [super setEnabled:enabled];
    
    if (!enabled && self.disabledBorderColor) {
        [self setBorderColor:self.disabledBorderColor forState:UIControlStateDisabled];
    }
}

- (void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    
    if (selected && self.selectedBorderColor) {
        [self setBorderColor:self.selectedBorderColor forState:UIControlStateSelected];
    }
}

- (void)setBorderColor:(UIColor*)borderColor forState:(UIControlState)state {
    
    switch (state) {
        case UIControlStateHighlighted:
            self.highlightedBorderColor = borderColor;
            break;
            
        case UIControlStateNormal:
            self.normalBorderColor = borderColor;
            break;
            
        case UIControlStateDisabled:
            self.disabledBorderColor = borderColor;
            break;
            
        case UIControlStateSelected:
            self.selectedBorderColor = borderColor;
            
        default:
            break;
    }
}

- (UIColor *)highlightedBorderColor {
    
    return objc_getAssociatedObject(self, @selector(highlightedBorderColor));
}

- (UIColor *)normalBorderColor {
    
    return objc_getAssociatedObject(self, @selector(normalBorderColor));
}

- (UIColor *)selectedBorderColor {
    return objc_getAssociatedObject(self, @selector(selectedBorderColor));
}

- (UIColor *)disabledBorderColor {
    return objc_getAssociatedObject(self, @selector(disabledBorderColor));
}

- (void)setHighlightedBorderColor:(UIColor *)highlightedBorderColor {
    
    objc_setAssociatedObject(self, @selector(highlightedBorderColor), highlightedBorderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setNormalBorderColor:(UIColor *)normalBorderColor {
    
    objc_setAssociatedObject(self, @selector(normalBorderColor), normalBorderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSelectedBorderColor:(UIColor *)selectedBorderColor {
    
    objc_setAssociatedObject(self, @selector(selectedBorderColor), selectedBorderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDisabledBorderColor:(UIColor *)disabledBorderColor {
    
    objc_setAssociatedObject(self, @selector(disabledBorderColor), disabledBorderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
