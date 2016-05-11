//
//  TRMapController.h
//  Tarifa
//
//  Created by Rafael Lopez on 12/23/15.
//  Copyright © 2015 Rflpz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Annotation.h"
#import "AFNetworking.h"
#import "NYAlertViewController.h"
#import "TRQuestionsController.h"
#import "KVNProgress.h"
#import "TRWebController.h"
@interface TRMapController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>

@end
