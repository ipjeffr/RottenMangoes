//
//  Theatre.h
//  RottenMangoes
//
//  Created by Tenzin Phagdol on 2016-03-29.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

@import MapKit;

@interface Theatre : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *theatreName;
@property (nonatomic, strong) NSString *theatreAddress;

-(instancetype)initWithLat:(NSString*)latitude longitude:(NSString*)longitude;

@end
