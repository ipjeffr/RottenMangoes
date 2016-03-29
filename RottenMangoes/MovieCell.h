//
//  MovieCell.h
//  RottenMangoes
//
//  Created by Tenzin Phagdol on 2016-03-28.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moviePoster;

@end