//
//  ViewController.m
//  UITableViewDemo
//
//  Created by 莫玄 on 2021/9/18.
//

#import "ViewController.h"
#import "prefetch.h"

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
    _propertyArray=[NSMutableArray arrayWithContentsOfFile:path];
    [self createTableView];
}
-(void)createTableView
{
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    UIImageView *bg=[[UIImageView alloc]initWithFrame:self.myTableView.frame];
    bg.image=[UIImage imageNamed:@"bgpic"];
    [bg setContentMode:UIViewContentModeScaleToFill];
    _myTableView.backgroundView=bg;
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    self.myTableView.rowHeight=80;
    [self.view addSubview:_myTableView];
    
 //   prefetch *predata=[[prefetch alloc]init];
 //   self.myTableView.prefetchDataSource=predata;
}
#pragma mark---datasource
//@required
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return [_propertyArray[0] count];
    else
        return [_propertyArray[1] count];
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
    cell.selectionStyle=UITableViewCellSelectionStyleDefault;
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    return cell;
}

//@option
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _propertyArray.count;
}

//edit
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1)
        return NO;
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && editingStyle==UITableViewCellEditingStyleInsert)
    {
        NSMutableDictionary *dicToAdd=[[NSMutableDictionary alloc]init];
        [dicToAdd setObject:@"lock" forKey:@"image"];
        [dicToAdd setObject:@"newItem" forKey:@"title"];
        [dicToAdd setObject:@"item" forKey:@"subtitle"];
        NSMutableArray *arr=_propertyArray[0];
        [arr addObject:dicToAdd];
    }
    else if(indexPath.section==0 && editingStyle==UITableViewCellEditingStyleDelete)
    {/*
        NSMutableArray *arr=_propertyArray[0];
        [arr removeObjectAtIndex:indexPath.row];
      */
        NSLog(@"please donot delete a primary cell");
    }
    NSString *path=[[NSBundle mainBundle]pathForResource:@"source" ofType:@".plist"];
    [_propertyArray writeToFile:path atomically:YES];
}

//move
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1)
        return NO;
    return YES;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if(sourceIndexPath.section==0 && destinationIndexPath.section==0)
    {
        NSMutableArray *arr=_propertyArray[0];
        [arr exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    }
}
/*
//sectionindex
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *arrayForIndex=[[NSMutableArray alloc]init];
    for(int i=0;i<_propertyArray.count;i++)
    {
        NSArray *arrInPro=_propertyArray[i];
        for(int j=0;j<arrInPro.count;j++)
        {
            NSString *index=[arrInPro[j] objectForKey:@"index"];
            [arrayForIndex addObject:index];
        }
    }
    return arrayForIndex;
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
    if(section==0)
    {
        UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        header.backgroundColor=[UIColor clearColor];
        [header addSubview:_headerLabelView];
        return header;
    }
    else
        return nil;
    
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
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(tableView.separatorInset.left, 0, [UIScreen mainScreen].bounds.size.width, 24)];
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
