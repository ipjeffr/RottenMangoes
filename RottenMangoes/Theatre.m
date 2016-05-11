//
//  Theatre.m
//  RottenMangoes
//
//  Created by Jeffrey Ip on 2016-03-29.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import "Theatre.h"

@implementation Theatre

@synthesize coordinate = _coordinate;

-(instancetype)initWithLat:(NSString*)latitude longitude:(NSString*)longitude {
    if (self = [super init]) {
        double l1 = [latitude doubleValue];
        double l2 = [longitude doubleValue];
        _coordinate = CLLocationCoordinate2DMake(l1, l2);
        
    }return self;
}

@end
