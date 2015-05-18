//
//  ViewController.m
//  StopIt
//
//  Created by Vasanth Ravichandran on 22/04/15.
//  Copyright (c) 2015 msf. All rights reserved.
//

#import "ViewController.h"
#import "TimerLabel.h"
#import "SnowFallView.h"
#import "RatingControl.h"

#define ZERO_ACHEIVEMENT 1000
#define VIEW_FRAME self.view.frame

@interface ViewController ()
{
    UILabel *lblShowTarget,*lblShowTimer,*lblShowBest,*lblShowTotal,*lblShowNumberOfFiveStar;
    UILabel *lblTargetKey;
    TimerLabel *timer;
    int currentTime;
    long output;
    UIView *viewResult;
    BOOL isStarted;
    SnowFallView *snowView;
    UIView *contentView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createView];
    [self.view setBackgroundColor:[UIColor blackColor]];
}
-(void)createView
{

    isStarted = NO;
    
    UITapGestureRecognizer *labelTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(performViewClick)];
    [self.view addGestureRecognizer:labelTapGesture];
    
    
    UIButton *btnShare=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnShare.frame=CGRectMake(self.view.frame.size.width-120,20,100,30);
    [btnShare setTitle:@"SHARE" forState:UIControlStateNormal];
    [btnShare setTitle:@"SHARE" forState:UIControlStateSelected];
    [btnShare addTarget:self action:@selector(clickShare) forControlEvents:UIControlEventTouchUpInside];
    [btnShare setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnShare.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnShare.layer.borderWidth=1;
    btnShare.layer.borderColor=[UIColor whiteColor].CGColor;
    //[self.view addSubview:btnShare];
    
   // [self.view bringSubviewToFront:btnShare];

    
    lblShowTimer=[[UILabel alloc] initWithFrame:CGRectMake(0,0,VIEW_FRAME.size.width,VIEW_FRAME.size.height/3)];
    lblShowTimer.font=[UIFont fontWithName:@"Helvetica-Oblique" size:80];
    lblShowTimer.textColor=[UIColor cyanColor];
    lblShowTimer.textAlignment=NSTextAlignmentCenter;
    lblShowTimer.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lblShowTimer];
    
    lblShowBest=[[UILabel alloc] initWithFrame:CGRectMake(0,lblShowTimer.frame.origin.y+lblShowTimer.frame.size.height,VIEW_FRAME.size.width/2,(VIEW_FRAME.size.height/3)/2)];
    lblShowBest.font=[UIFont fontWithName:@"Helvetica-Oblique" size:24];
    lblShowBest.textColor=[UIColor purpleColor];
    lblShowBest.textAlignment=NSTextAlignmentCenter;
    lblShowBest.numberOfLines=0;
    lblShowBest.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lblShowBest];
    
    lblShowTotal=[[UILabel alloc] initWithFrame:CGRectMake(VIEW_FRAME.size.width/2,lblShowBest.frame.origin.y,VIEW_FRAME.size.width/2,(VIEW_FRAME.size.height/3)/2)];
    lblShowTotal.font=[UIFont fontWithName:@"Helvetica-Oblique" size:24];
    lblShowTotal.textColor=[UIColor purpleColor];
    lblShowTotal.textAlignment=NSTextAlignmentCenter;
        lblShowTotal.numberOfLines=0;
    lblShowTotal.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lblShowTotal];
    
    lblShowNumberOfFiveStar=[[UILabel alloc] initWithFrame:CGRectMake(0,lblShowBest.frame.origin.y+lblShowBest.frame.size.height,VIEW_FRAME.size.width,(VIEW_FRAME.size.height/3)/2)];
    lblShowNumberOfFiveStar.font=[UIFont fontWithName:@"Helvetica-Oblique" size:24];
    lblShowNumberOfFiveStar.textColor=[UIColor purpleColor];
    lblShowNumberOfFiveStar.textAlignment=NSTextAlignmentCenter;
        lblShowNumberOfFiveStar.numberOfLines=0;
    lblShowNumberOfFiveStar.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lblShowNumberOfFiveStar];
    
    
    timer = [[TimerLabel alloc] initWithLabel:lblShowTimer andTimerType:TimerLabelTypeStopWatch];
    timer.timeFormat = @"ss : SS";
    
    
    lblTargetKey=[[UILabel alloc] initWithFrame:CGRectMake(0,2*(VIEW_FRAME.size.height/3),VIEW_FRAME.size.width,30)];
    
    lblTargetKey.font=[UIFont fontWithName:@"AppleColorEmoji" size:20];
    lblTargetKey.textColor=[UIColor lightGrayColor];
    lblTargetKey.textAlignment=NSTextAlignmentLeft;
    lblTargetKey.text=@"TAP TO PLAY";
    lblTargetKey.backgroundColor=[UIColor clearColor];
    lblTargetKey.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lblTargetKey];
    
    lblShowTarget=[[UILabel alloc] initWithFrame:CGRectMake(0,lblTargetKey.frame.origin.y+20,VIEW_FRAME.size.width,80)];
    lblShowTarget.font=[UIFont fontWithName:@"Helvetica-Oblique" size:50];//DBLCDTempBlack
    lblShowTarget.textColor=[UIColor cyanColor];
    lblShowTarget.backgroundColor=[UIColor clearColor];
    lblShowTarget.textAlignment=NSTextAlignmentCenter;
    lblShowTarget.text=@"";
    [self.view addSubview:lblShowTarget];
    
    viewResult = [[UIView alloc]init];//WithFrame:CGRectMake(VIEW_FRAME.origin.x,VIEW_FRAME.origin.y , VIEW_FRAME.size.width, VIEW_FRAME.size.height)];
    viewResult.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:viewResult];
    
    [viewResult setHidden:TRUE];

    [self loadScoresFromDB];
}
-(void)loadScoresFromDB
{
    lblShowBest.text=[NSString stringWithFormat:@"Best\n%@",[self getDBValueForThisKey:@"BEST"]];
        lblShowTotal.text=[NSString stringWithFormat:@"Total\n%@",[self getDBValueForThisKey:@"TOTAL"]];
        lblShowNumberOfFiveStar.text=[NSString stringWithFormat:@"5 stars\n%@",[self getDBValueForThisKey:@"FIVESTAR"]];
}
-(void)performViewClick
{
    isStarted = !isStarted;

    if(isStarted)
        [self proceedWithStart];
    else
        [self proceedWithStop];
}
-(void)timerLabel:(TimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime
{

}
-(void)proceedWithStart
{
    if(viewResult.frame.size.width>0)
    {
        isStarted = !isStarted;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        
        [viewResult.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        viewResult.frame = CGRectMake(VIEW_FRAME.size.width/2, VIEW_FRAME.size.height/2, 0, 0);
        
        [UIView commitAnimations];
    }
    else
    {
    lblTargetKey.text=@"STOP ME HERE";
    [self stopSnowFall];
    
    lblShowTarget.text = [NSString stringWithFormat:@"%02d : %02d", [self getRandomNumberBetween:0 to:10],[self getRandomNumberBetween:0 to:100]];
    
    [timer reset];
    [timer start];
    }
}
-(void)proceedWithStop
{
    lblTargetKey.text=@"TAP TO PLAY";
    [timer pause];
    
    [self showResultWindow];
}
-(void)proceedWithPlayAgain
{
    isStarted = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];

   [viewResult.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    viewResult.frame = CGRectMake(VIEW_FRAME.size.width/2, VIEW_FRAME.size.height/2, 0, 0);
    
    [UIView commitAnimations];
    
    [self proceedWithStart];
    //[viewResult setHidden:TRUE];
}
-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);//[NSString stringWithFormat:@"%d",(int)from + arc4random() % (to-from+1)];
}
- (void)showResultWindow
{
    viewResult.frame = CGRectMake(VIEW_FRAME.origin.x,VIEW_FRAME.origin.y+(VIEW_FRAME.size.height/3) , VIEW_FRAME.size.width, VIEW_FRAME.size.height/3);
    [viewResult setHidden:FALSE];
    
   UIImageView *img_Complete=[[UIImageView alloc] initWithFrame:CGRectMake((viewResult.frame.size.width/2)-40,(viewResult.frame.size.height/2)-80,80,80)];
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
    viewLeft.backgroundColor = [UIColor blackColor];
    [viewResult addSubview:viewLeft];
    
    UILabel *lblShowDifference=[[UILabel alloc] initWithFrame:CGRectMake(85,20,viewLeft.frame.size.width-90,viewLeft.frame.size.height-40)];
    lblShowDifference.font=[UIFont fontWithName:@"Helvetica" size:15];
    lblShowDifference.textColor=[UIColor whiteColor];
    lblShowDifference.numberOfLines=0;
    lblShowDifference.textAlignment=NSTextAlignmentLeft;
    lblShowDifference.backgroundColor=[UIColor purpleColor];
    lblShowDifference.textAlignment=NSTextAlignmentCenter;
    [viewLeft addSubview:lblShowDifference];
    
    UIView *viewRight = [[UIView alloc] initWithFrame:f2];
    viewRight.backgroundColor = [UIColor blackColor];
    [viewResult addSubview:viewRight];
    
    UILabel *lblShowStarComment=[[UILabel alloc] initWithFrame:CGRectMake(5,20,viewRight.frame.size.width-90,viewRight.frame.size.height-40)];
    lblShowStarComment.font=[UIFont fontWithName:@"Helvetica" size:15];
    lblShowStarComment.textColor=[UIColor whiteColor];
    lblShowStarComment.numberOfLines=0;
    lblShowStarComment.textAlignment=NSTextAlignmentLeft;
    lblShowStarComment.backgroundColor=[UIColor purpleColor];
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
           lblShowDifference.text =@"You have missed a lot.\nPlease try again";
       else if(output==0)
           lblShowDifference.text =@"You deserved this 5 star.\nThat's awesome Keep going.";
           else
   lblShowDifference.text =[NSString stringWithFormat:@"Missed : \n%ld milli seconds",output];
    
    
    if(output==0)
    {
        [controlRating setRating:5];
        img_Complete.image=[UIImage imageNamed:@"5"];
            [self startSnowFall:400];
        curScore = 50;
        
        [self setDBValueForThisKey:@"FIVESTAR" andValue:[NSString stringWithFormat:@"%ld",[[self getDBValueForThisKey:@"FIVESTAR"] integerValue] + 1]];
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
    
    lblShowStarComment.text =[NSString stringWithFormat:@"Score\n%d",curScore>0?curScore:-5];

    
    //Save Score in DB
    if([[self getDBValueForThisKey:@"BEST"] integerValue] < curScore)
    [self setDBValueForThisKey:@"BEST" andValue:[NSString stringWithFormat:@"%d",curScore]];
    
    if([[self getDBValueForThisKey:@"TOTAL"] integerValue] + curScore < 0)
    {
        [self setDBValueForThisKey:@"TOTAL" andValue:@"0"];
    }
    else
    {
    [self setDBValueForThisKey:@"TOTAL" andValue:[NSString stringWithFormat:@"%ld",[[self getDBValueForThisKey:@"TOTAL"] integerValue] + curScore]];
    }
    
    [self loadScoresFromDB];
    
}
-(void)clickShare
{
    
}
-(void)startSnowFall:(int)flakesCount
{
    snowView = [[SnowFallView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width*2, self.view.frame.size.height*2)];
    [self.view addSubview:snowView];
    
    snowView.flakesCount = flakesCount;
    [snowView letItSnow];
}
-(void)stopSnowFall
{
    if([snowView isDescendantOfView:self.view])
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

            NSLog(@"Stopped label label %@",[[lblShowTarget.text componentsSeparatedByString:@" : "] objectAtIndex:0]);
            NSLog(@"Stopped label label %@",[[lblShowTarget.text componentsSeparatedByString:@" : "] objectAtIndex:0]);
    
    
    if(secTarget==secStopped)
    {
        output = millisecTarget>millisecStopped?millisecTarget-millisecStopped:millisecStopped-millisecTarget;
    }
    else if(secTarget < secStopped)
    {
        if((secStopped-secTarget)==1)
        {
            //SecStopped --- 03:14
            //SecTarget ---- 02:56
            output = (100-millisecTarget)+millisecStopped;
        }
        else
            output=ZERO_ACHEIVEMENT;
    }
    else if(secTarget > secStopped)
    {
        if((secTarget-secStopped)==1)
        {
            //SecStopped --- 04:54
            //SecTarget ---- 05:18
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

if([[NSUserDefaults standardUserDefaults] stringForKey:strKey] !=nil && ![[[NSUserDefaults standardUserDefaults] stringForKey:strKey] isEqualToString:@"null"])
{
    NSLog(@"%@ ::: %@",strKey,[[NSUserDefaults standardUserDefaults] stringForKey:strKey]);
        return [[NSUserDefaults standardUserDefaults] stringForKey:strKey];
}
    else
        return @"0";
}
-(void)setDBValueForThisKey:(NSString*)strKey andValue:(NSString*)strVal
{
    [[NSUserDefaults standardUserDefaults] setObject:strVal forKey:strKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
@end
