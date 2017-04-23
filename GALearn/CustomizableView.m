//
//  CustomizableView.m
//  GALearn
//
//  Created by Kamil Poreba on 24.02.2017.
//  Copyright © 2017 Kamil Poreba. All rights reserved.
//

#import "CustomizableView.h"

@interface CustomizableView()

@end

@implementation CustomizableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGestureRecognizer];
    }
    return self;
}

- (void)addGestureRecognizer {
    [super awakeFromNib];
    
    UIPanGestureRecognizer *dragDropRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(thingDragged:)];
    [self addGestureRecognizer:dragDropRecog];
}

- (void) thingDragged:(UIPanGestureRecognizer *) gesture
{
    CGPoint location = [gesture locationInView:self.superview];
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        self.layer.borderColor = [[UIColor redColor] CGColor];
        self.layer.borderWidth = 1;
    } else if ([gesture state] == UIGestureRecognizerStateChanged) {
        [self setCenter:CGPointMake(location.x, location.y)];
    } else if ([gesture state] == UIGestureRecognizerStateEnded) {
        [self setCenter:CGPointMake(location.x, location.y)];
        self.layer.borderWidth = 0;
    }
    
   [self.movableDelegate didDragedViewWithCenter:self.center andTag:self.tag];
}

@end
