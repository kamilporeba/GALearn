//
//  Alghoritm.m
//  GALearn
//
//  Created by Kamil Poreba on 03.04.2017.
//  Copyright © 2017 Kamil Poreba. All rights reserved.
//

#import "Alghoritm.h"
#import "CarView.h"
#import "NSMutableArray+Shuffle.h"

@implementation Alghoritm

+ (NSString *)generateRandomeGenotypeWithMaxSize:(int) maxSize {
    NSMutableString *genotype = [[NSMutableString alloc] init];
    
    while ([genotype length] < GENE_LENGTH) {
        int r = arc4random_uniform(maxSize);
        [genotype appendString:binaryStringFromInteger(r)];
    }
  
    return genotype;
}

+ (BOOL)isCar:(CarView *)car isFitterThen:(CarView *)secondCar toModel:(CarView *)modelCar{
    CGFloat similarityFirstCar = [Alghoritm getSmiliarity:car withModel:modelCar];
    CGFloat similaritySecondCar = [Alghoritm getSmiliarity:secondCar withModel:modelCar];

    
    return similarityFirstCar <= similaritySecondCar;
}

+ (CGFloat)getSmiliarity:(CarView *)car withModel:(CarView *)model {
    
    CGFloat sumDiff =  ([self distanceBetween:model.carosery.firstPoint and:car.carosery.firstPoint])
    + ([self distanceBetween:model.carosery.secondPoint and:car.carosery.secondPoint])
    + ([self distanceBetween:model.carosery.thirdPoint and:car.carosery.thirdPoint])
    + ([self distanceBetween:model.carosery.fourthPoint and:car.carosery.fourthPoint]);
    return sumDiff;
}

+ (float)distanceBetween:(CGPoint)p1 and:(CGPoint)p2 {
    CGFloat xDist = (p2.x - p1.x);
    CGFloat yDist = (p2.y - p1.y);
   return sqrt((xDist * xDist) + (yDist * yDist));

}

+(CarView *)mateCar:(CarView *)car withOther:(CarView *)otherCar {
    CarView *childCar = [[CarView alloc] init];
    
    NSString *firstParentGenotype = car.genotype;
    NSString *secondParentGenotype = otherCar.genotype;
    
    int firstPart = arc4random_uniform(GENE_LENGTH);
    
    NSString * childGenotype = [[firstParentGenotype substringWithRange:NSMakeRange(0, firstPart)] stringByAppendingString:[secondParentGenotype substringWithRange:NSMakeRange(firstPart, secondParentGenotype.length - firstPart)]];
    [childCar buildCarFromGenotype:childGenotype];
    
    if (RANDOM() < (ARC4RANDOM_MAX * mutationRate)) {
        [Alghoritm mutate:childCar];
    }
    return childCar;
}


+(NSArray<CarView *> *)getBestCarFromPopulation:(NSArray<CarView *> *)population andModel:(CarView *)model  {
    
    NSArray *sortedPopulation = [population sortedArrayUsingComparator:^NSComparisonResult(CarView *  _Nonnull firstCar, CarView *  _Nonnull secondCar) {
        
        return [Alghoritm isCar:secondCar isFitterThen:firstCar toModel:model];
    }];
    NSArray *bestCars = @[sortedPopulation.firstObject, [sortedPopulation objectAtIndex:1]];
    
    return bestCars;
}

+(NSArray<CarView *> *)generateNewPopulationWithOldPopulation:(NSArray<CarView *> *) oldPopulation andModel:(CarView *) model {

    NSMutableArray *newPopulation = [[NSMutableArray alloc] init];
    
    
    NSArray *sortedPopulation = [oldPopulation sortedArrayUsingComparator:^NSComparisonResult(CarView *  _Nonnull firstCar, CarView *  _Nonnull secondCar) {
        return [Alghoritm isCar:secondCar isFitterThen:firstCar toModel:model];
    }];
    
 
    CGFloat sumOfFitness;
    CGFloat sumOfPropability = 0;
    for (CarView *car in oldPopulation) {
        if (car == sortedPopulation.firstObject) {
            sumOfFitness += [Alghoritm getSmiliarity:car withModel:model] * selectionPression;
        } else {
            sumOfFitness += [Alghoritm getSmiliarity:car withModel:model];
        }
        
    }
    CGFloat numberToRand;
    for (CarView *car in oldPopulation) {
        if (car == sortedPopulation.firstObject) {
            numberToRand += (1/ (([Alghoritm getSmiliarity:car withModel:model] *selectionPression)/sumOfFitness));
        } else {
            numberToRand += (1/ ([Alghoritm getSmiliarity:car withModel:model]/sumOfFitness));
        }
        
    }
    
    for (int i =0; i<sortedPopulation.count - (numberOfChild+1); i++) {
        [newPopulation addObject:[sortedPopulation objectAtIndex:i]];
    }
    
    for (int i=0; i<=numberOfChild; i++) {
        NSMutableArray *selectedParent = [[NSMutableArray alloc]init];
        
        for (int i = 0 ; i<2; i++) {
            sumOfPropability = 0;
            double rand = arc4random_uniform(numberToRand);
            for (CarView *car in oldPopulation) {
                CGFloat numberToADD = (1/ ([Alghoritm getSmiliarity:car withModel:model]/sumOfFitness));
                sumOfPropability += numberToADD;
                if (rand <= sumOfPropability) {
                    [selectedParent addObject:car];
                    break;
                }
            }
        }
        
        if (selectedParent.count == 1) {
            sumOfPropability = 0;
            double rand = arc4random_uniform(numberToRand);
            for (CarView *car in oldPopulation) {
                CGFloat numberToADD = (1/ ([Alghoritm getSmiliarity:car withModel:model]/sumOfFitness));
                sumOfPropability += numberToADD;
                if (rand <= sumOfPropability) {
                    [selectedParent addObject:car];
                    break;
                }
            }
        }
        
        NSAssert(selectedParent.count == 2, @"");
        
        [newPopulation addObject:[Alghoritm mateCar:selectedParent.firstObject withOther:selectedParent.lastObject]];
    }
    [newPopulation shuffle];
    return newPopulation;
}

+(void)mutate:(CarView *)childCar {
    
    NSString *genotype = childCar.genotype;
    int r = arc4random_uniform(GENE_LENGTH);
    
    NSString *gene = [genotype substringWithRange:NSMakeRange(r, 1)];
    
    if ([gene isEqualToString:@"1"]) {
       genotype = [genotype stringByReplacingCharactersInRange:NSMakeRange(r, 1) withString:@"0"];
    }else {
       genotype = [genotype stringByReplacingCharactersInRange:NSMakeRange(r, 1) withString:@"1"];
    }
    
    childCar.genotype = genotype;
}

@end
