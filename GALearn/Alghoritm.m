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
    
    while ([genotype length] < GENE_LENGTH) {
        int r = arc4random_uniform(maxSize);
        [genotype appendString:binaryStringFromInteger(r)];
        
    }
  
    return genotype;
}

+ (BOOL)isCar:(CarView *)car isFitterThen:(CarView *)secondCar toModel:(CarView *)modelCar{
    CGFloat similarityFirstCar = [Alghoritm getSmiliarity:car withModel:modelCar];
    CGFloat similaritySecondCar = [Alghoritm getSmiliarity:secondCar withModel:modelCar];

    
    return fabs(similarityFirstCar) < fabs(similaritySecondCar);
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
    
    NSString *firstParentGenotype = car.genotype;
    NSString *secondParentGenotype = otherCar.genotype;
    
    int firstPart = arc4random_uniform(GENE_LENGTH);
    
    NSString * childGenotype = [[firstParentGenotype substringWithRange:NSMakeRange(0, firstPart)] stringByAppendingString:[secondParentGenotype substringWithRange:NSMakeRange(firstPart, secondParentGenotype.length - firstPart)]];
    [childCar buildCarFromGenotype:childGenotype];
    
    if (RANDOM() < MUTATION_THRESHOLD) {
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

//for all members of population
//sum += fitness of this individual
//end for
//
//for all members of population
//probability = sum of probabilities + (fitness / sum)
//sum of probabilities += probability
//end for
//
//loop until new population is full
//do this twice
//number = Random between 0 and 1
//for all members of population
//if number > probability but less than next probability
//then you have been selected
//end for
//end
//create offspring
//end loop

+(NSArray<CarView *> *)generateNewPopulationWithOldPopulation:(NSArray<CarView *> *) oldPopulation andModel:(CarView *) model {

    NSMutableArray *newPopulation = [[NSMutableArray alloc] init];
    
    CGFloat sumOfFitness;
    CGFloat sumOfPropability = 0;
    for (CarView *car in oldPopulation) {
        sumOfFitness += [Alghoritm getSmiliarity:car withModel:model];
    }
    
    while (newPopulation.count < oldPopulation.count) {
        
        NSMutableArray *selectedParent = [[NSMutableArray alloc]init];
        
        for (int i = 0 ; i<2; i++) {
            sumOfPropability = 0;
            double rand = arc4random_uniform(sumOfFitness);
            for (CarView *car in oldPopulation) {
              sumOfPropability += [Alghoritm getSmiliarity:car withModel:model];
                if (rand < sumOfPropability) {
                    [selectedParent addObject:car];
                    break;
                }
            }
        }

        [newPopulation addObject:[Alghoritm mateCar:selectedParent.firstObject withOther:selectedParent.lastObject]];
    }
//    for (CarView *car in oldPopulation) {
//        CGFloat probability = sumOfPropability + ([Alghoritm getSmiliarity:car withModel:model]/sumOfFitness);
//        sumOfFitness += probability;
//    }
    
//    while (newPopulation.count < oldPopulation.count) {
//        NSMutableArray *selectedParent = [[NSMutableArray alloc]init];
//        for (int i = 0 ; i<2; i++) {
//            double rand = ((double)arc4random() / ARC4RANDOM_MAX);
//            
//            for (int i =0; i<oldPopulation.count; i++) {
//                int nextIndex =0;
//                if (i+1 >= oldPopulation.count) {
//                    nextIndex = 0;
//                } else {
//                    nextIndex = i+1;
//                }
//                CGFloat probability = sumOfPropability + ([Alghoritm getSmiliarity:[oldPopulation objectAtIndex:i] withModel:model]/sumOfFitness);
//                 CGFloat nextProbability = sumOfPropability + ([Alghoritm getSmiliarity:[oldPopulation objectAtIndex:nextIndex] withModel:model]/sumOfFitness);
//                NSLog(@"rand : %f, prob: %f, nextProb: %f",rand, probability, nextProbability);
//                if (rand > probability && rand < nextProbability) {
//                    [selectedParent addObject:[oldPopulation objectAtIndex:i]];
//                }
//            }
//        }
//        [newPopulation addObject:[Alghoritm mateCar:selectedParent.firstObject withOther:selectedParent.lastObject]];
//    }
//    for (CarView *car in oldPopulation) {
//        
//        if (car != sortedPopulation.firstObject || car != [sortedPopulation objectAtIndex:1]) {
//            [newPopulation addObject:[Alghoritm mateCar:[sortedPopulation objectAtIndex:0] withOther:[sortedPopulation objectAtIndex:1]]];
//        } else {
//            [newPopulation addObject:car];
//        }
//    }
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
