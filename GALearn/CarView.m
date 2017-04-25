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

- (NSString *)getGenotype {
    NSString *firstPointX = binaryStringFromInteger((int)(self.carosery.firstPoint.x + 0.5) );
    NSString *firstPointY = binaryStringFromInteger((int)(self.carosery.firstPoint.y + 0.5) );
    NSString *secondPointX = binaryStringFromInteger((int)(self.carosery.secondPoint.x + 0.5) );
    NSString *secondPointY = binaryStringFromInteger((int)(self.carosery.secondPoint.y + 0.5) );
    NSString *thirdPointX = binaryStringFromInteger((int)(self.carosery.thirdPoint.x + 0.5) );
    NSString *thirdPointY = binaryStringFromInteger((int)(self.carosery.thirdPoint.y + 0.5) );
    NSString *fourthPointX = binaryStringFromInteger((int)(self.carosery.fourthPoint.x + 0.5) );
    NSString *fourthPointY = binaryStringFromInteger((int)(self.carosery.fourthPoint.y + 0.5) );
    
    self.genotype = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",firstPointX,firstPointY,secondPointX,secondPointY,thirdPointX,thirdPointY,fourthPointX,fourthPointY];
    return self.genotype;
}

- (void)buildCarFromGenotype:(NSString *)genotype {
    [self buildCarFromGenotype:genotype andEditable:NO];
}

- (void)buildCarFromGenotype:(NSString *)genotype andEditable:(BOOL)isEditable {
    self.genotype = genotype;
    NSAssert([genotype length] == GENE_LENGTH, @"Wrong genotype");
    long firstPointX = strtol([[genotype substringWithRange:NSMakeRange(0,32)]UTF8String], NULL, 2);
    long firstPointY = strtol([[genotype substringWithRange:NSMakeRange(32,32)]UTF8String], NULL, 2);
    long secondPointX = strtol([[genotype substringWithRange:NSMakeRange(64,32)]UTF8String], NULL, 2);
    long secondPointY = strtol([[genotype substringWithRange:NSMakeRange(96,32)]UTF8String], NULL, 2);
    long thirdPointX = strtol([[genotype substringWithRange:NSMakeRange(128,32)]UTF8String], NULL, 2);
    long thirdPointY = strtol([[genotype substringWithRange:NSMakeRange(160,32)]UTF8String], NULL, 2);
    long fourthPointX = strtol([[genotype substringWithRange:NSMakeRange(192,32)]UTF8String], NULL, 2);
    long fourthPointY = strtol([[genotype substringWithRange:NSMakeRange(224,32)]UTF8String], NULL, 2);
    
    [self addCarroseryWithPoint:CGPointMake(firstPointX, firstPointY) andSecond:CGPointMake(secondPointX, secondPointY) andThird:CGPointMake(thirdPointX, thirdPointY) andFourth:CGPointMake(fourthPointX, fourthPointY) isEditableView:isEditable];
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
