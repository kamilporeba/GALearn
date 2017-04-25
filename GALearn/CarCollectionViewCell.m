//
//  CarCollectionViewCell.m
//  GALearn
//
//  Created by Kamil Poreba on 03.04.2017.
//  Copyright © 2017 Kamil Poreba. All rights reserved.
//

#import "CarCollectionViewCell.h"
#import "Alghoritm.h"


@implementation CarCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setViewWithGenotype:(NSString *)genotype {
    if (self.carView.isSelected) {
        [self.carView setBackgroundColor:[UIColor greenColor]];
    }else {
       [self.carView setBackgroundColor:[UIColor whiteColor]];
    }
    for (UIView *subview in self.carView.subviews) {
        if (![subview isKindOfClass:[UILabel class]]) {
            [subview removeFromSuperview];
        }
        
    }
    [self.carView buildCarFromGenotype:genotype];
}

@end
