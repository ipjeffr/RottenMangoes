//
//  MapViewController.m
//  RottenMangoes
//
//  Created by Tenzin Phagdol on 2016-03-29.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Movie.h"
#import "Theatre.h"

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSString *currentZipCode;
@property (strong, nonatomic) NSString *theatresURL;
@property NSArray *theatreObjects;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self setupLocationManager];
}

- (void)setupLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager requestLocation];
}

- (void)reverseGeocodeAnAddress {

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error){
        
        if (error) {
            // handle error
        } else {
            CLPlacemark *placeMark = [placemarks lastObject];
            NSString * zipCode = placeMark.postalCode;
            self.currentZipCode = zipCode;
        }
    }];
}

-(void)setCurrentZipCode:(NSString *)currentZipCode {
    _currentZipCode = currentZipCode;
    NSLog(@"Geocoded location: %@", _currentZipCode);
    [self setupURLRequest];
}

-(void)setupURLRequest {
    [self pieceTogetherURLString];
    NSLog(@"%@", self.theatresURL);
    [self fetchAPIData];
}

-(void)pieceTogetherURLString {
    NSString *theatresPreURL = @"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=";
    NSString *zipCode = [self.currentZipCode stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *theatresURLandZip = [theatresPreURL stringByAppendingString:zipCode];
    NSString *movieTitle = [self.movieDetailsForTitle.movieTitle stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *movieTitleURL = [@"&movie=" stringByAppendingString:movieTitle];
    NSString *theatresURL = [theatresURLandZip stringByAppendingString:movieTitleURL];
    self.theatresURL = theatresURL;
}

-(void)fetchAPIData {
    NSURL *url = [NSURL URLWithString:self.theatresURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            
            NSError *jsonError;
            
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (!jsonError) {
                NSMutableArray *theatreArray = [NSMutableArray array];
                
                for (NSDictionary *theatreDict in jsonObject[@"theatres"]) {
                    NSLog(@"====>>> %@", theatreDict);
                    
                    NSString *lat = theatreDict[@"lat"];
                    NSString *longit = theatreDict[@"lng"];
                    
                    Theatre *theatres = [[Theatre alloc] initWithLat:lat longitude:longit];
                    theatres.theatreName = theatreDict[@"name"];
                    theatres.theatreAddress = theatreDict[@"address"];
                    
                    [theatreArray addObject:theatres];
                }
                NSLog(@"theatres: %@", theatreArray);
                
                self.theatreObjects = [theatreArray copy];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView showAnnotations:self.theatreObjects animated:NO];
                });
            }
        } else {
            NSLog(@"There was an error: %@", error.localizedDescription);
        }
    }];
    [dataTask resume];
}

//[self.mapView showAnnotations:self.theatreObjects animated:NO] call this method indirectly
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    NSLog(@"===>>> coordinates: lat: %@, long: %@", @(annotation.coordinate.latitude), @(annotation.coordinate.longitude));
    static NSString *identifier = @"identifier";
    MKPinAnnotationView *view = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if(!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    return view;
}

#pragma mark- CLLocationDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    // This gets called when the user provides location services permission.
    
    // If they give permission, start tracking the user's location
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager requestLocation];
    }
}

//Location Manager Delegate calls this method/updates it whenever location changed
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *location = [locations lastObject];
    
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    
    self.currentLocation = currentLocation;
    
    [self.mapView setRegion:region animated:YES];
    
    NSLog(@"%@", locations);
    
    [self reverseGeocodeAnAddress];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
}

@end
