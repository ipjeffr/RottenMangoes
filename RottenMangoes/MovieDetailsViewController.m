//
//  MovieDetailsViewController.m
//  RottenMangoes
//
//  Created by Tenzin Phagdol on 2016-03-28.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "MapViewController.h"
#import "Movie.h"
#import "MovieReview.h"

@interface MovieDetailsViewController ()

@property NSMutableArray *reviewObjects;

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *reviewsURL = [self.movieDetails.movieLinks objectForKey:@"reviews"];
    NSString *reviewsURLwithAPI = [reviewsURL stringByAppendingString:@"?apikey=2ckft9dtnazuw4ks5qq3uhzu"];
    
    NSURL *url = [NSURL URLWithString:reviewsURLwithAPI];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            
            NSError *jsonError;
            
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (!jsonError) {
                NSMutableArray *reviewArray = [NSMutableArray array];
                
                for (NSDictionary *reviewDict in jsonObject[@"reviews"]) {
                    MovieReview *reviews = [[MovieReview alloc] init];
                    reviews.reviewCritic = reviewDict[@"critic"];
                    reviews.reviewFreshness = reviewDict[@"freshness"];
                    reviews.reviewQuote = reviewDict[@"quote"];
                    
                    [reviewArray addObject:reviews];
                }
                
                NSLog(@"reviews: %@", reviewArray);
                
                self.reviewObjects = reviewArray;
            
                //essentially updates the UI after gathering the API data
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateReviews];
                });
            }
            
        } else {
            NSLog(@"There was an error: %@", error.localizedDescription);
        }
        
    }];
    
    [dataTask resume];
    
    self.movieDetailsTitle.text = self.movieDetails.movieTitle;
    self.movieDetailsYear.text = [self.movieDetails.movieYear stringValue];
    self.movieDetailsMPAA.text = self.movieDetails.movieMPAARating;
    self.movieDetailsRunTime.text = [self.movieDetails.movieRunTime stringValue];
    self.movieDetailsSynopsis.text = self.movieDetails.movieSynopsis;
}

- (void)updateReviews {
    self.review1.text = [NSString stringWithFormat:@"%@\n<%@>\n%@", [self.reviewObjects[0] reviewCritic], [self.reviewObjects[0] reviewFreshness], [self.reviewObjects[0] reviewQuote]];
    self.review2.text = [NSString stringWithFormat:@"%@\n<%@>\n%@", [self.reviewObjects[1] reviewCritic], [self.reviewObjects[1] reviewFreshness], [self.reviewObjects[1] reviewQuote]];
    self.review3.text = [NSString stringWithFormat:@"%@\n<%@>\n%@", [self.reviewObjects[2] reviewCritic], [self.reviewObjects[2] reviewFreshness], [self.reviewObjects[2] reviewQuote]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapViewController *theatreVC = (MapViewController *) segue.destinationViewController;
    theatreVC.movieDetailsForTitle = self.movieDetails;
}

@end
