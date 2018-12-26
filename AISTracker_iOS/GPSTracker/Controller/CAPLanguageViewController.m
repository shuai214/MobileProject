//
//  CAPLanguageViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPLanguageViewController.h"
#import "CAPUserPresenter.h"

@interface CAPLanguageViewController () <UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) NSArray *languages;
@property (strong, nonatomic) CAPUserPresenter *userPresenter;
@end

@implementation CAPLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userPresenter = [[CAPUserPresenter alloc] init];
    self.languages = self.userPresenter.languages;
    
    self.maskView.layer.cornerRadius = self.view.bounds.size.width * 0.3;
    self.maskView.layer.masksToBounds = YES;
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    [self.userPresenter presentLanguage:self.pickerView];
}

- (void)refreshLocalizedString {
    
}

- (IBAction)onOkButtonClicked:(id)sender {
    NSUInteger selectedRow = [self.pickerView selectedRowInComponent:0];
    [self.userPresenter changeLanguage:selectedRow];
}

#pragma mark - UIPickerView

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.languages.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return self.pickerView.frame.size.height/self.languages.count;
}

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return  self.pickerView.frame.size.width;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view) {
        view = [[UIView alloc] init];
    }
    
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.pickerView.frame.size.width, self.pickerView.frame.size.height/self.languages.count)];
    text.textAlignment = NSTextAlignmentCenter;
    text.text = self.languages[row];
    [view addSubview:text];
    return view;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return @"";
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString:self.languages[row]];
    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [AttributedString  length])];
    return AttributedString;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"didSelectRow: %lu", (unsigned long)row);
}

@end