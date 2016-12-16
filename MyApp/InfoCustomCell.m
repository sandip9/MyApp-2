//
//  MyAppTableViewCell.m
//  MyApp
//
//  Created by mac_admin on 14/12/16.
//  Copyright © 2016 mac_admin. All rights reserved.
//

#import "InfoCustomCell.h"

@implementation InfoCustomCell

NSOperationQueue *queue;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //[self.contentView setBackgroundColor:[UIColor lightGrayColor]];
        
        self.title = [UILabel new];
        [self.title setNumberOfLines:0];
        [self.title setTextColor:[UIColor blackColor]];
        [self.title setBackgroundColor:[UIColor clearColor]];
        [self.title setFont:TitleFont];
        [self.title setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.title];
        
        self.descriptionDetail = [UILabel new];
        [self.descriptionDetail setNumberOfLines:0];
        [self.descriptionDetail setTextColor:[UIColor blackColor]];
        [self.descriptionDetail setBackgroundColor:[UIColor clearColor]];
        [self.descriptionDetail setFont:DescriptionFont];
        [self.descriptionDetail setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.descriptionDetail];
        
        self.thumbNailImage = [[UIImageView alloc] init];
        self.thumbNailImage.backgroundColor = [UIColor grayColor];
        self.thumbNailImage.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.thumbNailImage];
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.thumbNailImage addSubview:self.spinner];
        //[self.spinner startAnimating];
        [self.contentView layoutSubviews];
        
        [self updateCellConstraints];
    }
    return self;
}

- (void)updateCellConstraints
{
    NSDictionary *viewsDictionary = @{@"title":self.title ,@"descriptionL":self.descriptionDetail ,@"imageV":self.thumbNailImage};
    
    NSArray *constraints;

    constraints= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[title]"
                                                         options: 0
                                                         metrics:nil
                                                           views:viewsDictionary];
    [self.contentView addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[title]-10-[descriptionL]"
                                                          options: 0
                                                          metrics:nil
                                                            views:viewsDictionary];
    [self.contentView addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[title]-5-[imageV(50)]"
                                                          options: 0
                                                          metrics:nil
                                                            views:viewsDictionary];
    [self.contentView addConstraints:constraints];

    constraints= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[title]-|"
                                                         options: 0
                                                         metrics:nil
                                                           views:viewsDictionary];
    [self.contentView addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[descriptionL]-5-[imageV(50)]-|"
                                                          options: 0
                                                          metrics:nil
                                                            views:viewsDictionary];
    [self.contentView addConstraints:constraints];
    
}

-(void)setThumbnailUrlString:(NSString *)urlString {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        /*NSURL *url = [NSURL URLWithString:urlString];
        UIImage *urlImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];*/
        NSString *tStrThumbnails = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Thumbnails"];
        NSURL *tImageFileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.jpg", tStrThumbnails, _title.text] isDirectory:NO];
        NSData  *tImageData = [NSData dataWithContentsOfURL:tImageFileURL];
        
        if(tImageData) {
            [self setImageData:tImageData];
        } else {
            [self setThumbnailImageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
        }
    });
    
}

-(void)setThumbnailImageWithData:(NSData*)aImageData {
    
    NSError *tError = nil;
    NSString *tStrThumbnails = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Thumbnails"];
    
    if(tError != nil) {
        NSLog(@"ImageDownloadService : HTMLParser : %@ : Error : %zd : %@ : %@", tStrThumbnails, tError.code, tError.domain, tError.localizedDescription);
        return;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:tStrThumbnails]) {
        
        if(![[NSFileManager defaultManager] createDirectoryAtPath:tStrThumbnails withIntermediateDirectories:YES attributes:nil error:&tError]) {
            NSLog(@"ImageDownloadService : saveContactImage : %@ : Error : %zd : %@ : %@", tStrThumbnails, tError.code, tError.domain, tError.localizedDescription);
            return;
        }
    }
    
    if(tError == nil) {
        NSURL *tImageFileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.png", tStrThumbnails, _title.text] isDirectory:NO];
        [aImageData writeToURL:tImageFileURL
                       options:NSDataWritingFileProtectionComplete
                         error:&tError];
        
        if(tError != nil) {
            NSLog(@"ImageDownloadService : saveContactImage : %@ : Error : %zd : %@ : %@", tStrThumbnails, tError.code, tError.domain, tError.localizedDescription);
            return;
        }
        
        [self setImageData:aImageData];
    }
    
}

-(void)setImageData:(NSData *)aData {
    dispatch_async(dispatch_get_main_queue(),^{
        if (aData) {
            _thumbNailImage.image = [[UIImage alloc] initWithData:aData];
            [self.spinner stopAnimating];
        } else {
            _thumbNailImage.image = [UIImage imageNamed:@"defaultImages"];
        }
    });
}

@end
