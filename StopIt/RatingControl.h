//
//  RatingControl.h
//  RatingControl
//


#import <UIKit/UIKit.h>

typedef void (^EditingChangedBlock)(NSUInteger rating);
typedef void (^EditingDidEndBlock)(NSUInteger rating);


@interface RatingControl : UIControl

@property (nonatomic, assign) NSInteger maxRating;
@property (nonatomic, assign) NSInteger rating;
@property (nonatomic, readwrite) NSUInteger starFontSize;
@property (nonatomic, readwrite) NSUInteger starWidthAndHeight;
@property (nonatomic, readwrite) NSUInteger starSpacing;
@property (nonatomic, copy) EditingChangedBlock editingChangedBlock;
@property (nonatomic, copy) EditingDidEndBlock editingDidEndBlock;


- (id)initWithLocation:(CGPoint)location andMaxRating:(NSInteger)maxRating;

- (id)initWithLocation:(CGPoint)location
            emptyColor:(UIColor *)emptyColor
            solidColor:(UIColor *)solidColor
          andMaxRating:(NSInteger)maxRating;

- (id)initWithLocation:(CGPoint)location
            emptyImage:(UIImage *)emptyImageOrNil
            solidImage:(UIImage *)solidImageOrNil
          andMaxRating:(NSInteger)maxRating;



@end
