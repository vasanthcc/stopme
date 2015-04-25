//
//  ViewController.m
//  StopIt
//
//  Created by Vasanth Ravichandran on 22/04/15.
//  Copyright (c) 2015 msf. All rights reserved.
//

#import "ViewController.h"
#define ZERO_ACHEIVEMENT 1000
@interface ViewController ()
{
    UILabel *lblShowTarget,*lblShowTimer;
    UIButton *btnStart,*btnStop,*btnTryAgain;
    NSTimer *theTimer;
int currentTime;
    long output;
    UIView *viewResult;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createView];

}
-(void)createView
{
  lblShowTarget=[[UILabel alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-100,self.view.frame.size.width,80)];
    
    lblShowTarget.font=[UIFont fontWithName:@"Helvetica" size:50];
    lblShowTarget.textColor=[UIColor darkGrayColor];
    lblShowTarget.textAlignment=NSTextAlignmentLeft;
    lblShowTarget.backgroundColor=[UIColor whiteColor];
    lblShowTarget.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lblShowTarget];
    
    lblShowTimer=[[UILabel alloc] initWithFrame:CGRectMake(0,50,self.view.frame.size.width,100)];
    
    lblShowTimer.font=[UIFont fontWithName:@"Helvetica" size:80];
    lblShowTimer.textColor=[UIColor darkGrayColor];
    lblShowTimer.textAlignment=NSTextAlignmentLeft;
    lblShowTimer.backgroundColor=[UIColor whiteColor];
    lblShowTimer.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lblShowTimer];
    
    
    btnStart=[UIButton buttonWithType:UIButtonTypeCustom];
    btnStart.frame=CGRectMake(10,self.view.frame.size.height-100,160,80);
    [btnStart setTitle:@"START" forState:UIControlStateNormal];
    [btnStart setTitle:@"START" forState:UIControlStateSelected];
    [btnStart addTarget:self action:@selector(proceedWithStart) forControlEvents:UIControlEventTouchUpInside];
    [btnStart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnStart.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnStart.backgroundColor=[UIColor orangeColor];
    btnStart.titleLabel.backgroundColor=[UIColor clearColor];
    btnStart.imageView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:btnStart];
    
    
    btnStop=[UIButton buttonWithType:UIButtonTypeCustom ];
    btnStop.frame=CGRectMake(self.view.frame.size.width-btnStart.frame.size.width-10,btnStart.frame.origin.y,btnStart.frame.size.width,80);
    [btnStop setTitle:@"STOP" forState:UIControlStateNormal];
    [btnStop setTitle:@"STOP" forState:UIControlStateSelected];
    [btnStop addTarget:self action:@selector(proceedWithStop) forControlEvents:UIControlEventTouchUpInside];
    [btnStop setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnStop.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnStop.backgroundColor=[UIColor orangeColor];
    btnStop.titleLabel.backgroundColor=[UIColor clearColor];
    btnStop.imageView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:btnStop];
    
    viewResult = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y , self.view.frame.size.width, self.view.frame.size.height)];
    viewResult.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:viewResult];
    
    [viewResult setHidden:TRUE];
}

-(void)proceedWithStart
{
    currentTime = 0;
    lblShowTarget.text=@"";
    
    if ([theTimer isValid])
    {
        [theTimer invalidate];
    }
    
    theTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
}
-(void)proceedWithStop
{
    if ([theTimer isValid])
    {
        [theTimer invalidate];
    }
    [self showResultWindow];
}
-(void)proceedWithPlayAgain
{
    [viewResult setHidden:TRUE];
    
    [self proceedWithStart];
}
- (void)timerTick:(NSTimer *)timer {
    currentTime += 1 ;
    [self populateLabelwithTime:currentTime];
}
- (void)populateLabelwithTime:(int)milliseconds
{
    
    int seconds = milliseconds/100;
    int minutes = seconds / 60;
    int hours = minutes / 60;
    
    seconds -= minutes * 60;
    minutes -= hours * 60;
    
//    NSString * result = [NSString stringWithFormat:@"%@%02d:%02d:%02d:%02d", (milliseconds<0?@"-":@""), hours, minutes, seconds,milliseconds%1000];
    
        NSString * result = [NSString stringWithFormat:@"%02d : %02d", seconds,milliseconds%100];
    lblShowTimer.text = result;
    
    if([lblShowTarget.text isEqualToString:@""])
    {
        lblShowTarget.text = [NSString stringWithFormat:@"%02d : %02d", [self getRandomNumberBetween:0 to:5],[self getRandomNumberBetween:0 to:100]];
    }
    
}
-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);//[NSString stringWithFormat:@"%d",(int)from + arc4random() % (to-from+1)];
}
- (void)showResultWindow
{
    [viewResult setHidden:FALSE];
    
    CGRect f = self.view.frame;
    
    CGRect f1 = CGRectMake(CGRectGetMinX(f), f.origin.y, f.size.width/2, f.size.height);
    CGRect f2 = CGRectMake(CGRectGetMidX(f), f.origin.y, f.size.width/2, f.size.height);
    
    UIView *viewLeft = [[UIView alloc] initWithFrame:f1];
    viewLeft.backgroundColor = [UIColor blackColor];
    [viewResult addSubview:viewLeft];
    
    UILabel *lblShowDifference=[[UILabel alloc] initWithFrame:CGRectMake(0,(viewLeft.frame.size.height/2)-40,viewLeft.frame.size.width,80)];
    lblShowDifference.font=[UIFont fontWithName:@"Helvetica" size:20];
    lblShowDifference.textColor=[UIColor whiteColor];
    lblShowDifference.numberOfLines=0;
    lblShowDifference.textAlignment=NSTextAlignmentLeft;
    lblShowDifference.backgroundColor=[UIColor clearColor];
    lblShowDifference.textAlignment=NSTextAlignmentCenter;
    [viewLeft addSubview:lblShowDifference];
    
//    btnSubmit=[UIButton buttonWithType:UIButtonTypeCustom];
//    btnSubmit.frame=CGRectMake((f2.size.width/2)-80,viewLeft.frame.size.height-100,160,80);
//    [btnSubmit setTitle:@"Submit to Store" forState:UIControlStateNormal];
//    [btnSubmit setTitle:@"Submit to Store" forState:UIControlStateSelected];
//    [btnSubmit addTarget:self action:@selector(proceedWithSubmit) forControlEvents:UIControlEventTouchUpInside];
//    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btnSubmit.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    btnSubmit.backgroundColor=[UIColor orangeColor];
//    btnSubmit.titleLabel.backgroundColor=[UIColor clearColor];
//    btnSubmit.imageView.backgroundColor=[UIColor clearColor];
//    
//    [viewLeft addSubview:btnSubmit];
    
    UIView *viewRight = [[UIView alloc] initWithFrame:f2];
    viewRight.backgroundColor = [UIColor blackColor];
    [viewResult addSubview:viewRight];
    
    UILabel *lblShowStar=[[UILabel alloc] initWithFrame:CGRectMake(0,(viewRight.frame.size.height/2)-40,viewRight.frame.size.width,80)];
    lblShowStar.font=[UIFont fontWithName:@"Helvetica" size:40];
    lblShowStar.textColor=[UIColor whiteColor];
        lblShowStar.numberOfLines=0;
    lblShowStar.textAlignment=NSTextAlignmentLeft;
    lblShowStar.backgroundColor=[UIColor clearColor];
    lblShowStar.textAlignment=NSTextAlignmentCenter;
    [viewRight addSubview:lblShowStar];
    
    
    btnTryAgain=[UIButton buttonWithType:UIButtonTypeCustom];
    btnTryAgain.frame=CGRectMake((f2.size.width/2)-80,viewRight.frame.size.height-100,160,80);
    [btnTryAgain setTitle:@"Play Again" forState:UIControlStateNormal];
    [btnTryAgain setTitle:@"Play Again" forState:UIControlStateSelected];
    [btnTryAgain addTarget:self action:@selector(proceedWithPlayAgain) forControlEvents:UIControlEventTouchUpInside];
    [btnTryAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnTryAgain.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnTryAgain.backgroundColor=[UIColor orangeColor];
    btnTryAgain.titleLabel.backgroundColor=[UIColor clearColor];
    btnTryAgain.imageView.backgroundColor=[UIColor clearColor];
    
    [viewRight addSubview:btnTryAgain];
    
    f1.origin.x -= 10;
    f2.origin.x += 10;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    viewLeft.frame = f1;
    viewRight.frame = f2;
    
    [UIView commitAnimations];
    
    [self setCalculatedResultDifferenceInOutput];
    
    if(output==ZERO_ACHEIVEMENT)
           lblShowDifference.text =@"You have missed a lot.Please try again";
       else if(output==0)
           lblShowDifference.text =@"You got it without any delay.That's awesome";
           else
   lblShowDifference.text =[NSString stringWithFormat:@"You have missed %ld milli seconds",output];
    
    if(output==0)
    lblShowStar.text = @"5 Star";
    else if(output<2)
        lblShowStar.text = @"4 Star";
    else if(output<4)
        lblShowStar.text = @"3 Star";
    else if(output<6)
        lblShowStar.text = @"2 Star";
    else if(output<8)
        lblShowStar.text = @"1 Star";
    else
        lblShowStar.text=@"No Star";
    
}
-(void)setCalculatedResultDifferenceInOutput
{
    long secTarget=[[[lblShowTarget.text componentsSeparatedByString:@" : "] objectAtIndex:0] integerValue];
    long millisecTarget = [[[lblShowTarget.text componentsSeparatedByString:@" : "] objectAtIndex:1] integerValue];
    
    long secStopped=[[[lblShowTimer.text componentsSeparatedByString:@" : "] objectAtIndex:0] integerValue];
    long millisecStopped = [[[lblShowTimer.text componentsSeparatedByString:@" : "] objectAtIndex:1] integerValue];
    
    NSLog(@"Target label %@",lblShowTarget.text);
        NSLog(@"Stopped label %@",lblShowTimer.text);

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
            output = 333;
        }
        else
            output=ZERO_ACHEIVEMENT;
    }
    else if(secTarget > secStopped)
    {
        if((secTarget-secStopped)==1)
        {
                        output = 444;
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

@end
