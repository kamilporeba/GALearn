//
//  FourPointEditableView.m
//  GALearn
//
//  Created by Kamil Poreba on 28.02.2017.
//  Copyright © 2017 Kamil Poreba. All rights reserved.
//

#import "FourPointEditableView.h"
#import "CustomizableView.h"

@interface FourPointEditableView() <MovableProtocol>


@property(nonatomic) UIBezierPath *fourPointPath;
@property(nonatomic) CAShapeLayer *shapeView;

@end

@implementation FourPointEditableView

- (instancetype)initWithPoints:(CGPoint)firstPoint andSecond:(CGPoint)secondPoint andThird:(CGPoint)thirdPoint andFourth:(CGPoint)fourthPoint andFrame:(CGRect)frame isEditable:(BOOL) isEditable {
    self = [super initWithFrame:frame];
    if (self) {
        _shapeView = [[CAShapeLayer alloc] init];
        _fourPointPath = [UIBezierPath bezierPath];
        [self drawShapeWithFirstPoint:firstPoint andSecond:secondPoint andThird:thirdPoint andFourth:fourthPoint isEditable: isEditable];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawShapeWithFirstPoint:(CGPoint)firstPoint andSecond:(CGPoint)secondPoint andThird:(CGPoint)thirdPoint andFourth:(CGPoint)fourthPoint isEditable:(BOOL) isEditable {
    self.firstPoint = firstPoint;
    self.secondPoint = secondPoint;
    self.thirdPoint = thirdPoint;
    self.fourthPoint = fourthPoint;

    if (isEditable) {
        [self addEditablePoint];
    }
    
    [self drawLines];
    [self updatePath];
    
     self.pathBounds = CGPathGetBoundingBox(self.fourPointPath.CGPath);
}

- (void)addEditablePoint {
    [self addEditableCircleShapeWithPoint:self.firstPoint andPoint:FirstPoint color:[UIColor greenColor]];
    [self addEditableCircleShapeWithPoint:self.secondPoint andPoint:SecondPoint color:[UIColor orangeColor]];
    [self addEditableCircleShapeWithPoint:self.thirdPoint andPoint:ThirdPoint color:[UIColor purpleColor]];
    [self addEditableCircleShapeWithPoint:self.fourthPoint andPoint:FourthPoint color:[UIColor yellowColor]];
}

- (void)setInitialPoint {
    self.firstPoint = CGPointMake(200.0, 40.0);
    [self addEditableCircleShapeWithPoint:self.firstPoint andPoint:FirstPoint];
    self.secondPoint = CGPointMake(160, 140);
    [self addEditableCircleShapeWithPoint:self.secondPoint andPoint:SecondPoint];
    self.thirdPoint = CGPointMake(40.0, 140);
    [self addEditableCircleShapeWithPoint:self.thirdPoint andPoint:ThirdPoint];
    self.fourthPoint = CGPointMake(0.0,40.0);
    [self addEditableCircleShapeWithPoint:self.fourthPoint andPoint:FourthPoint];
}

- (void)drawLines {
    [self.fourPointPath removeAllPoints];
    [self.fourPointPath moveToPoint:self.firstPoint];
    [self.fourPointPath addLineToPoint:self.firstPoint];
    [self.fourPointPath addLineToPoint:self.secondPoint];
    [self.fourPointPath addLineToPoint:self.thirdPoint];
    [self.fourPointPath addLineToPoint:self.fourthPoint];
    [self.fourPointPath closePath];
}

- (void)updatePath {
    [self.shapeView setPath:self.fourPointPath.CGPath];
    [[self layer] addSublayer:self.shapeView];
}

- (void)addEditableCircleShapeWithPoint:(CGPoint) center andPoint:(PointNumber) point {
    CustomizableView *circleView = [[CustomizableView alloc] initWithFrame:CGRectMake(center.x,center.y,10,10)];
    circleView.alpha = 0.5;
    circleView.layer.cornerRadius = 5;
    circleView.backgroundColor = [UIColor redColor];
    circleView.center = center;
    circleView.movableDelegate = self;
    circleView.tag = point;
    [self addSubview:circleView];
}

- (void)addEditableCircleShapeWithPoint:(CGPoint) center andPoint:(PointNumber) point color:(UIColor *)color {
    CustomizableView *circleView = [[CustomizableView alloc] initWithFrame:CGRectMake(center.x,center.y,10,10)];
    circleView.alpha = 0.5;
    circleView.layer.cornerRadius = 5;
    circleView.backgroundColor = [UIColor redColor];
    circleView.center = center;
    circleView.movableDelegate = self;
    circleView.tag = point;
    circleView.backgroundColor = color;
    [self addSubview:circleView];
}

#pragma mark -Movable protocol

- (void)didDragedViewWithCenter:(CGPoint) center andTag:(NSInteger) tag {
    switch ((PointNumber) tag) {
        case FirstPoint:
            self.firstPoint = center;
            break;
        case SecondPoint:
            self.secondPoint = center;
            break;
        case ThirdPoint:
            self.thirdPoint = center;
            break;
        case FourthPoint:
            self.fourthPoint = center;
            break;
    }
    [self drawLines];
    [self updatePath];
}


@end
