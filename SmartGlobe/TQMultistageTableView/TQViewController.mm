//
//  TQViewController.m
//  TQMultistageTableViewDemo
//
//  Created by fuqiang on 13-9-3.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import "TQViewController.hpp"

@interface TQViewController ()

@end

@implementation TQViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.mTableView = [[TQMultistageTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
//    self.mTableView.delegate = self;
//    self.mTableView.dataSource = self;
//    [self.view addSubview:self.mTableView];
}

#pragma mark - TQTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(TQMultistageTableView *)tableView
{
    return 3;
}

- (NSInteger)mTableView:(TQMultistageTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        //_checkBoxes的长度
        return  [_checkBoxes count];
    }
    if (section==1) {
        //获取 _labelsPOIs 的长度
        return [_labelsPOIs count];
    }
    //设置
    if (section==2)
    {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)mTableView:(TQMultistageTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TQMultistageTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    int  size =    [indexPath length];
    if (size>1 && indexPath.section==0)
    {
        SSCheckBoxView* view = (SSCheckBoxView*)[_checkBoxes objectAtIndex: [indexPath indexAtPosition:1]];
        cell.accessoryView = view;
    }
    if (indexPath.section==1) {
        SSCheckBoxView* view = (SSCheckBoxView*)[_labelsPOIs objectAtIndex: [indexPath indexAtPosition:1]];
        cell.accessoryView = view;
    }
    if (indexPath.section==2)
    {
        if (indexPath.row==0)
        {
            if (_setupView==nil)
            {
                _setupView =  [[SetUpView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
                _setupView->_mainViewController = _mainViewController;
                [_setupView addFinishedButton];
            }
            cell.accessoryView =_setupView;
        }
        if (indexPath.row==1)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
            [view setBackgroundColor:[UIColor clearColor]];
            //标题
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor blackColor];
            [label setBackgroundColor:[UIColor clearColor]];
            label.frame = CGRectMake(20, 7, 200, 30);
            label.text = @"位置信息（度分秒）：";
            // 默认是 79 27
            UISwitch*  switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(220, 7, 79, 30)];
            switchButton.on =YES;
            [switchButton addTarget:_mainViewController action:@selector(switchPrintDegree:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:switchButton];
            [view addSubview:label];
            cell.accessoryView = view;
        }
        if ([cell.gestureRecognizers count])
        {
            [cell removeGestureRecognizer:(UIGestureRecognizer *) [cell.gestureRecognizers objectAtIndex:0]];
        }
        cell.userInteractionEnabled = YES;
    }
    return cell;
}

- (UIView *)mTableView:(TQMultistageTableView *)tableView openCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 100)];
//    view.backgroundColor = [UIColor colorWithRed:187/255.0 green:206/255.0 blue:190/255.0 alpha:1];
       return nil;
  }


#pragma mark - Table view delegate

- (CGFloat)mTableView:(TQMultistageTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)mTableView:(TQMultistageTableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)mTableView:(TQMultistageTableView *)tableView heightForOpenCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}
//返回顶header视图
- (UIView *)mTableView:(TQMultistageTableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * control = [[UIView alloc] init];
    control.backgroundColor = [UIColor whiteColor];
    //黑色底线
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 48, tableView.frame.size.width, 2)];
    view.backgroundColor = [UIColor blackColor];
    //标题
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    label.frame = CGRectMake(20, 0, 200, 40);
    
   switch (section)
    {
        case 0:
             label.text = @"> 图层";
            break;
            case 1:
               label.text = @"> POI标注";
            break;
            case 2:
             label.text =@"> 设置";
            break;
            default:
                label.text=@"...";
            break;
    }
    [control addSubview:label];
    [control addSubview:view];

    return control;
}

- (void)mTableView:(TQMultistageTableView *)tableView didSelectHeaderAtSection:(NSInteger)section
{
    NSLog(@"headerClick%d",section);
}

//celll点击
- (void)mTableView:(TQMultistageTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellClick%@",indexPath);
}

//header展开
- (void)mTableView:(TQMultistageTableView *)tableView willOpenHeaderAtSection:(NSInteger)section
{
    NSLog(@"headerOpen%d",section);
}

//header关闭
- (void)mTableView:(TQMultistageTableView *)tableView willCloseHeaderAtSection:(NSInteger)section
{
    NSLog(@"headerClose%d",section);
}

- (void)mTableView:(TQMultistageTableView *)tableView willOpenCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"OpenCell%@",indexPath);
}

- (void)mTableView:(TQMultistageTableView *)tableView willCloseCellAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"CloseCell%@",indexPath);
}

@end
