//
//  CarView.m
//  GALearn
//
//  Created by Kamil Poreba on 28.02.2017.
//  Copyright © 2017 Kamil Poreba. All rights reserved.
//

#import "CarView.h"

@interface CarView()

@end

@implementation CarView

- (void)addCarroseryWithPoint:(CGPoint)firstPoint andSecond:(CGPoint)secondPoint andThird:(CGPoint)thirdPoint andFourth:(CGPoint)fourthPoint isEditableView:(BOOL)isEditable {
    self.carosery = [[FourPointEditableView alloc] initWithPoints:firstPoint andSecond:secondPoint andThird:thirdPoint andFourth:fourthPoint andFrame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) isEditable:isEditable];
    [self addSubview:self.carosery];
}

- (void)addWheelAtPoint:(CGPoint)firstPoint andSecond:(CGPoint)secondPoint {
    self.firstWheel = [[Wheel alloc] initWithCenterPosition:firstPoint];
    self.secondWheel = [[Wheel alloc] initWithCenterPosition:secondPoint];
    [self addSubview:self.firstWheel];
    [self addSubview:self.secondWheel];
}

- (NSString *)getGenotype {
    NSString *firstWheelX = binaryStringFromInteger((int)(self.firstWheel.center.x + 0.5) );
    NSString *firstWheelY = binaryStringFromInteger((int)(self.firstWheel.center.y + 0.5) );
    NSString *secondWheelX = binaryStringFromInteger((int)(self.secondWheel.center.x + 0.5) );
    NSString *secondWheelY = binaryStringFromInteger((int)(self.secondWheel.center.y + 0.5) );
    NSString *firstPointX = binaryStringFromInteger((int)(self.carosery.firstPoint.x + 0.5) );
    NSString *firstPointY = binaryStringFromInteger((int)(self.carosery.firstPoint.y + 0.5) );
    NSString *secondPointX = binaryStringFromInteger((int)(self.carosery.secondPoint.x + 0.5) );
    NSString *secondPointY = binaryStringFromInteger((int)(self.carosery.secondPoint.y + 0.5) );
    NSString *thirdPointX = binaryStringFromInteger((int)(self.carosery.thirdPoint.x + 0.5) );
    NSString *thirdPointY = binaryStringFromInteger((int)(self.carosery.thirdPoint.y + 0.5) );
    NSString *fourthPointX = binaryStringFromInteger((int)(self.carosery.fourthPoint.x + 0.5) );
    NSString *fourthPointY = binaryStringFromInteger((int)(self.carosery.fourthPoint.y + 0.5) );
    
    
    return [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@",firstWheelX,firstWheelY,secondWheelX,secondWheelY,firstPointX,firstPointY,secondPointX,secondPointY,thirdPointX,thirdPointY,fourthPointX,fourthPointY];
}

- (void)buildCarFromGenotype:(NSString *)genotype {
    
    NSAssert([genotype length] >= 12*32, @"Wrong genotype");
    long firstWheelX = strtol([[genotype substringWithRange:NSMakeRange(0,32)]UTF8String], NULL, 2);
    long firstWheelY = strtol([[genotype substringWithRange:NSMakeRange(32,32)]UTF8String], NULL, 2);
    long secondWheelX = strtol([[genotype substringWithRange:NSMakeRange(64,32)]UTF8String], NULL, 2);
    long secondWheelY = strtol([[genotype substringWithRange:NSMakeRange(96,32)]UTF8String], NULL, 2);
    long firstPointX = strtol([[genotype substringWithRange:NSMakeRange(128,32)]UTF8String], NULL, 2);
    long firstPointY = strtol([[genotype substringWithRange:NSMakeRange(160,32)]UTF8String], NULL, 2);
    long secondPointX = strtol([[genotype substringWithRange:NSMakeRange(192,32)]UTF8String], NULL, 2);
    long secondPointY = strtol([[genotype substringWithRange:NSMakeRange(224,32)]UTF8String], NULL, 2);
    long thirdPointX = strtol([[genotype substringWithRange:NSMakeRange(256,32)]UTF8String], NULL, 2);
    long thirdPointY = strtol([[genotype substringWithRange:NSMakeRange(288,32)]UTF8String], NULL, 2);
    long fourthPointX = strtol([[genotype substringWithRange:NSMakeRange(320,32)]UTF8String], NULL, 2);
    long fourthPointY = strtol([[genotype substringWithRange:NSMakeRange(352,32)]UTF8String], NULL, 2);
    
    
    [self addCarroseryWithPoint:CGPointMake(firstPointX, firstPointY) andSecond:CGPointMake(secondPointX, secondPointY) andThird:CGPointMake(thirdPointX, thirdPointY) andFourth:CGPointMake(fourthPointX, fourthPointY) isEditableView:YES];
    [self addWheelAtPoint:CGPointMake(firstWheelX, firstWheelY) andSecond:CGPointMake(secondWheelX, secondWheelY)];
    

}

- (CGFloat)getSmiliarityNumberWithModel:(CarView *)car {
    
    CGFloat sumSelf = [self distanceBetween:self.carosery.firstPoint and:self.carosery.secondPoint] + [self distanceBetween:self.carosery.secondPoint and:self.carosery.thirdPoint] + [self distanceBetween:self.carosery.thirdPoint and:self.carosery.fourthPoint] + [self distanceBetween:self.carosery.fourthPoint and:self.carosery.firstPoint] + [self distanceBetween:self.carosery.firstPoint and:self.carosery.thirdPoint] + (self.carosery.pathBounds.size.width * self.carosery.pathBounds.size.height);
    
    CGFloat sumModel = [self distanceBetween:car.carosery.firstPoint and:car.carosery.secondPoint] + [self distanceBetween:car.carosery.secondPoint and:car.carosery.thirdPoint] + [self distanceBetween:car.carosery.thirdPoint and:car.carosery.fourthPoint] + [self distanceBetween:car.carosery.fourthPoint and:car.carosery.firstPoint] + [self distanceBetween:car.carosery.firstPoint and:car.carosery.thirdPoint] + (car.carosery.pathBounds.size.width * car.carosery.pathBounds.size.height);
    
    CGFloat sumDiff = ( [self distanceBetween:car.carosery.firstPoint and:car.carosery.secondPoint]  - [self distanceBetween:self.carosery.firstPoint and:self.carosery.secondPoint] ) + ([self distanceBetween:self.carosery.secondPoint and:self.carosery.thirdPoint] - [self distanceBetween:car.carosery.secondPoint and:car.carosery.thirdPoint] ) + ( [self distanceBetween:car.carosery.thirdPoint and:car.carosery.fourthPoint]  - [self distanceBetween:self.carosery.thirdPoint and:self.carosery.fourthPoint]  ) + ([self distanceBetween:car.carosery.fourthPoint and:car.carosery.firstPoint] - [self distanceBetween:self.carosery.fourthPoint and:self.carosery.firstPoint]) + ([self distanceBetween:car.carosery.firstPoint and:car.carosery.thirdPoint] -  [self distanceBetween:self.carosery.firstPoint and:self.carosery.thirdPoint]) + ((car.carosery.pathBounds.size.width * car.carosery.pathBounds.size.height) - (self.carosery.pathBounds.size.width * self.carosery.pathBounds.size.height));

    if (sumDiff == 0) {
        return  1;
    }
    if (sumDiff < 0) {
        return 0;
    } else {
        return 1 - (sumDiff / sumModel);
    }
}

- (float)distanceBetween:(CGPoint)p1 and:(CGPoint)p2
{
    return sqrt(pow(p2.x-p1.x,2)+pow(p2.y-p1.y,2));
}

NSString * binaryStringFromInteger( int number )
{
    NSMutableString * string = [[NSMutableString alloc] init];
    
    int spacing = pow( 2, 3 );
    int width = ( sizeof( number ) ) * spacing;
    int binaryDigit = 0;
    int integer = number;
    
    while( binaryDigit < width )
    {
        binaryDigit++;
        
        [string insertString:( (integer & 1) ? @"1" : @"0" )atIndex:0];
        
        integer = integer >> 1;
    }
    
    return string;
}

@end
