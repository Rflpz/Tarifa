//
//  Annotation.m
//  donvino
//
//  Created by Rafael Lopez on 7/30/15.
//  Copyright (c) 2015 Rflpz. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation
@synthesize coordinate;

- (NSString *)subtitle{
    return nil;
}

- (NSString *)title{
    return nil;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord {
    coordinate=coord;
    return self;
}

-(CLLocationCoordinate2D)coord
{
    return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}
@end
