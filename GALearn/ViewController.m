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

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet CarView *modelCarView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISlider *populationCount;
@property (nonatomic,strong) NSMutableArray<CarView *> *populationArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.modelCarView buildCarFromGenotype:@"0000000000000000000000000001101100000000000000000000000000011101000000000000000000000000100000000000000000000000000000000001010000000000000000000000000010000100000000000000000000000000011001000000000000000000000000000001111000000000000000000000000001100001"];
    
//    CarView *car = [[CarView alloc]initWithFrame:CGRectMake(20, 20, 300, 300)];
//    [car buildCarFromGenotype:@"0000000000000000000000000011111100000000000000000000000000011101000000000000000000000000100000000000000000000000000000000001010000000000000000000000000010000000000000000000000000000000011111000000000000000000000000000001111000000000000000000000000001100001"];
//    [self.view addSubview: car];
//    
//    NSLog(@"%f",[Alghoritm getSmiliarity:car withModel:self.modelCarView]);
}

- (IBAction)refresh:(id)sender {
    
    [self refreshWithNewParameters];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(doSomething) userInfo:nil repeats: YES];
    [timer fire];
}
- (IBAction)nextStep:(id)sender {
    [self doSomething];
}

-(void)initRandomGeneration {
    self.populationArray = [[NSMutableArray alloc] init];
    for (int i=0; i<= (int) self.populationCount.value; i++) {
        CarView *car = [[CarView alloc] init];
        [car buildCarFromGenotype:[Alghoritm generateRandomeGenotypeWithMaxSize:self.modelCarView.frame.size.width]];
        [self.populationArray addObject:car];
    }
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
//    CarView *childCar;
//    for (int i=0; i< self.populationArray.count - 1; i++ ) {
//        CarView *firstCar = [self.populationArray objectAtIndex:i];
//        CarView *secondCar = [self.populationArray objectAtIndex:i+1];
//        childCar = [Alghoritm mateCar:firstCar withOther:secondCar];
//        NSInteger indexToDeath = [Alghoritm isCar:firstCar isFitterThen:secondCar toModel:self.modelCarView] ? i+1 : i;
//        [self.populationArray replaceObjectAtIndex:indexToDeath withObject:childCar];
//    }
    [self.collectionView reloadData];
}

-(void)refreshWithNewParameters {
    [self initRandomGeneration];
    [self.collectionView reloadData];
}



@end
