//
//  MovieDetailsViewController.h
//  RottenMangoes
//
//  Created by Tenzin Phagdol on 2016-03-28.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *movieDetailsTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieDetailsYear;
@property (weak, nonatomic) IBOutlet UILabel *movieDetailsMPAA;
@property (weak, nonatomic) IBOutlet UILabel *movieDetailsRunTime;
@property (weak, nonatomic) IBOutlet UILabel *movieDetailsSynopsis;

@property (strong, nonatomic) Movie *movieDetails;

@end
