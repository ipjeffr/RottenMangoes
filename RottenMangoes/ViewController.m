//
//  ViewController.m
//  RottenMangoes
//
//  Created by Tenzin Phagdol on 2016-03-28.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import "ViewController.h"
#import "MovieDetailsViewController.h"
#import "Movie.h"
#import "MovieCell.h"
#import "MovieReview.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property NSMutableArray *movieObjects;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // We need to create a NSURL of the api we want to access
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=2ckft9dtnazuw4ks5qq3uhzu"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // The completion handler is code that will run when the request is completed
        if (!error) {
            
            NSError *jsonError;
            
            //takes the raw API data and converts it into a form useable by Objective C
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (!jsonError) {
                NSMutableArray *moviesArray = [NSMutableArray array];
            
            //jsonObject[@"movies"] grabs all of the objects/values associated with the key @"movies" in the jsonObject NSDictionary (see JSON View in Google)
                for (NSDictionary *moviesDict in jsonObject[@"movies"]) {
                    Movie *movies = [[Movie alloc] init];
                    movies.movieTitle = moviesDict[@"title"];
                    movies.movieYear = moviesDict[@"year"];
                    movies.movieMPAARating = moviesDict [@"mpaa_rating"];
                    movies.movieRunTime = moviesDict [@"runtime"];
                    movies.movieSynopsis = moviesDict[@"synopsis"];
                    movies.moviePosters = moviesDict[@"posters"];
                    movies.movieLinks = moviesDict[@"links"];
                    
                    [moviesArray addObject:movies];
                }
                
                NSLog(@"movies: %@", moviesArray);
                //sets moviesArray to the moviesObjects array of the view controller
                self.movieObjects = moviesArray;
                
                // tell table to reload in main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];//reloadData at the end of the completion handler, not the end of the viewDidLoad because the completion handler runs after [dataTask resume]
                });
                
            }
            
        } else {
            NSLog(@"There was an error: %@", error.localizedDescription);
        }
        
    }];//completion handler block ends
    
    // Call resume on the task to start it -- like pressing enter in a web browser to navigate to a webpage/ retrieve the data
    [dataTask resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movieObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    //defines one specific movie objects in the array of movie objects we've defined above; each contains properties defined in the class -- retrieve those for display
    Movie *movie = self.movieObjects[indexPath.item];
    
    NSString *posterURL = [movie.moviePosters objectForKey:@"thumbnail"];
    
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: posterURL]];
    
    cell.moviePoster.image = [UIImage imageWithData: imageData];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    MovieDetailsViewController *detailVC = (MovieDetailsViewController *) segue.destinationViewController;
    NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];

    Movie *cellData = [self.movieObjects objectAtIndex:indexPath.row];
    
    detailVC.movieDetails = cellData;
}

@end
