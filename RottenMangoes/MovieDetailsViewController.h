//
//  MovieDetailsViewController.h
//  RottenMangoes
//
//  Created by Tenzin Phagdol on 2016-03-28.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Movie;
@class MovieReview;

@interface MovieDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *movieDetailsTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieDetailsYear;
@property (weak, nonatomic) IBOutlet UILabel *movieDetailsMPAA;
@property (weak, nonatomic) IBOutlet UILabel *movieDetailsRunTime;
@property (weak, nonatomic) IBOutlet UILabel *movieDetailsSynopsis;
@property (weak, nonatomic) IBOutlet UILabel *review1;
@property (weak, nonatomic) IBOutlet UILabel *review2;
@property (weak, nonatomic) IBOutlet UILabel *review3;


@property (strong, nonatomic) Movie *movieDetails;
@property (strong, nonatomic) MovieReview *reviewDetails;

@end
