//
//  TakePhotoViewController.m
//  test
//
//  Created by ceaselez on 12/12/17.
//  Copyright © 2017 ceaselez. All rights reserved.
//

#import "TakePhotoViewController.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "MySharedManager.h"

@interface TakePhotoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
#define FILE_EXTENSION    @".png"
#define IMAGE_NAME        @"CameraImage"
}
@end

@implementation TakePhotoViewController
{
    __weak IBOutlet UIImageView *visitngCardIV;
    __weak IBOutlet UIImageView *idIV;
    UIImagePickerController *visitingCardPicker;
    UIImagePickerController *idPicker;
    MySharedManager *sharedManager;
    __weak IBOutlet UITextField *contentTF;
    
    NSURL *url1;
    NSURL *url2;
    NSString *imageString1;
    NSString *imageString2;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sharedManager = [MySharedManager sharedManager];
 
    if (![sharedManager.imageString1 isEqualToString:@""] || ![sharedManager.imageString2 isEqualToString:@""] || ![sharedManager.passingString isEqualToString:@""]) {
        contentTF.text = sharedManager.passingString;
        for (int i = 0 ; i<2; i++) {
            NSString *urlString;
            if (i ==0) {
                urlString = sharedManager.imageString1;
                url1 = [NSURL URLWithString:sharedManager.imageString1];
                imageString1 = sharedManager.imageBase64String1;
            }
            else{
                urlString = sharedManager.imageString2;
                url2 = [NSURL URLWithString:sharedManager.imageString2];
                imageString2 = sharedManager.imageBase64String2;

            }
            NSURL *url = [NSURL URLWithString:urlString];
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
            {
                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                @autoreleasepool {
                    CGImageRef iref = [rep fullScreenImage];
                    if (iref) {
                        UIImage *image = [UIImage imageWithCGImage:iref];
                        if (i == 0) {
                            visitngCardIV.image = image;
                        }
                        else{
                            idIV.image = image;
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //UIMethod trigger...
                        });
                        iref = nil;
                    }
                }
            };
            
            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
            {
                NSLog(@"Can't get image - %@",[myerror localizedDescription]);
            };
            
            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
            [assetslibrary assetForURL:url
                           resultBlock:resultblock
                          failureBlock:failureblock];
    }
   
    }
   
    visitingCardPicker = [[UIImagePickerController alloc] init];
    visitingCardPicker.delegate = self;
    visitingCardPicker.allowsEditing = YES;
    
    idPicker = [[UIImagePickerController alloc] init];
    idPicker.delegate = self;
    idPicker.allowsEditing = YES;
}
- (IBAction)visitingCardBtn:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Take a photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        visitingCardPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:visitingCardPicker animated:YES completion:nil];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Choose from Libary" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        visitingCardPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:visitingCardPicker animated:YES completion:nil];

    }];
    
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
 
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];

    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImage* cameraImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        ALAssetsLibrary* assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        [assetsLibrary writeImageToSavedPhotosAlbum:cameraImage.CGImage
                                           metadata:[info objectForKey:UIImagePickerControllerMediaMetadata]
                                    completionBlock:^(NSURL *assetURL, NSError *error) {
                                        
                                        if (!error) {
                                            if (picker == visitingCardPicker) {
                                                visitngCardIV.image = chosenImage;
                                                url1 = assetURL;
                                                imageString1 = [self encodeToBase64String:chosenImage];
                                            }
                                            else{
                                                idIV.image = chosenImage;
                                                url2 = assetURL;
                                                imageString2 = [self encodeToBase64String:chosenImage];
                                            }

                                        }
                                    }];
    }
else
{
    if (picker == visitingCardPicker) {
        visitngCardIV.image = chosenImage;
        url1 = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        imageString1 = [self encodeToBase64String:chosenImage];
    }
    else{
        idIV.image = chosenImage;
        url2 = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        imageString2 = [self encodeToBase64String:chosenImage];
    }
}
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)profile:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Take a photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        idPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:idPicker animated:YES completion:nil];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Choose from Libary" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        idPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:idPicker animated:YES completion:nil];
        
    }];
    
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
  
}
- (IBAction)backBtn:(id)sender {
    if (sharedManager.imageString1  == nil) {
        sharedManager.imageString1 = @"";
    }
    else
    sharedManager.imageString1 =sharedManager.imageString1;
    if (sharedManager.imageString2 == nil) {
        sharedManager.imageString2 = @"";
    }
    else
    sharedManager.imageString2 =sharedManager.imageString2 ;
    if (sharedManager.imageBase64String1 == nil) {
        sharedManager.imageBase64String1 = @"";
    }
    else
    sharedManager.imageBase64String1 = sharedManager.imageBase64String1;
    if (sharedManager.imageBase64String2 == nil) {
        sharedManager.imageBase64String2 = @"";
    }
    else
    sharedManager.imageBase64String2 = sharedManager.imageBase64String2;
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)uploadBtn:(id)sender {
    sharedManager.imageString1 =[NSString stringWithFormat:@"%@",url1];
    sharedManager.imageString2 =[NSString stringWithFormat:@"%@",url2] ;
    sharedManager.passingString = contentTF.text;
    sharedManager.imageBase64String1 = imageString1;
    sharedManager.imageBase64String2 = imageString2;
   

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}


@end
