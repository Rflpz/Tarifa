//
//  TRAnswerController.m
//  Tarifa
//
//  Created by Rafael Lopez on 12/26/15.
//  Copyright © 2015 Rflpz. All rights reserved.
//

#import "TRAnswerController.h"

@interface TRAnswerController ()

@end

@implementation TRAnswerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *sideBarImage = [UIImage imageNamed:@"backButton.png"];
    sideBarImage = [self imageWithImage:sideBarImage scaledToSize:CGSizeMake(23,23)];
    
    
    UIBarButtonItem *sideBarButton = [[UIBarButtonItem alloc]
                                      initWithImage:sideBarImage
                                      style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(back)];
    sideBarButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = sideBarButton;
    _lblAnswer.text = _respuesta;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
