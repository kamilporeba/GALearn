//
//  ViewController.m
//  GALearn
//
//  Created by Kamil Poreba on 24.02.2017.
//  Copyright © 2017 Kamil Poreba. All rights reserved.
//

#import "ViewController.h"
#import "CarView.h"
#import "CarCollectionViewCell.h"
#import "Alghoritm.h"
#import "ContentViewController.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet CarView *modelCarView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISlider *populationCount;
@property (nonatomic,strong) NSMutableArray<CarView *> *populationArray;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.modelCarView buildCarFromGenotype:@"0000000000000000000000000001101100000000000000000000000000011101000000000000000000000000100000000000000000000000000000000001010000000000000000000000000010000100000000000000000000000000011001000000000000000000000000000001111000000000000000000000000001100001" andEditable:YES];
    
}

- (IBAction)nextStep:(id)sender {
    [self doSomething];
}

- (IBAction)start:(id)sender {
     [self refreshWithNewParameters];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.000002 target:self selector:@selector(doSomething) userInfo:nil repeats: YES];
    [self.timer fire];
}
- (IBAction)IterationInfo:(id)sender {
    [self showAlertWithInfo:@"Lorem ipsum" withButton:(UIButton *)sender];
}

-(void)initRandomGeneration {
    self.populationArray = [[NSMutableArray alloc] init];
    for (int i=0; i<= (int) self.populationCount.value; i++) {
        CarView *car = [[CarView alloc] init];
        [car buildCarFromGenotype:[Alghoritm generateRandomeGenotypeWithMaxSize:self.modelCarView.frame.size.width]];
        [self.populationArray addObject:car];
    }
}

-(void)showAlertWithInfo:(NSString *)infoText withButton:(UIButton *)button {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Directions"
                                                                   message:@"Select mode of transportation:"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    alert.popoverPresentationController.sourceView = button;
    alert.popoverPresentationController.sourceRect = button.bounds;
    alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionRight;

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:NO completion:nil];
    }]];
    alert.popoverPresentationController.delegate = self;

    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark -CollectionView methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.populationArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CarCollectionViewCell *carCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CarCollectionViewCell class]) forIndexPath:indexPath];
    [carCell setViewWithGenotype:[self.populationArray objectAtIndex:indexPath.row].genotype];
    [carCell.similarity setText:[NSString stringWithFormat:@"%f",[Alghoritm getSmiliarity:carCell.carView withModel:self.modelCarView]]];
    return carCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width/3.2 , 100);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   CarCollectionViewCell *carCell =  ( CarCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ContentViewController *vc = [[ContentViewController alloc]init];
    vc.genotype = [carCell.carView getGenotype];
    [self presentViewController:vc animated:NO completion:nil];
    
}

#pragma mark -Alghoritm 

-(void)doSomething {
self.populationArray = [Alghoritm generateNewPopulationWithOldPopulation:self.populationArray andModel:self.modelCarView];
    [self.collectionView reloadData];
    [self checkPopulation];
}

-(void)checkPopulation {
    for (CarView *car  in self.populationArray) {
        if ([Alghoritm getSmiliarity:car withModel:self.modelCarView] <= 10) {
            [self.timer invalidate];
            [car setIsSelected:YES];
            [self.collectionView reloadData];
            break;
        }
    }
}

-(void)refreshWithNewParameters {
    [self initRandomGeneration];
    [self.collectionView reloadData];
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    return YES;
}
@end
