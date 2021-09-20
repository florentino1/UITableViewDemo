//
//  ViewController.m
//  UITableViewDemo
//
//  Created by 莫玄 on 2021/9/18.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic)UITableView *myTableView;
@property (strong,nonatomic)UILabel *headerLabelView;
@property (strong,nonatomic)UIButton *footerButton;
@property (strong,nonatomic)NSArray *propertyArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _headerLabelView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    _headerLabelView.textColor=[UIColor whiteColor];
    _headerLabelView.adjustsFontSizeToFitWidth=YES;
    _headerLabelView.backgroundColor=[UIColor clearColor];
    _headerLabelView.textAlignment=NSTextAlignmentCenter;
    _headerLabelView.text=@"Register";
    
    _footerButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [_footerButton setTitle:@"Register" forState:UIControlStateNormal];
    _footerButton.backgroundColor=[UIColor colorWithRed:79/255.f green:172/255.f blue:116/255.f alpha:1];
    CGRect frame=CGRectMake([UIScreen mainScreen].bounds.size.width/2-150.0,28, 300, 44);
    _footerButton.frame=frame;
    _footerButton.titleLabel.font=[UIFont systemFontOfSize:22];
    _footerButton.layer.cornerRadius=10.0;
    _footerButton.layer.masksToBounds=YES;
    
    NSString *path=[[NSBundle mainBundle]pathForResource:@"source" ofType:@".plist"];
    _propertyArray=[NSArray arrayWithContentsOfFile:path];
    [self createTableView];
}
-(void)createTableView
{
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    UIImageView *bg=[[UIImageView alloc]initWithFrame:self.myTableView.frame];
    bg.image=[UIImage imageNamed:@"bgpic"];
    [bg setContentMode:UIViewContentModeScaleToFill];
    _myTableView.backgroundView=bg;
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    self.myTableView.rowHeight=80;
    [self.view addSubview:_myTableView];
}
#pragma mark---datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return 5;
    else
        return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"reusabelcell"];
    if(!cell)
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reusablecell"];
    NSUInteger section=indexPath.section;
    NSUInteger index=indexPath.row;
    NSArray *sectionArray=_propertyArray[section];
    NSDictionary *dicforcell=sectionArray[index];
    UIListContentConfiguration *content=cell.defaultContentConfiguration;
    content.image=[UIImage imageNamed:[dicforcell objectForKey:@"image"]];
    content.text=[dicforcell objectForKey:@"subtitle"];
    content.secondaryText=[dicforcell objectForKey:@"title"];
    content.textProperties.color=[UIColor whiteColor];
    content.textProperties.font=[UIFont systemFontOfSize:15];
    content.secondaryTextProperties.color=[UIColor whiteColor];
    content.secondaryTextProperties.font=[UIFont systemFontOfSize:20];
    cell.contentConfiguration=content;
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    
}
*/
#pragma mark ---delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
        return 80;
    else
        return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    header.backgroundColor=[UIColor clearColor];
    [header addSubview:_headerLabelView];
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==1)
        return 120;
    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section==1)
    {
        UIView *footer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        footer.backgroundColor=[UIColor clearColor];
        footer.tintColor=[UIColor whiteColor];
        [footer addSubview:_footerButton];
        UILabel *label=[[UILabel alloc]init];
        NSString *string=@"Already have an account? login here";
        label.textColor=[UIColor whiteColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.translatesAutoresizingMaskIntoConstraints=NO;
        NSMutableAttributedString *astring=[[NSMutableAttributedString alloc]initWithString:string];
        [astring addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:79/255.f green:172/255.f blue:116/255.f alpha:1] range:NSMakeRange(string.length-10,10)];
        label.attributedText=astring;
        [footer addSubview:label];
        
        [label.topAnchor constraintEqualToAnchor:_footerButton.bottomAnchor constant:10].active=true;
        [label.leadingAnchor constraintEqualToAnchor:footer.leadingAnchor constant:0].active=true;
        [label.trailingAnchor constraintEqualToAnchor:footer.trailingAnchor].active=true;
        [label.bottomAnchor constraintEqualToAnchor:footer.bottomAnchor constant:-5].active=true;
        return footer;
    }
    else
    {
        UIView *footer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        footer.backgroundColor=[UIColor clearColor];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width, 24)];
        label.textColor=[UIColor whiteColor];
        label.textAlignment=NSTextAlignmentNatural;
        label.numberOfLines=2;
        label.font=[UIFont systemFontOfSize:12];
        label.text=@"Password should contain at least one uppercharacter               Password length should be minimum 8 characters";
        label.lineBreakMode=NSLineBreakByWordWrapping;
        [label sizeToFit];
        [footer addSubview:label];
        return  footer;
    }
}

@end
