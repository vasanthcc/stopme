//
//  LevelSelectionViewController.m
//  StopIt
//
//  Created by Vasanth Ravichandran on 14/11/15.
//  Copyright (c) 2015 msf. All rights reserved.
//

#import "LevelSelectionViewController.h"
#import "StopMeViewController.h"
#import <MessageUI/MessageUI.h>
#import "AppMacros.h"
@interface LevelSelectionViewController()
{
    NSMutableArray *arrayItems;
    UITableView *tableLevels;
    int rowHeight;
}
@end
@implementation LevelSelectionViewController
-(void)viewDidLoad
{
    [self createView];
}
-(void)viewWillAppear:(BOOL)animated
{
    if(tableLevels !=nil && arrayItems !=nil && arrayItems.count>0)
    [tableLevels reloadData];
}
-(void)createView
{
    self.view.backgroundColor = [UIColor blackColor];
    
    UIButton *btnMail=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnMail.frame=CGRectMake(20,20,(self.view.frame.size.width/2)-40,30);
    [btnMail setTitle:@"FEEDBACKS" forState:UIControlStateNormal];
    [btnMail setTitle:@"FEEDBACKS" forState:UIControlStateSelected];
    [btnMail addTarget:self action:@selector(sendMail) forControlEvents:UIControlEventTouchUpInside];
    [btnMail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnMail.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnMail.layer.borderWidth=1;
    btnMail.layer.borderColor=[UIColor orangeColor].CGColor;
    [self.view addSubview:btnMail];
    
    UIButton *btnShare=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnShare.frame=CGRectMake(self.view.frame.size.width/2,20,(self.view.frame.size.width/2)-40,30);
    [btnShare setTitle:@"SHARE" forState:UIControlStateNormal];
    [btnShare setTitle:@"SHARE" forState:UIControlStateSelected];
    [btnShare addTarget:self action:@selector(shareApp) forControlEvents:UIControlEventTouchUpInside];
    [btnShare setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnShare.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnShare.layer.borderWidth=1;
    btnShare.layer.borderColor=[UIColor orangeColor].CGColor;
    [self.view addSubview:btnShare];
    
    
    tableLevels=[[UITableView alloc] initWithFrame:CGRectMake(0,50,view_frame.size.width,view_frame.size.height-50)];
    tableLevels.backgroundColor=[UIColor clearColor];
    tableLevels.dataSource=self;
    tableLevels.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableLevels.delegate=self;
    [self.view addSubview:tableLevels];
    
    arrayItems = [[NSMutableArray alloc]init];
    
    [arrayItems addObject:@"Free level for practicing|Level 0"];
    [arrayItems addObject:[NSString stringWithFormat:@"collect one 5 start or score %@ in level 0 to unlock this level|Level 1",Level0_MaxPoints]];
    [arrayItems addObject:[NSString stringWithFormat:@"collect one 5 start or score %@ in level 1 to unlock this level|Level 2",Level1_MaxPoints]];
    [arrayItems addObject:[NSString stringWithFormat:@"collect one 5 start or score %@ in level 2 to unlock this level|Level 3",Level2_MaxPoints]];
    [arrayItems addObject:[NSString stringWithFormat:@"collect one 5 start or score %@ in level 3 to unlock next level(future updates)|More . . .",Level3_MaxPoints]];
    
    [tableLevels reloadData];
    
    rowHeight = 150;
    
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"identifier"];
        cell.backgroundView=nil;
        cell.selectedBackgroundView=nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        self.view.clipsToBounds = YES;
        
        UILabel *lblLevel=[[UILabel alloc] initWithFrame:CGRectMake(20,10,tableLevels.frame.size.width-40, (rowHeight/2)-20)];
        lblLevel.font = [UIFont fontWithName:@"Noteworthy-Bold" size:16];//Chalkduster//Noteworthy-Bold//Zapfino
        lblLevel.backgroundColor = [UIColor orangeColor];
        lblLevel.textColor = [UIColor whiteColor];
        lblLevel.textAlignment = NSTextAlignmentCenter;
        lblLevel.tag=2;
        [cell addSubview:lblLevel];
        
        UILabel *lblLevelDescription=[[UILabel alloc] initWithFrame:CGRectMake(20,rowHeight/2,cell.frame.size.width-40, rowHeight/2)];
        lblLevelDescription.font = [UIFont fontWithName:@"Chalkduster" size:14];//Chalkduster//Noteworthy-Bold//Zapfino
        lblLevelDescription.backgroundColor = [UIColor clearColor];
        lblLevelDescription.textColor = [UIColor whiteColor];
        lblLevelDescription.numberOfLines=0;
        lblLevelDescription.textAlignment = NSTextAlignmentCenter;
        lblLevelDescription.tag=3;
        [cell addSubview:lblLevelDescription];
        
        UIView *viewSeperator = [[UIView alloc]initWithFrame:CGRectMake(20,rowHeight-1, tableLevels.frame.size.width-40, 1)];
        viewSeperator.backgroundColor =[UIColor greenColor];
        [cell addSubview:viewSeperator];
        
        UIView *viewXStart = [[UIView alloc]initWithFrame:CGRectMake(20,lblLevel.frame.origin.y+lblLevel.frame.size.height, 1, lblLevelDescription.frame.size.height+10)];
        viewXStart.backgroundColor =[UIColor greenColor];
        [cell addSubview:viewXStart];
        
        UIView *viewXEnd = [[UIView alloc]initWithFrame:CGRectMake(viewSeperator.frame.origin.x +viewSeperator.frame.size.width-1,viewXStart.frame.origin.y, 1, viewXStart.frame.size.height)];
        viewXEnd.backgroundColor =[UIColor greenColor];
        [cell addSubview:viewXEnd];
        
        UIView *viewTextLayer = [[UIView alloc]initWithFrame:CGRectMake(0,0, tableLevels.frame.size.width, rowHeight)];
        viewTextLayer.tag=1;
        viewTextLayer.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.6f];
        [cell addSubview:viewTextLayer];
        
        UIImageView *imgLock = [[UIImageView alloc] initWithFrame:CGRectMake((viewTextLayer.frame.size.width/2)-20, (viewTextLayer.frame.size.height/2)-20, 40, 40)];
        imgLock.image = [UIImage imageNamed:@"icn_lock.png"];
        [viewTextLayer addSubview:imgLock];
        
    }
    
    if([self canPlay:indexPath.row])
        ((UIView *)[cell viewWithTag:1]).hidden = YES;
    else
        ((UIView *)[cell viewWithTag:1]).hidden = NO;
    
    
    ((UILabel *)[cell viewWithTag:2]).text =[[[arrayItems objectAtIndex:indexPath.row] componentsSeparatedByString:@"|"] objectAtIndex:1];
    ((UILabel *)[cell viewWithTag:3]).text =[[[arrayItems objectAtIndex:indexPath.row] componentsSeparatedByString:@"|"] objectAtIndex:0];
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self canPlay:indexPath.row])
    {
        StopMeViewController *gameController = [[StopMeViewController alloc]init];
        if(indexPath.row==0)
            gameController.selectedLevel = kLEVEL0;
        else if(indexPath.row==1)
            gameController.selectedLevel = kLEVEL1;
        else if(indexPath.row==2)
            gameController.selectedLevel = kLEVEL2;
        else if(indexPath.row==3)
            gameController.selectedLevel = kLEVEL3;
        
        [self.navigationController pushViewController:gameController animated:YES];
    }
    else
    {
        UIAlertView *alertMessage = [[UIAlertView alloc]initWithTitle:@"Stop ME" message:[[[arrayItems objectAtIndex:indexPath.row] componentsSeparatedByString:@"|"] objectAtIndex:0] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertMessage show];
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowHeight+1;
}
-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  arrayItems.count;
}
-(BOOL)canPlay:(int)rowNumber
{
    //return YES;
    if(rowNumber==0)
    {
        return YES;
    }
    else if(rowNumber == arrayItems.count-1)
    {
       return NO;
    }
    else
    {
     int totalPoints = 300;
        
        if(rowNumber==0)
            totalPoints = [Level0_MaxPoints integerValue];
        else if(rowNumber==1)
            totalPoints = [Level1_MaxPoints integerValue];
        else if(rowNumber==2)
            totalPoints = [Level2_MaxPoints integerValue];
        else if(rowNumber==3)
            totalPoints = [Level3_MaxPoints integerValue];
        
        
        if([[self getDBValueForThisKey:[NSString stringWithFormat:@"%d_%@",rowNumber-1,TOTAL]] integerValue]>=totalPoints || [[self getDBValueForThisKey:[NSString stringWithFormat:@"%d_%@",rowNumber-1,FIVESTAR]] integerValue] >= 1)
        {
            return YES;
        }
        else
            return NO;
    }

}
-(NSString*)getDBValueForThisKey:(NSString*)strKey
{
    if([[NSUserDefaults standardUserDefaults] stringForKey:strKey] !=nil && ![[[NSUserDefaults standardUserDefaults] stringForKey:strKey] isEqualToString:@"null"])
    {
        return [[NSUserDefaults standardUserDefaults] stringForKey:strKey];
    }
    else
        return @"0";
}
-(void)shareApp
{
    NSArray * shareItems = @[@"Stop Me App for iPhone",[UIImage imageNamed:@"5.png"]];
    
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    
    
    [self presentViewController:avc animated:YES completion:nil];
    
}
-(void)sendMail
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Suggestion/Feedback from Sleeping App USER"];
        [mail setMessageBody:@"" isHTML:NO];
        [mail setToRecipients:@[@"coolcap.cc@gmail.com"]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"Oops! This device cannot send email");
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email succesfully.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Oops! Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"Oops! An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
