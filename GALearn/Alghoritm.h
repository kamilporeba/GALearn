//
//  Alghoritm.h
//  GALearn
//
//  Created by Kamil Poreba on 03.04.2017.
//  Copyright © 2017 Kamil Poreba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarView.h"

double angleBetweenThreePoints(CGPoint point1,CGPoint vertex, CGPoint point3);

@interface Alghoritm : NSObject

+ (NSString *)generateRandomeGenotypeWithMaxSize:(int) maxSize;
+ (CGFloat)getSmiliarity:(CarView *)car withModel:(CarView *)model;
+ (CarView *)mateCar:(CarView *)car withOther:(CarView *)otherCar ;
+ (BOOL)isCar:(CarView *)car isFitterThen:(CarView *)secondCar toModel:(CarView *)modelCar;
+(NSArray<CarView *> *)generateNewPopulationWithOldPopulation:(NSArray<CarView *> *) oldPopulation andModel:(CarView *) model;
@end
