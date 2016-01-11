//
//  ViewController.m
//  StopIt
//
//  Created by Vasanth Ravichandran on 22/04/15.
//  Copyright (c) 2015 msf. All rights reserved.
//

#import "StopMeViewController.h"
#import "TimerLabel.h"
#import "SnowFallView.h"
#import "RatingControl.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "AppMacros.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
//#define UIColorFromRGB(rgbValue) [UIColor \
//colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
//green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
//blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ZERO_ACHEIVEMENT 1000

#define colorTimerFont UIColorFromRGB(0xFFC040)
#define colorScoreFont UIColorFromRGB(0x808040)
#define colorScreenBackground [UIColor blackColor]
#define colorResultWindow [UIColor purpleColor]

@interface StopMeViewController ()
{
    UILabel *lblShowTarget,*lblShowTimer,*lblShowBest,*lblShowTotal,*lblShowNumberOfFiveStar,*lblNotification;
    UILabel *lblTargetKey;
    TimerLabel *timer;
    int currentTime;
    long output;
    UIView *viewResult;
    BOOL isStarted;
    SnowFallView *snowView;
    UIView *contentView;
    GADBannerView  *bannerAdView;
    NSTimer *timerLevelBased;
}
@end

@implementation StopMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createView];
    [self.view setBackgroundColor:colorScreenBackground];//colorScreenBackground
    [self loadAd];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    if(self.selectedLevel==kLEVEL0)
    [tracker set:kGAIScreenName value:@"Level 0"];
    else if(self.selectedLevel==kLEVEL1)
    [tracker set:kGAIScreenName value:@"Level 1"];
    else if(self.selectedLevel==kLEVEL2)
    [tracker set:kGAIScreenName value:@"Level 2"];
    else if(self.selectedLevel==kLEVEL3)
    [tracker set:kGAIScreenName value:@"Level 3"];

    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}
-(void)createView
{
    isStarted = NO;
    
    UIButton *btnBack=[[UIButton alloc] initWithFrame:CGRectMake(20, StatusBarHeight, 25, 25)];
    [btnBack addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
    btnBack.backgroundColor=[UIColor clearColor];
    btnBack.alpha=0.5;
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];//home.png
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateSelected];//home.png
    [btnBack setContentMode:UIViewContentModeCenter];
    btnBack.backgroundColor=[UIColor clearColor];
    [self.view addSubview: btnBack];
    
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0,50,self.view.frame.size.width,self.view.frame.size.height-100)];
    contentView.backgroundColor = colorScreenBackground;
    [self.view addSubview:contentView];
    
    UITapGestureRecognizer *labelTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(performViewClick)];
    [contentView addGestureRecognizer:labelTapGesture];
    
    lblShowTimer=[[UILabel alloc] initWithFrame:CGRectMake(0,0,view_frame.size.width,view_frame.size.height/4)];
    lblShowTimer.font=[UIFont fontWithName:@"Helvetica-Oblique" size:80];
    lblShowTimer.textColor=colorTimerFont;//[UIColor cyanColor];
    lblShowTimer.textAlignment=NSTextAlignmentCenter;
    lblShowTimer.backgroundColor=[UIColor clearColor];
    [contentView addSubview:lblShowTimer];
    
    lblNotification=[[UILabel alloc] initWithFrame:CGRectMake(0,lblShowTimer.frame.origin.y+lblShowTimer.frame.size.height,view_frame.size.width,20)];
    
    lblNotification.font=[UIFont fontWithName:@"AppleColorEmoji" size:14];
    lblNotification.textColor=[UIColor lightGrayColor];
    lblNotification.backgroundColor=[UIColor clearColor];
    lblNotification.textAlignment=NSTextAlignmentCenter;
    [contentView addSubview:lblNotification];
    
    [self showNotificationLevel];

    
    lblShowBest=[[UILabel alloc] initWithFrame:CGRectMake(0,lblNotification.frame.origin.y+lblNotification.frame.size.height,view_frame.size.width/2,(view_frame.size.height/3)/2)];
    lblShowBest.font=[UIFont fontWithName:@"Helvetica-Oblique" size:20];
    lblShowBest.textColor=colorScoreFont;
    lblShowBest.textAlignment=NSTextAlignmentCenter;
    lblShowBest.numberOfLines=0;
    lblShowBest.backgroundColor=[UIColor clearColor];
    [contentView addSubview:lblShowBest];
    
    lblShowTotal=[[UILabel alloc] initWithFrame:CGRectMake(view_frame.size.width/2,lblShowBest.frame.origin.y,view_frame.size.width/2,(view_frame.size.height/3)/2)];
    lblShowTotal.font=[UIFont fontWithName:@"Helvetica-Oblique" size:20];
    lblShowTotal.textColor=colorScoreFont;
    lblShowTotal.textAlignment=NSTextAlignmentCenter;
    lblShowTotal.numberOfLines=0;
    lblShowTotal.backgroundColor=[UIColor clearColor];
    [contentView addSubview:lblShowTotal];
    
    lblShowNumberOfFiveStar=[[UILabel alloc] initWithFrame:CGRectMake(0,lblShowBest.frame.origin.y+lblShowBest.frame.size.height,view_frame.size.width,(view_frame.size.height/3)/2)];
    lblShowNumberOfFiveStar.font=[UIFont fontWithName:@"Helvetica-Oblique" size:20];
    lblShowNumberOfFiveStar.textColor=colorScoreFont;
    lblShowNumberOfFiveStar.textAlignment=NSTextAlignmentCenter;
    lblShowNumberOfFiveStar.numberOfLines=0;
    lblShowNumberOfFiveStar.backgroundColor=[UIColor clearColor];
    [contentView addSubview:lblShowNumberOfFiveStar];
    
    
    timer = [[TimerLabel alloc] initWithLabel:lblShowTimer andTimerType:TimerLabelTypeStopWatch];
    timer.timeFormat = @"ss : SS";
    
    lblTargetKey=[[UILabel alloc] initWithFrame:CGRectMake(0,2*(view_frame.size.height/3)-30,view_frame.size.width,30)];
    
    lblTargetKey.font=[UIFont fontWithName:@"AppleColorEmoji" size:20];
    lblTargetKey.textColor=[UIColor lightGrayColor];
    lblTargetKey.textAlignment=NSTextAlignmentLeft;
    lblTargetKey.text=@"TAP TO PLAY";
    lblTargetKey.backgroundColor=[UIColor clearColor];
    lblTargetKey.textAlignment=NSTextAlignmentCenter;
    [contentView addSubview:lblTargetKey];
    
    lblShowTarget=[[UILabel alloc] initWithFrame:CGRectMake(0,lblTargetKey.frame.origin.y+lblTargetKey.frame.size.height,view_frame.size.width,60)];
    lblShowTarget.font=[UIFont fontWithName:@"Helvetica-Oblique" size:50];//DBLCDTempBlack
    lblShowTarget.textColor=UIColorFromRGB(0xFFC040);//[UIColor cyanColor];
    lblShowTarget.backgroundColor=[UIColor clearColor];
    lblShowTarget.textAlignment=NSTextAlignmentCenter;
    lblShowTarget.text=@"";
    [contentView addSubview:lblShowTarget];
    
    viewResult = [[UIView alloc]init];//WithFrame:CGRectMake(VIEW_FRAME.origin.x,VIEW_FRAME.origin.y , VIEW_FRAME.size.width, VIEW_FRAME.size.height)];
    viewResult.backgroundColor = colorResultWindow;
    [contentView addSubview:viewResult];
    
    [viewResult setHidden:TRUE];
    
    [self loadScoresFromDB];
}
-(void)showNotificationLevel
{
    if(self.selectedLevel==kLEVEL0)
        lblNotification.text=@"LEVEL 0";
    else if(self.selectedLevel==kLEVEL1)
        lblNotification.text=@"LEVEL 1";
    else if(self.selectedLevel==kLEVEL2)
        lblNotification.text=@"LEVEL 2";
    else if(self.selectedLevel==kLEVEL3)
        lblNotification.text=@"LEVEL 3";
}
-(void)loadScoresFromDB
{
    lblShowBest.text=[NSString stringWithFormat:@"Best\n%@",[self getDBValueForThisKey:BEST]];
    lblShowTotal.text=[NSString stringWithFormat:@"Total\n%@",[self getDBValueForThisKey:TOTAL]];
    lblShowNumberOfFiveStar.text=[NSString stringWithFormat:@"5 stars\n%@",[self getDBValueForThisKey:FIVESTAR]];
}
-(void)performViewClick
{
    isStarted = !isStarted;
    
    if(isStarted)
        [self proceedWithStart];
    else
        [self proceedWithStop];
}
-(void)proceedWithStart
{
    if(viewResult.frame.size.width>0)
    {
        lblTargetKey.text=@"TAP TO PLAY";
        isStarted = !isStarted;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        viewResult.layer.opacity=0.2;
        [viewResult.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        
        viewResult.frame = CGRectMake(view_frame.size.width/2, view_frame.size.height/2, 0, 0);
        
        [UIView commitAnimations];
    }
    else
    {
        lblTargetKey.text=@"STOP ME HERE";
        [self stopSnowFall];
        
        lblShowTarget.text = [NSString stringWithFormat:@"%02d : %02d", [self getRandomNumberBetween:1 to:7],[self getRandomNumberBetween:0 to:99]];
        [self doLevelTricks];
        [timer reset];
        [timer start];
    }
}
-(void)proceedWithStop
{
    lblTargetKey.text=@"TAP TO PLAY";
    [timer pause];
    
    [self showResultWindow];
    [self stopLevelTricks];
}
-(void)doLevelTricks
{
    if(self.selectedLevel==kLEVEL1)
    {
        timerLevelBased = [NSTimer scheduledTimerWithTimeInterval:0.8
                                                           target: self
                                                         selector:@selector(onTickForLevel1)
                                                         userInfo: nil repeats:YES];
    }
    else if(self.selectedLevel==kLEVEL2)
    {
        timerLevelBased = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target: self
                                                         selector:@selector(onTickForLevel2)
                                                         userInfo: nil repeats:YES];
    }
    else if(self.selectedLevel==kLEVEL3)
    {
        timerLevelBased = [NSTimer scheduledTimerWithTimeInterval:0.8
                                                           target: self
                                                         selector:@selector(onTickForLevel3)
                                                         userInfo: nil repeats:YES];
    }
}
-(void)onTickForLevel1
{
        lblShowTimer.frame = CGRectMake(0,[self getRandomNumberBetween:0 to:view_frame.size.height-(view_frame.size.height/4)],view_frame.size.width,view_frame.size.height/4);
}
-(void)onTickForLevel2
{
    lblShowTimer.alpha = 1;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ lblShowTimer.alpha = 0;}
                     completion:nil];

}
-(void)onTickForLevel3
{
    lblShowTimer.frame = CGRectMake(0,[self getRandomNumberBetween:0 to:view_frame.size.height-(view_frame.size.height/4)],view_frame.size.width,view_frame.size.height/4);
    
    lblShowTimer.alpha = 1;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ lblShowTimer.alpha = 0;}
                     completion:nil];
}
-(void)stopLevelTricks
{
    [timerLevelBased invalidate];
    timerLevelBased =nil;
    
    if(self.selectedLevel==kLEVEL1)
        lblShowTimer.frame = CGRectMake(0,0,view_frame.size.width,view_frame.size.height/3);
    else if(self.selectedLevel==kLEVEL2)
        lblShowTimer.alpha = 1;
    else if(self.selectedLevel==kLEVEL3)
    {
        lblShowTimer.alpha = 1;
        lblShowTimer.frame = CGRectMake(0,0,view_frame.size.width,view_frame.size.height/3);
    }
}
-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);//[NSString stringWithFormat:@"%d",(int)from + arc4random() % (to-from+1)];
}
- (void)showResultWindow
{
    lblTargetKey.text=@"TAP TO GO BACK";
    
    viewResult.frame = CGRectMake(view_frame.origin.x,view_frame.origin.y+(view_frame.size.height/3) , view_frame.size.width, view_frame.size.height/3);
    viewResult.layer.opacity=1;
    [viewResult setHidden:FALSE];
    
    UIImageView *img_Complete=[[UIImageView alloc] initWithFrame:CGRectMake((viewResult.frame.size.width/2)-40,(viewResult.frame.size.height/2)-80,80,80)];
    img_Complete.layer.shadowColor = [UIColor blackColor].CGColor;
    img_Complete.layer.shadowOffset = CGSizeMake(0, 10);
    img_Complete.layer.shadowOpacity = 0.8;
    img_Complete.layer.shadowRadius = 8.0;
    img_Complete.clipsToBounds = NO;
    [viewResult addSubview:img_Complete];
    
    
    RatingControl *controlRating = [[RatingControl alloc]initWithLocation:CGPointMake((viewResult.frame.size.width/2)-72, (viewResult.frame.size.height/2)+20) emptyColor:[UIColor whiteColor] solidColor:[UIColor yellowColor] andMaxRating:5];
    controlRating.backgroundColor = [UIColor clearColor];
    controlRating.starFontSize=25;
    controlRating.starSpacing=2;
    controlRating.starWidthAndHeight=28;
    [viewResult addSubview:controlRating];
    
    CGRect f = viewResult.frame;
    
    CGRect f1 = CGRectMake(CGRectGetMinX(f), 0, f.size.width/2, f.size.height);//f.origin.y
    CGRect f2 = CGRectMake(CGRectGetMidX(f), 0, f.size.width/2, f.size.height);//f.origin.y
    
    UIView *viewLeft = [[UIView alloc] initWithFrame:f1];
    viewLeft.backgroundColor = colorScreenBackground;
    [viewResult addSubview:viewLeft];
    
    UILabel *lblShowDifference=[[UILabel alloc] initWithFrame:CGRectMake(85,20,viewLeft.frame.size.width-90,viewLeft.frame.size.height-40)];
    lblShowDifference.font=[UIFont fontWithName:@"Helvetica" size:20];
    lblShowDifference.textColor=[UIColor whiteColor];
    lblShowDifference.numberOfLines=0;
    lblShowDifference.textAlignment=NSTextAlignmentLeft;
    lblShowDifference.backgroundColor=colorResultWindow;
    lblShowDifference.textAlignment=NSTextAlignmentCenter;
    [viewLeft addSubview:lblShowDifference];
    
    UIView *viewRight = [[UIView alloc] initWithFrame:f2];
    viewRight.backgroundColor = colorScreenBackground;
    [viewResult addSubview:viewRight];
    
    UILabel *lblShowStarComment=[[UILabel alloc] initWithFrame:CGRectMake(5,20,viewRight.frame.size.width-90,viewRight.frame.size.height-40)];
    lblShowStarComment.font=[UIFont fontWithName:@"Helvetica" size:20];
    lblShowStarComment.textColor=[UIColor whiteColor];
    lblShowStarComment.numberOfLines=0;
    lblShowStarComment.textAlignment=NSTextAlignmentLeft;
    lblShowStarComment.backgroundColor=colorResultWindow;
    lblShowStarComment.textAlignment=NSTextAlignmentCenter;
    [viewRight addSubview:lblShowStarComment];
    
    f1.origin.x -= 80;
    f2.origin.x += 80;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    viewLeft.frame = f1;
    viewRight.frame = f2;
    
    [UIView commitAnimations];
    
    [self setCalculatedResultDifferenceInOutput];
    
    int curScore = 0;
    
    if(output==ZERO_ACHEIVEMENT)
        lblShowDifference.text =@"You have missed lot.";//\nPlease try again";
    else if(output==0)
        lblShowDifference.text =@"You deserved it.";
    else
        lblShowDifference.text =[NSString stringWithFormat:@"Missed\n%ld",output];
    
    
    if(output==0)
    {
        [controlRating setRating:5];
        img_Complete.image=[UIImage imageNamed:@"5"];
        [self startSnowFall:400];
        curScore = 50;
        
        [self setDBValueForThisKey:FIVESTAR andValue:[NSString stringWithFormat:@"%d",[[self getDBValueForThisKey:FIVESTAR] integerValue] + 1]];
    }
    else if(output<10)
    {
        [controlRating setRating:4];
        img_Complete.image=[UIImage imageNamed:@"4"];
        [self startSnowFall:50];
        curScore = 10;
        
    }
    else if(output<20)
    {
        [controlRating setRating:3];
        img_Complete.image=[UIImage imageNamed:@"3"];
        [self startSnowFall:30];
        curScore = 5;
    }
    else if(output<30)
    {
        [controlRating setRating:2];
        img_Complete.image=[UIImage imageNamed:@"2"];
        [self startSnowFall:10];
        
        curScore = 3;
    }
    else if(output<40)
    {
        [controlRating setRating:1];
        img_Complete.image=[UIImage imageNamed:@"1"];
        [self startSnowFall:5];
        curScore = 2;
    }
    else
    {
        [self startSnowFall:0];
        [controlRating setRating:0];
        img_Complete.image=[UIImage imageNamed:@"0"];
        curScore = -5;
    }
    
    lblShowStarComment.text =[NSString stringWithFormat:@"Points\n%d",curScore>0?curScore:-5];
    
    
    //Save Score in DB
    if([[self getDBValueForThisKey:BEST] integerValue] < curScore)
        [self setDBValueForThisKey:BEST andValue:[NSString stringWithFormat:@"%d",curScore]];
    
    
    //Show notification when unlocking next level
    //if----- checking for this moment he crossed the level
    //else if--- checking for the first time he got 5 star
    if(self.selectedLevel==kLEVEL0)
    {
        if([[self getDBValueForThisKey:TOTAL] integerValue] < [Level0_MaxPoints integerValue] && [[self getDBValueForThisKey:TOTAL] integerValue] + curScore >= [Level0_MaxPoints integerValue])
        {
            lblNotification.text=@"Level 1 Successfully Unlocked";
        }
        else if(output==0 && [[self getDBValueForThisKey:FIVESTAR] integerValue] ==1)
        {
            lblNotification.text=@"Level 1 Successfully Unlocked";
        }
        else
            [self showNotificationLevel];
        
    }
    else if(self.selectedLevel==kLEVEL1)
    {
        if([[self getDBValueForThisKey:TOTAL] integerValue] < [Level1_MaxPoints integerValue] && [[self getDBValueForThisKey:TOTAL] integerValue] + curScore >= [Level1_MaxPoints integerValue])
        {
            lblNotification.text=@"Level 2 Successfully Unlocked";
        }
        else if(output==0 && [[self getDBValueForThisKey:FIVESTAR] integerValue] ==1)
        {
            lblNotification.text=@"Level 2 Successfully Unlocked";
        }
        else
            [self showNotificationLevel];
    }
    else if(self.selectedLevel==kLEVEL2)
    {
        if([[self getDBValueForThisKey:TOTAL] integerValue] < [Level2_MaxPoints integerValue] && [[self getDBValueForThisKey:TOTAL] integerValue] + curScore >= [Level2_MaxPoints integerValue])
        {
            lblNotification.text=@"Level 3 Successfully Unlocked";
        }
        else if(output==0 && [[self getDBValueForThisKey:FIVESTAR] integerValue] ==1)
        {
            lblNotification.text=@"Level 3 Successfully Unlocked";
        }
        else
            [self showNotificationLevel];
    }
    
    //Update DB with total level
    if([[self getDBValueForThisKey:TOTAL] integerValue] + curScore < 0)
    {
        [self setDBValueForThisKey:TOTAL andValue:@"0"];
    }
    else
    {
        [self setDBValueForThisKey:TOTAL andValue:[NSString stringWithFormat:@"%d",[[self getDBValueForThisKey:TOTAL] integerValue] + curScore]];
    }

    [self loadScoresFromDB];
    
}
-(void)clickShare
{
    
}
-(void)startSnowFall:(int)flakesCount
{
    snowView = [[SnowFallView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width*2, self.view.frame.size.height*2)];
    [contentView addSubview:snowView];
    
    snowView.flakesCount = flakesCount;
    [snowView letItSnow];
}
-(void)stopSnowFall
{
    if([snowView isDescendantOfView:contentView])
    {
        [snowView removeFromSuperview];
    }
}
-(void)setCalculatedResultDifferenceInOutput
{
    long secTarget=[[[lblShowTarget.text componentsSeparatedByString:@" : "] objectAtIndex:0] integerValue];
    long millisecTarget = [[[lblShowTarget.text componentsSeparatedByString:@" : "] objectAtIndex:1] integerValue];
    
    long secStopped=[[[lblShowTimer.text componentsSeparatedByString:@" : "] objectAtIndex:0] integerValue];
    long millisecStopped = [[[lblShowTimer.text componentsSeparatedByString:@" : "] objectAtIndex:1] integerValue];
    
    if(secTarget==secStopped)
    {
        output = millisecTarget>millisecStopped?millisecTarget-millisecStopped:millisecStopped-millisecTarget;
    }
    else if(secTarget < secStopped)
    {
        if((secStopped-secTarget)==1)
        {
            output = (100-millisecTarget)+millisecStopped;
        }
        else
            output=ZERO_ACHEIVEMENT;
    }
    else if(secTarget > secStopped)
    {
        if((secTarget-secStopped)==1)
        {
            output = (100-millisecStopped)+millisecTarget;
        }
        else
            output=ZERO_ACHEIVEMENT;
    }
    else
        output=ZERO_ACHEIVEMENT;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString*)getDBValueForThisKey:(NSString*)strKey
{
    NSString *strKeyWithLevel = [self appendLevelWithKey:strKey];
    if([[NSUserDefaults standardUserDefaults] stringForKey:strKeyWithLevel] !=nil && ![[[NSUserDefaults standardUserDefaults] stringForKey:strKeyWithLevel] isEqualToString:@"null"])
    {
        return [[NSUserDefaults standardUserDefaults] stringForKey:strKeyWithLevel];
    }
    else
        return @"0";
}
-(void)setDBValueForThisKey:(NSString*)strKey andValue:(NSString*)strVal
{
    [[NSUserDefaults standardUserDefaults] setObject:strVal forKey:[self appendLevelWithKey:strKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(NSString*)appendLevelWithKey:(NSString*)strKey
{
    if(self.selectedLevel==kLEVEL0)
        return [NSString stringWithFormat:@"0_%@",strKey];
    else if(self.selectedLevel==kLEVEL1)
        return [NSString stringWithFormat:@"1_%@",strKey];
    else if(self.selectedLevel==kLEVEL2)
        return [NSString stringWithFormat:@"2_%@",strKey];
    else
        return strKey;
}
-(void)loadAd
{
    // Replace this ad unit ID with your own ad unit ID.
    bannerAdView = [[GADBannerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-50, 320, 50)];
    bannerAdView.adUnitID = @"ca-app-pub-3505054954021719/8886985189";
    bannerAdView.rootViewController = self;
    [self.view addSubview:bannerAdView];
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
    request.testDevices = @[@"98259d179403fa469c6fc74151a174d193a68"];
    [bannerAdView loadRequest:request];
}
-(void)btnBackClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
