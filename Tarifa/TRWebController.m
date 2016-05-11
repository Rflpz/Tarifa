//
//  TRWebController.m
//  Tarifa
//
//  Created by Rafael Lopez on 12/24/15.
//  Copyright © 2015 Rflpz. All rights reserved.
//

#import "TRWebController.h"

@interface TRWebController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TRWebController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [KVNProgress showWithStatus:@"Cargando contenido"];

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: _URLToSend ] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [self.webView loadRequest: request];
    
    self.webView.scalesPageToFit = YES;
    UIBarButtonItem *sideBarButton = [[UIBarButtonItem alloc]
                                      initWithImage:[self imageWithImage:[UIImage imageNamed:@"backButton.png"] scaledToSize:CGSizeMake(20,20)]
                                      style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(goBack)];
    sideBarButton.tintColor = [UIColor colorWithRed:44/255.0 green:62/255.0 blue:80/255.0 alpha:1.0];
    self.navigationItem.leftBarButtonItem = sideBarButton;
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (webView.isLoading)
        return;
    else{
        [KVNProgress showSuccessWithStatus:@"Listo"
                                    onView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [KVNProgress dismiss];
        });
    }
}

@end
