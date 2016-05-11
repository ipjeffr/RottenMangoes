//
//  Movie.h
//  RottenMangoes
//
//  Created by Jeffrey Ip on 2016-03-28.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (strong, nonatomic) NSString *movieTitle;
@property (strong, nonatomic) NSString *movieSynopsis;
@property (strong, nonatomic) NSString *movieMPAARating;
@property (strong, nonatomic) NSNumber *movieYear;
@property (strong, nonatomic) NSNumber *movieRunTime;
@property (strong, nonatomic) NSDictionary *moviePosters;
@property (strong, nonatomic) NSDictionary *movieLinks;

@end
