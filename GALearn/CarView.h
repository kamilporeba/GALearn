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
@property(nonatomic) FourPointEditableView *carosery;
@property (nonatomic)NSString *genotype;

- (NSString *)getGenotype;
- (void)buildCarFromGenotype:(NSString *)genotype;
@end
