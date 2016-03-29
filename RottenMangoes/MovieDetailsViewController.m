//
//  MovieDetailsViewController.m
//  RottenMangoes
//
//  Created by Tenzin Phagdol on 2016-03-28.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import "MovieDetailsViewController.h"

@interface MovieDetailsViewController ()

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.movieDetailsTitle.text = self.movieDetails.movieTitle;
    self.movieDetailsYear.text = [self.movieDetails.movieYear stringValue];
    self.movieDetailsMPAA.text = self.movieDetails.movieMPAARating;
    self.movieDetailsRunTime.text = [self.movieDetails.movieRunTime stringValue];
    self.movieDetailsSynopsis.text = self.movieDetails.movieSynopsis;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
