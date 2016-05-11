//
//  Annotation.h
//  donvino
//
//  Created by Rafael Lopez on 7/30/15.
//  Copyright (c) 2015 Rflpz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject<MKAnnotation>{
    CLLocationCoordinate2D coordinate;
}
- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
