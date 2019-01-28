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
@property (strong, nonatomic) NSMutableArray *showPhotos;
@property (strong, nonatomic) NSMutableArray *selectPhotos;
@property (strong, nonatomic) UIView *editingView;
@property (assign , nonatomic)CGFloat tableHeight;
@property (assign , nonatomic)BOOL edit;
@property (assign , nonatomic)BOOL seleceAll;

@end

@implementation CAPPhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableHeight = self.collectionView.frame.size.height;
    self.selectPhotos = [NSMutableArray array];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.showPhotos = [NSMutableArray array];
    NSArray *array = [CAPUserDefaults objectForKey:kNotificationPhotoCountChange];
    [self.showPhotos addObjectsFromArray:array];
    [self.collectionView reloadData];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.view addSubview:self.editingView];
    
   
    
//    self.edit = NO;
    self.seleceAll = NO;
}
- (void)rightBarItemClick:(UIBarButtonItem *)item{
    if ([item.title isEqualToString:@"编辑"]) {
        if (self.showPhotos.count == 0) {
            return;
        }
        item.title = @"取消";
        [self showEitingView:YES];
        self.edit = YES;
    }else{
        item.title = @"编辑";
        [self showEitingView:NO];
        UIButton *button = (UIButton *)[_editingView viewWithTag:10000];
        [button setTitle:@"全选" forState:UIControlStateNormal];
        self.edit = NO;
        self.seleceAll = NO;
        [self.collectionView reloadData];
    }
}
- (void)showEitingView:(BOOL)isShow
{
    [UIView animateWithDuration:0.3 animations:^{
        self.editingView.frame = CGRectMake(0, isShow ? Main_Screen_Height - 45 : Main_Screen_Height, Main_Screen_Width, 45);
        self.collectionView.frame = CGRectMake(0, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, isShow ? self.tableHeight - 45 : self.tableHeight);
    }];
}

- (UIView *)editingView
{
    if (!_editingView) {
        _editingView = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height, Main_Screen_Width, 45)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor redColor];
        [button setTitle:@"删除" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p__buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(Main_Screen_Width / 2, 0, Main_Screen_Width / 2, 45);
        [_editingView addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor darkGrayColor];
        [button setTitle:@"全选" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p__buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10000;
        button.frame = CGRectMake(0, 0, Main_Screen_Width / 2, 45);
        [_editingView addSubview:button];
    }
    return _editingView;
}
- (void)p__buttonClick:(UIButton *)sender
{
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"删除"]) {
        if (self.seleceAll == YES) {
            [self.showPhotos removeAllObjects];
        }else{
            [self.showPhotos removeObjectsInArray:self.selectPhotos];
        }
        [CAPUserDefaults setObject:self.showPhotos forKey:kNotificationPhotoCountChange];
        NSArray *array = [CAPUserDefaults objectForKey:kNotificationPhotoCountChange];
        self.showPhotos = [NSMutableArray array];
        [self.showPhotos addObjectsFromArray:array];
        [self.collectionView reloadData];
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全选"]) {
        self.seleceAll = YES;
        [sender setTitle:@"全不选" forState:UIControlStateNormal];
        [self.collectionView reloadData];
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全不选"]){
        [sender setTitle:@"全选" forState:UIControlStateNormal];
        self.seleceAll = NO;
        [self.collectionView reloadData];
    }
}

- (void)refreshLocalizedString {
    
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.showPhotos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"photo_cell";
    CAPCheckableCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.delegate = self;
    if (self.seleceAll) {
        cell.checkImage.hidden = NO;
        [cell.checkImage setImage:GetImage(@"end")];
    }else{
        cell.checkImage.hidden = YES;
        [cell.checkImage setImage:GetImage(@"")];
    }
    NSDictionary *dataDic = self.showPhotos[indexPath.row];
    NSData *imgData = dataDic[@"image"];
    [cell.iconImageView setImage:[UIImage imageWithData:imgData]];
    [cell.nameLabel setText:dataDic[@"time"]];
    
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
    if (self.edit) {
        CAPCheckableCollectionCell *cell = sender;
        if ([self.selectPhotos containsObject:[self.showPhotos objectAtIndex:cell.tag]]) {
            cell.checkImage.hidden = YES;
            [cell.checkImage setImage:GetImage(@"")];
            [self.selectPhotos removeObject:[self.showPhotos objectAtIndex:cell.tag]];//addObject:[self.showPhotos objectAtIndex:cell.tag]];
        }else{
            cell.checkImage.hidden = NO;
            [cell.checkImage setImage:GetImage(@"end")];
            [self.selectPhotos addObject:[self.showPhotos objectAtIndex:cell.tag]];
        }
    }
//    else{
//        CAPCheckableCollectionCell *cell = sender;
//        cell.checkImage.hidden = NO;
//        [cell.checkImage setImage:GetImage(@"end")];
//        NSLog(@"onCollectionCellSelectionChanged #%ld", (long)cell.tag);
//        [CAPAlertView initAlertWithContent:@"确定删除该照片吗？"title:@"" closeBlock:^{
//            cell.checkImage.hidden = YES;
//            [cell.checkImage setImage:GetImage(@"")];
//        } okBlock:^{
//            [self.showPhotos removeObjectAtIndex:cell.tag];
//            [CAPUserDefaults setObject:self.showPhotos forKey:kNotificationPhotoCountChange];
//            NSArray *array = [CAPUserDefaults objectForKey:kNotificationPhotoCountChange];
//            self.showPhotos = [NSMutableArray array];
//            [self.showPhotos addObjectsFromArray:array];
//            [self.collectionView reloadData];
//        } alertType:AlertTypeCustom];
//    }
}
@end
