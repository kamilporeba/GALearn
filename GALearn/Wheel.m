//
//  Wheel.m
//  GALearn
//
//  Created by Kamil Poreba on 28.02.2017.
//  Copyright © 2017 Kamil Poreba. All rights reserved.
//

#import "Wheel.h"

@implementation Wheel

- (instancetype)initWithCenterPosition:(CGPoint)center
{
    self = [super initWithFrame:CGRectMake(center.x, center.y, 50, 50)];
    if (self) {
        self.alpha = 0.5;
        self.layer.cornerRadius = 25;
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

@end
