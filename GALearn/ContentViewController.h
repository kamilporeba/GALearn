//
//  ContentViewController.h
//  GALearn
//
//  Created by Kamil Poreba on 04.04.2017.
//  Copyright © 2017 Kamil Poreba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarView.h"
@interface ContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet CarView *carView;
@property (nonatomic) NSString *genotype;
@end
