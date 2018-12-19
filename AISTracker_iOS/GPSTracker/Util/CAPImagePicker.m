//
//  CAPImages.m
//  Neptu
//
//  Created by WeifengYao on 2/4/2018.
//  Copyright © 2018 capelabs. All rights reserved.
//

#import "CAPImagePicker.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface CAPImagePicker () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) UIImagePickerController *picker;
@end

@implementation CAPImagePicker

- (void)pickImageAndSaveAtPath:(NSString *)path {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.allowsEditing = NO;
    controller.showsCameraControls = YES;
    controller.videoMaximumDuration = 0.1; //minutes
    controller.mediaTypes =  [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    controller.videoQuality = UIImagePickerControllerQualityTypeHigh;
    self.picker = controller;
    //[self showViewController:self.picker sender:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"didFinishPickingMediaWithInfo");
    //[_imagePicker popToRootViewControllerAnimated:YES];
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        UIImage *image;
        if(picker.allowsEditing) {
            image = info[UIImagePickerControllerEditedImage];
            //            UIGraphicsBeginImageContext(CGSizeMake(20, 20));
            //            [image drawInRect:CGRectMake(0, 0, 20, 20)];
            //            image = UIGraphicsGetImageFromCurrentImageContext();
            //            UIGraphicsEndImageContext();
        } else {
            image = info[UIImagePickerControllerOriginalImage];
        }
        [self backupPhoto:image];
    }
    
    //    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary])  {
        picker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
        picker.sourceType =    UIImagePickerControllerSourceTypeCamera;
    } else {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    //[picker startVideoCapture];
    //[[picker undoManager] undo];
    //[picker.navigationController popViewControllerAnimated:YES];
    //    [_imagePicker dismissViewControllerAnimated:NO completion:nil];
    //    [self presentViewController:_imagePicker animated:NO completion:nil];
    //http://www.jianshu.com/p/13c351b1e663
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"imagePickerControllerDidCancel");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)backupPhoto:(UIImage *)image {
    NSLog(@"backupPhoto");
//    NSData *thumbData = [CAPViews createThumbFromImage:image];
//    NSData *imageData = UIImagePNGRepresentation(image);
//    DLog(@"thumb size: %lu, image size: %lu", (unsigned long) thumbData.length, (unsigned long)imageData.length);
//    //[self saveThumbData:thumbData];
//    NSLog(@"======= Camera Image Data ========");
//
//    [CAPFiles saveData:thumbData toDocumentFile:@"camera_thumb.png"];
//    [CAPFiles saveData:imageData toDocumentFile:@"camera_image.png"];
    
}
@end
