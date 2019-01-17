//
//  CAPPhotoListViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPPhotoListViewController.h"
#import "CAPCheckableCollectionCell.h"

@interface CAPPhotoListViewController () <UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CAPSelectableCollectionCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CAPPhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)refreshLocalizedString {
    
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"photo_cell";
    CAPCheckableCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    CAPMedia *media = self.group.allAssets[indexPath.row];
//    cell.iconImageView.image = (self.isVideo ? gCfg.defaultVideoImage : gCfg.defaultPhotoImage);
//    [self.category loadThumb:media cell:cell];
//
//    cell.checkButton.selected = [_selections[indexPath.row] boolValue];
//    cell.nameLabel.textColor = [UIColor redColor];
//    cell.nameLabel.text = s;
    
    //[cell.contentButton setTitle:(self.isVideo ? [CAPFormats formatDuration:((CAPVideo *)media).duration] : @"") forState:UIControlStateNormal];
    
    cell.tag = indexPath.row;
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = collectionView.frame.size.width/4-5;
    return CGSizeMake(width, width);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(4, 4, 4, 4);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell #%ld was selected", (long)indexPath.row);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(self.collectionView.frame.size.width, 0);
}

-(void)onCollectionCellSelectionChanged:(id)sender {
    CAPCheckableCollectionCell *cell = sender;
    NSLog(@"onCollectionCellSelectionChanged #%ld", (long)cell.tag);
}
@end
