//
//  CarCollectionViewCell.h
//  GALearn
//
//  Created by Kamil Poreba on 03.04.2017.
//  Copyright © 2017 Kamil Poreba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarView.h"

@interface CarCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet CarView *carView;
@property (weak, nonatomic) IBOutlet UILabel *similarity;

-(void)setViewWithGenotype:(NSString *)genotype;
@end
