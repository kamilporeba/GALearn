//
//  CustomizableView.h
//  GALearn
//
//  Created by Kamil Poreba on 24.02.2017.
//  Copyright © 2017 Kamil Poreba. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MovableProtocol <NSObject>

- (void)didDragedViewWithCenter:(CGPoint) center andTag:(NSInteger) tag;

@end

@interface CustomizableView : UIView

@property (nonatomic,weak) id<MovableProtocol> movableDelegate;

@end
