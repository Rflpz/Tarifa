//
//  TRReportController.m
//  Tarifa
//
//  Created by Rafael Lopez on 12/24/15.
//  Copyright © 2015 Rflpz. All rights reserved.
//

#import "TRReportController.h"

@interface TRReportController ()
@property (weak, nonatomic) IBOutlet UIButton *btnEnviar;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtError;

@end

@implementation TRReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"REPORTAR ERROR";
    [_btnEnviar setBackgroundColor:[UIColor colorWithRed:241/255.0 green:196/255.0 blue:15/255.0 alpha:1.0f]];
    _btnEnviar.layer.cornerRadius = 40;
    _btnEnviar.clipsToBounds = YES;
    UIImage *sideBarImage = [UIImage imageNamed:@"backButton.png"];
    sideBarImage = [self imageWithImage:sideBarImage scaledToSize:CGSizeMake(23,23)];
    
    
    UIBarButtonItem *sideBarButton = [[UIBarButtonItem alloc]
                                      initWithImage:sideBarImage
                                      style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(back)];
    sideBarButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = sideBarButton;

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
- (IBAction)hideKeyboard:(id)sender {
    [self resignFirstResponder];
}
- (IBAction)sendReport:(id)sender {
    if ([self validateText:_txtEmail] && [self validateText:_txtError]) {
        if ([self NSStringIsValidEmail:_txtEmail.text]) {
            [KVNProgress showWithStatus:@"Enviando reporte"];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer  serializer];
            manager.requestSerializer =  [AFHTTPRequestSerializer serializer];
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            [parameters setValue:_txtEmail.text forKey:@"email"];
            [parameters setValue:_txtError.text forKey:@"reporte"];
            NSLog(@"\n %@ \n",parameters);
            [manager POST:@"http://xcanpet.com/taxi_api/v1/reportes" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                    NSDictionary *responseData;
                    NSError *error = nil;
                    if (responseObject != nil) {
                        responseData = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&error];
                    }
                    if (!responseData) {
                        NSLog(@"Error");
                    }else{
                        NSLog(@"%@",responseData);
                        [KVNProgress showSuccessWithStatus:@"Gracias por ayudarnos a mejorar el app estaremos en contacto contigo."
                                                    onView:self.view];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [KVNProgress dismiss];
                            _txtError.text = @"";
                            _txtEmail.text = @"";
                        });
                        
                    }
                }];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [KVNProgress showErrorWithStatus:@"Lo sentimos"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [KVNProgress dismiss];
                    [self customAlert:@"Verifica tu conexión a internet" :@"Hey!"];
                });
            }];
        }else{
            [self customAlert:@"Verifica tu correo electrónico es inválido" :@"Hey!"];
        }
    }else{
        [self customAlert:@"Todos los campos son necesarios." :@"Oops!"];

    }
    
}
-(BOOL )validateText :(UITextField *)txt{
    if ([txt.text isEqualToString:@""]) {
        return false;
    }
        return true;
}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
-(void)customAlert:(NSString *)info :(NSString *)title{
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    
    alertViewController.title = NSLocalizedString(title, nil);
    alertViewController.message = NSLocalizedString(info, nil);
    
    alertViewController.buttonCornerRadius = 20.0f;
    alertViewController.view.tintColor = self.view.tintColor;
    
    alertViewController.titleFont = [UIFont fontWithName:@"AvenirNext-Bold" size:18.0f];
    alertViewController.messageFont = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0f];
    alertViewController.buttonTitleFont = [UIFont fontWithName:@"AvenirNext-Bold" size:alertViewController.buttonTitleFont.pointSize];
    //
    alertViewController.alertViewBackgroundColor = [UIColor whiteColor];
    alertViewController.alertViewCornerRadius = 10.0f;
    
    alertViewController.titleColor = [UIColor colorWithRed:44/255.0 green:62/255.0 blue:80/255.0 alpha:1.0f];
    alertViewController.messageColor = [UIColor blackColor];
    
    alertViewController.buttonColor = [UIColor colorWithRed:241/255.0 green:196/255.0 blue:15/255.0 alpha:1.0f];
    alertViewController.buttonTitleColor = [UIColor blackColor];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}
@end
