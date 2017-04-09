//
//  BinaryFormatter.m
//  GALearn
//
//  Created by Kamil Poreba on 07.03.2017.
//  Copyright © 2017 Kamil Poreba. All rights reserved.
//

#import "BinaryFormatter.h"

@implementation BinaryFormatter

+(NSString *)decToBinary:(NSUInteger)decInt
{
    NSString *string = @"" ;
    NSUInteger x = decInt;
    
    while (x>0) {
        string = [[NSString stringWithFormat: @"%lu", x&1] stringByAppendingString:string];
        x = x >> 1;
    }
    return string;
}

@end
