//
//  TRMapController.m
//  Tarifa
//
//  Created by Rafael Lopez on 12/23/15.
//  Copyright © 2015 Rflpz. All rights reserved.
//

#import "TRMapController.h"

@interface TRMapController ()
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) Annotation *myPin;
@property (weak, nonatomic) IBOutlet UIButton *btnCalculate;
@property (strong, nonatomic) NSString *yLat, *yLon, *xLat, *xLon;
@end

@implementation TRMapController
BOOL isFirstTime = true;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TARIFA";
    isFirstTime = true;
    [_btnCalculate setBackgroundColor:[UIColor colorWithRed:241/255.0 green:196/255.0 blue:15/255.0 alpha:1.0f]];
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:196/255.0 blue:15/255.0 alpha:1.0f];
    _btnCalculate.layer.cornerRadius = 40;
    _btnCalculate.clipsToBounds = YES;
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    id userAnnotation= _map.userLocation;
    if(userAnnotation!=nil)
        [self.map addAnnotation:userAnnotation];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleGesture:)];
    lpgr.minimumPressDuration = 0.8;
    [_map addGestureRecognizer:lpgr];
}
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    [_map removeAnnotations:_map.annotations];
    CGPoint touchPoint = [gestureRecognizer locationInView:_map];
    CLLocationCoordinate2D touchMapCoordinate =
    [_map convertPoint:touchPoint toCoordinateFromView:_map];
    
    MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
    pa.coordinate = touchMapCoordinate;
    CLLocationCoordinate2D droppedAt = pa.coordinate;
    NSLog(@"Pin handled at %f,%f", droppedAt.latitude, droppedAt.longitude);
    _yLat = [NSString stringWithFormat:@"%f",droppedAt.latitude];
    _yLon = [NSString stringWithFormat:@"%f",droppedAt.longitude];
    [_map addAnnotation:pa];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (newLocation.coordinate.latitude != 0.0f && newLocation.coordinate.longitude != 0.0f) {
        [_locationManager stopUpdatingLocation];
        if (isFirstTime) {
            [self.map setCenterCoordinate:newLocation.coordinate animated:YES];
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            span.latitudeDelta = 0.1;
            span.longitudeDelta= 0.1;
            
            CLLocationCoordinate2D location;
            location.latitude = newLocation.coordinate.latitude;
            location.longitude = newLocation.coordinate.longitude;
            _xLat = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
            _xLon = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
            _yLat = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
            _yLon = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
            region.span = span;
            region.center =location;
            _myPin = [[Annotation alloc] initWithCoordinate:newLocation.coordinate];
            [self.map addAnnotation:_myPin];
            [_map setRegion:region animated:TRUE];
            [_map regionThatFits:region];
            isFirstTime = false;
        }
    }
}
- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.map dequeueReusableAnnotationViewWithIdentifier: @"myPin"];
    if (pin == nil) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"myPin"];
    } else {
        pin.annotation = annotation;
    }
    pin.pinTintColor = [UIColor blackColor];
    pin.animatesDrop = YES;
    pin.draggable = YES;
    return pin;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState{
    if (newState == MKAnnotationViewDragStateEnding){
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        _yLat = [NSString stringWithFormat:@"%f",droppedAt.latitude];
        _yLon = [NSString stringWithFormat:@"%f",droppedAt.longitude];
    }
}
- (IBAction)calculate:(id)sender {
    [KVNProgress showWithStatus:@"Procesando la solicitud"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer  serializer];
    manager.requestSerializer =  [AFHTTPRequestSerializer serializer];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:_xLat forKey:@"Xlatitud"];
    [parameters setValue:_xLon forKey:@"Xlongitud"];
    [parameters setValue:_yLat forKey:@"Ylatitud"];
    [parameters setValue:_yLon forKey:@"Ylongitud"];
    NSLog(@"\n %@ \n",parameters);
    [manager POST:@"http://xcanpet.com/taxi_api/v1/calculaprecio" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                NSDictionary *obj = responseData;
                if ([[obj valueForKey:@"precio"]isEqualToString:@"SIN ZONA"]) {
                    NSLog(@"ERROR NOT ZONE");
                    [KVNProgress showErrorWithStatus:@"Lo sentimos"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [KVNProgress dismiss];
                        [self customAlert:@"Con la ubicación obtenida no es posible obtener una tarifa." :@"Hey!"];
                    });
                }else{
                    [KVNProgress showSuccessWithStatus:@"Listo"
                                                onView:self.view];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [KVNProgress dismiss];
                        NSString *message = [NSString stringWithFormat:@"El precio es de: $%@.\nDe la zona %@ hasta la zona %@",[obj valueForKey:@"precio"],[obj valueForKey:@"zonaX"],[obj valueForKey:@"zonaY"]];
                        [self customAlert:message :@"Precio de tarifa"];
                    });
                }
                
                
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
- (IBAction)goToFAQs:(id)sender {
    TRQuestionsController *questionsController = [[TRQuestionsController alloc]initWithNibName:@"TRQuestionsController" bundle:nil];
    [self.navigationController pushViewController:questionsController animated:YES];
}
- (IBAction)goToMapGoogle:(id)sender {
    TRWebController *webController = [[TRWebController alloc]initWithNibName:@"TRWebController" bundle:nil];
    webController.title = @"RUTA ÓPTIMA";
    webController.URLToSend = [NSString stringWithFormat:@"https://www.google.com.mx/maps/dir/%@,%@/%@,%@",_xLat,_xLon,_yLat,_yLon];
    [self.navigationController pushViewController:webController animated:YES];
}
@end
