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
#import "InfoToolTipViewController.h"

typedef enum : NSUInteger {
    Iteration,
    PopulationSize,
    Mutation,
    Selection,
    ChildAmount,
    StopTrigger
} InfoButtonParameter;

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet CarView *modelCarView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISlider *populationCount;
@property (weak, nonatomic) IBOutlet UISlider *iterationCount;
@property (weak, nonatomic) IBOutlet UISlider *mutation;
@property (weak, nonatomic) IBOutlet UISlider *selectionProbability;
@property (weak, nonatomic) IBOutlet UISlider *childCount;
@property (weak, nonatomic) IBOutlet UISlider *stopTrigger;

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *countLabels;
@property (nonatomic, strong) IBOutletCollection(UISlider) NSArray *sliders;
@property (weak, nonatomic) IBOutlet UIButton *evolute;

@property (nonatomic,strong) NSMutableArray<CarView *> *populationArray;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.modelCarView buildCarFromGenotype:@"0000000000000000000000000001101100000000000000000000000000011101000000000000000000000000100000000000000000000000000000000001010000000000000000000000000010000100000000000000000000000000011001000000000000000000000000000001111000000000000000000000000001100001" andEditable:YES];
    [self setValueLabel];
    
}

- (IBAction)start:(id)sender {
     [self refreshWithNewParameters];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.000002 target:self selector:@selector(evolutionOfOneGeneration) userInfo:nil repeats: YES];
    [self.timer fire];
}

- (IBAction)evolution:(id)sender {
    if (self.populationArray.count <= 0) {
        [self initRandomGeneration];
    }
    for (int i=0; i<=(int)self.iterationCount.value; i++) {
        [self evolutionOfOneGeneration];
    }
}

- (IBAction)reset:(id)sender {
    [self.populationArray removeAllObjects];
    [self.collectionView reloadData];
    [self.evolute setUserInteractionEnabled:YES];
}

- (IBAction)didSlide:(id)sender {
    UISlider *slider = (UISlider *) sender;
    [self setValueLabel];
    switch (slider.tag) {
        case PopulationSize:
            self.childCount.maximumValue = slider.value *0.4;
            break;
        case ChildAmount:
            numberOfChild =(int) self.childCount.value;
            break;
        case Mutation:
            mutationRate = self.mutation.value;
            break;
        case Selection:
            selectionPression = (int) self.selectionProbability.value;
        default:
            break;
    }
}

-(void)setValueLabel {
    for (int i=0; i<self.sliders.count; i++) {
        UILabel *label = [self.countLabels objectAtIndex:i];
        UISlider *slider = [self.sliders objectAtIndex:i];
        if (slider.tag == Mutation) {
            [label setText: [NSString stringWithFormat:@"%.2f", slider.value]];
            
        } else {
            [label setText: [NSString stringWithFormat:@"%d",(int) slider.value]];
        }
    }
   
}

- (IBAction)IterationInfo:(id)sender {
    UIButton *b = (UIButton *)sender;
    
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
    InfoToolTipViewController *alert = [[InfoToolTipViewController alloc]init];
    [alert setModalPresentationStyle:UIModalPresentationPopover];
    alert.popoverPresentationController.sourceView = button;
    alert.popoverPresentationController.sourceRect = button.bounds;
    alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionRight;
    [alert setPreferredContentSize:CGSizeMake(250, 200)];
    
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
//    [carCell.similarity setText:[NSString stringWithFormat:@"%f",[Alghoritm getSmiliarity:carCell.carView withModel:self.modelCarView]]];
    if ([self.populationArray objectAtIndex:indexPath.row].isWinner) {
        [carCell.carView setBackgroundColor:[UIColor greenColor]];
    } else {
         [carCell.carView setBackgroundColor:[UIColor whiteColor]];
    }
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

-(void)evolutionOfOneGeneration {
    self.populationArray = [Alghoritm generateNewPopulationWithOldPopulation:self.populationArray andModel:self.modelCarView];
    
    NSArray *sortedPopulation = [self.populationArray sortedArrayUsingComparator:^NSComparisonResult(CarView *  _Nonnull firstCar, CarView *  _Nonnull secondCar) {
        return [Alghoritm isCar:secondCar isFitterThen:firstCar toModel:self.modelCarView];
    }];
    self.populationArray = [[NSMutableArray alloc] initWithArray:sortedPopulation];
    [self.collectionView reloadData];
    [self checkPopulation];
}

-(void)checkPopulation {
    NSArray *sortedPopulation = [self.populationArray sortedArrayUsingComparator:^NSComparisonResult(CarView *  _Nonnull firstCar, CarView *  _Nonnull secondCar) {
        return [Alghoritm isCar:secondCar isFitterThen:firstCar toModel:self.modelCarView];
    }];
    
    if ([Alghoritm getSmiliarity:sortedPopulation.firstObject withModel:self.modelCarView] <= (int)self.stopTrigger.value ) {
        [self.timer invalidate];
        [sortedPopulation.firstObject setIsWinner:YES];
        NSLog(@"Sukcess");
        [self.evolute setUserInteractionEnabled:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });

    }
    
}

-(void)refreshWithNewParameters {
    [self initRandomGeneration];
    [self.collectionView reloadData];
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationNone;
}
@end
