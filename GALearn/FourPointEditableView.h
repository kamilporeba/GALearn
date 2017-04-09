//
//  FourPointEditableView.h
//  GALearn
//
//  Created by Kamil Poreba on 28.02.2017.
//  Copyright © 2017 Kamil Poreba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomizableView.h"

typedef enum  {
    FirstPoint,
    SecondPoint,
    ThirdPoint,
    FourthPoint
    
} PointNumber;

@interface FourPointEditableView : UIView
@property(nonatomic) CGPoint firstPoint;
@property(nonatomic) CGPoint secondPoint;
@property(nonatomic) CGPoint thirdPoint;
@property(nonatomic) CGPoint fourthPoint;
@property(nonatomic) CGRect pathBounds;
- (instancetype)initWithPoints:(CGPoint)firstPoint andSecond:(CGPoint)secondPoint andThird:(CGPoint)thirdPoint andFourth:(CGPoint)fourthPoint andFrame:(CGRect)frame isEditable:(BOOL) isEditable;
@end
