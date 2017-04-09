//
//  CarView.h
//  GALearn
//
//  Created by Kamil Poreba on 28.02.2017.
//  Copyright © 2017 Kamil Poreba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wheel.h"
#import "FourPointEditableView.h"

NSString * binaryStringFromInteger( int number );

@interface CarView : UIView

@property(nonatomic) Wheel *firstWheel;
@property(nonatomic) Wheel *secondWheel;
@property(nonatomic) FourPointEditableView *carosery;

- (void)addCarroseryWithPoint:(CGPoint)firstPoint andSecond:(CGPoint)secondPoint andThird:(CGPoint)thirdPoint andFourth:(CGPoint)fourthPoint isEditableView:(BOOL)isEditable;
- (void)addWheelAtPoint:(CGPoint)firstPoint andSecond:(CGPoint)secondPoint ;
- (NSString *)getGenotype;
- (void)buildCarFromGenotype:(NSString *)genotype;
- (CGFloat)getSmiliarityNumberWithModel:(CarView *)car;
@end
