//
//  Alghoritm.m
//  GALearn
//
//  Created by Kamil Poreba on 03.04.2017.
//  Copyright © 2017 Kamil Poreba. All rights reserved.
//

#import "Alghoritm.h"
#import "CarView.h"

@implementation Alghoritm

+ (NSString *)generateRandomeGenotypeWithMaxSize:(int) maxSize {
    NSMutableString *genotype = [[NSMutableString alloc] init];
    
    while ([genotype length] <= GENE_LENGTH) {
        int r = arc4random_uniform(maxSize);
        [genotype appendString:binaryStringFromInteger(r)];
        
    }
  
    return genotype;
}

+ (BOOL)isCar:(CarView *)car isFitterThen:(CarView *)secondCar toModel:(CarView *)modelCar{
    CGFloat similarityFirstCar = [Alghoritm getSmiliarity:car withModel:modelCar];
    CGFloat similaritySecondCar = [Alghoritm getSmiliarity:secondCar withModel:modelCar];

    return similarityFirstCar > similaritySecondCar;
}

+ (CGFloat)getSmiliarity:(CarView *)car withModel:(CarView *)model {
    
    CGFloat sumModel = [self distanceBetween:model.carosery.firstPoint and:model.carosery.secondPoint] + [self distanceBetween:model.carosery.secondPoint and:model.carosery.thirdPoint] + [self distanceBetween:model.carosery.thirdPoint and:model.carosery.fourthPoint] + [self distanceBetween:model.carosery.fourthPoint and:model.carosery.firstPoint] + [self distanceBetween:model.carosery.firstPoint and:model.carosery.thirdPoint]+angleBetweenThreePoints(model.carosery.firstPoint, model.carosery.secondPoint, model.carosery.thirdPoint)+angleBetweenThreePoints(model.carosery.secondPoint, model.carosery.thirdPoint, model.carosery.fourthPoint)+angleBetweenThreePoints(model.carosery.thirdPoint, model.carosery.fourthPoint, model.carosery.firstPoint)+angleBetweenThreePoints(model.carosery.fourthPoint, model.carosery.firstPoint, model.carosery.secondPoint);
    
//
//    + (model.carosery.pathBounds.size.width * model.carosery.pathBounds.size.height);
    
    CGFloat sumCar = [self distanceBetween:car.carosery.firstPoint and:car.carosery.secondPoint] + [self distanceBetween:car.carosery.secondPoint and:car.carosery.thirdPoint] + [self distanceBetween:car.carosery.thirdPoint and:car.carosery.fourthPoint] + [self distanceBetween:car.carosery.fourthPoint and:car.carosery.firstPoint] + [self distanceBetween:car.carosery.firstPoint and:car.carosery.thirdPoint];
//    + (car.carosery.pathBounds.size.width * car.carosery.pathBounds.size.height);
    
    CGFloat sumDiff =  ( [self distanceBetween:car.carosery.firstPoint and:car.carosery.secondPoint]  - [self distanceBetween:model.carosery.firstPoint and:model.carosery.secondPoint] ) + ([self distanceBetween:model.carosery.secondPoint and:model.carosery.thirdPoint] - [self distanceBetween:car.carosery.secondPoint and:car.carosery.thirdPoint] ) + ( [self distanceBetween:car.carosery.thirdPoint and:car.carosery.fourthPoint]  - [self distanceBetween:model.carosery.thirdPoint and:model.carosery.fourthPoint]  ) + ([self distanceBetween:car.carosery.fourthPoint and:car.carosery.firstPoint] - [self distanceBetween:model.carosery.fourthPoint and:model.carosery.firstPoint]) + ([self distanceBetween:car.carosery.firstPoint and:car.carosery.thirdPoint] -  [self distanceBetween:model.carosery.firstPoint and:model.carosery.thirdPoint]) +(angleBetweenThreePoints(car.carosery.firstPoint, car.carosery.secondPoint, car.carosery.thirdPoint) - angleBetweenThreePoints(model.carosery.firstPoint, model.carosery.secondPoint, model.carosery.thirdPoint))+(angleBetweenThreePoints(car.carosery.secondPoint, car.carosery.thirdPoint, car.carosery.fourthPoint) - angleBetweenThreePoints(model.carosery.secondPoint, model.carosery.thirdPoint, model.carosery.fourthPoint)) + (angleBetweenThreePoints(car.carosery.thirdPoint, car.carosery.fourthPoint, car.carosery.firstPoint)-angleBetweenThreePoints(model.carosery.thirdPoint, model.carosery.fourthPoint, model.carosery.firstPoint))+(angleBetweenThreePoints(car.carosery.fourthPoint, car.carosery.firstPoint, car.carosery.secondPoint) - angleBetweenThreePoints(model.carosery.fourthPoint, model.carosery.firstPoint, model.carosery.secondPoint));
    
    if (sumDiff == 0) {
        return  1;
    }
    if (sumDiff < 0) {
        return 0;
    } else {
        return 1 - (sumDiff / sumModel);
    }
}

+ (float)distanceBetween:(CGPoint)p1 and:(CGPoint)p2 {
    return sqrt(pow(p2.x-p1.x,2)+pow(p2.y-p1.y,2));
}
//http://stackoverflow.com/questions/1211212/how-to-calculate-an-angle-from-three-points
double angleBetweenThreePoints(CGPoint point1,CGPoint vertex, CGPoint point3) {
    CGPoint point_a = vertex;
    CGPoint point_b = point1;
    CGPoint point_c = point3;
    CGFloat a, b, c;
    
    a = [Alghoritm distanceBetween:point_a and:point_b];
    b = [Alghoritm distanceBetween:point_a and:point_c];
    c = [Alghoritm distanceBetween:point_b and:point_c];
    double result = acos((a*a+b*b-c*c)/(2*a*b));
    
    return result/M_PI * 180.0;
    
}

+(CarView *)mateCar:(CarView *)car withOther:(CarView *)otherCar {
    CarView *childCar = [[CarView alloc] init];
    
    NSString *firstParentGenotype = [car getGenotype];
    NSString *secondParentGenotype = [otherCar getGenotype];
    
    int firstPart = arc4random_uniform(GENE_LENGTH);
    
    NSString * childGenotype = [[firstParentGenotype substringWithRange:NSMakeRange(0, firstPart)] stringByAppendingString:[secondParentGenotype substringWithRange:NSMakeRange(firstPart, secondParentGenotype.length - firstPart)]];
    [childCar buildCarFromGenotype:childGenotype];
    
    
    return childCar;
}

@end
