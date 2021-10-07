//
//  ViewController.m
//  UITableViewDemo
//
//  Created by 莫玄 on 2021/9/18.
//

#import "ViewController.h"
#import "prefetch.h"
#import "myTableViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic)UITableView *myTableView;
@property (strong,nonatomic)UILabel *headerLabelView;
@property (strong,nonatomic)UIButton *footerButton;
@property (strong,nonatomic)NSArray *propertyArray;
@property(assign)BOOL isInsert;//确认是否是新增按钮被点击；
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isInsert=NO;
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
   // self.myTableView.rowHeight=80;  动态计算行高度时不需要设置这一属性
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
    else if(section==1)
        return [_propertyArray[1] count];
    else
        return [_propertyArray[2] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section!=2)
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"reusabelcell"];
        if(!cell)
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reusablecell"];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
        cell.accessoryType=UITableViewCellAccessoryNone;
        return cell;
    }
    else
    {
        [tableView registerClass:[myTableViewCell class] forCellReuseIdentifier:@"myTableViewCell"];
        myTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"myTableViewCell"];
        if(!cell)
            cell=[[myTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myTableViewCell"];
        
        //调用cell的weibo setter方法，进行内容布局;
        cell.weibo=_propertyArray[2][indexPath.row];
        return cell;
    }
}

//@option
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _propertyArray.count;
}

//edit
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1 || indexPath.section==2)
        return NO;
    return YES;
}
//添加或者删除一个row；
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && editingStyle==UITableViewCellEditingStyleInsert)
    {
        NSMutableDictionary *dicToAdd=[[NSMutableDictionary alloc]init];
        [dicToAdd setObject:@"lock" forKey:@"image"];
        [dicToAdd setObject:@"newItem" forKey:@"title"];
        [dicToAdd setObject:@"item" forKey:@"subtitle"];
        NSMutableArray *arr=_propertyArray[0];
        [arr insertObject:dicToAdd atIndex:indexPath.row];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
      //  NSIndexSet *set=[[NSIndexSet alloc]initWithIndex:0];
       // [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if(indexPath.section==0 && editingStyle==UITableViewCellEditingStyleDelete)
    {
        
        NSMutableArray *arr=_propertyArray[0];
        [arr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
       // NSLog(@"please donot delete a primary cell");
    }
    /*
     暂时不更新到外部源文件中；
     NSString *path=[[NSBundle mainBundle]pathForResource:@"source" ofType:@".plist"];
     [_propertyArray writeToFile:path atomically:YES];
     */
}

//move
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section!=0)
        return NO;
    return YES;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if(sourceIndexPath.section==0)
    {
        NSMutableArray *arr=_propertyArray[0];
        if(destinationIndexPath.section==0)
        {
            [arr exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
        }
    }
}
/*
//sectionindex索引
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
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section=indexPath.section;
    NSUInteger index=indexPath.row;
    NSArray *sectionArray=_propertyArray[section];
    NSDictionary *dicforcell=sectionArray[index];
    if(section!=2)
    {
        UIListContentConfiguration *content=cell.defaultContentConfiguration;
        content.image=[UIImage imageNamed:[dicforcell objectForKey:@"image"]];
        content.imageProperties.maximumSize=CGSizeMake(45, 45);
        content.text=[dicforcell objectForKey:@"subtitle"];
        content.secondaryText=[dicforcell objectForKey:@"title"];
        content.textProperties.color=[UIColor whiteColor];
        content.textProperties.font=[UIFont systemFontOfSize:15];
        content.secondaryTextProperties.color=[UIColor whiteColor];
        content.secondaryTextProperties.font=[UIFont systemFontOfSize:20];
        cell.contentConfiguration=content;
    }
}

 //行选中时
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cellselected=[tableView cellForRowAtIndexPath:indexPath];
    //重复点击时，取消选中
    if(cellselected.isSelected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return nil;         //返回nil可以阻止系统调用didSelectRowAtIndexPath:方法；
    }
    return indexPath;
}
//编辑模式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isInsert)
        return UITableViewCellEditingStyleInsert;
    else
        return UITableViewCellEditingStyleDelete;
}
/*
//自定义添加左滑按钮，向tableview中添加一个row；
-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIContextualAction *addAction=[UIContextualAction
                                            contextualActionWithStyle:UIContextualActionStyleNormal
                                            title:@"add"
                                            handler:^(UIContextualAction * _Nonnull action,
                                                      __kindof UIView * _Nonnull sourceView,
                                                      void (^ _Nonnull completionHandler)(BOOL))
        {
            NSMutableDictionary *dicToAdd=[[NSMutableDictionary alloc]init];
            [dicToAdd setObject:@"lock" forKey:@"image"];
            [dicToAdd setObject:@"newItem" forKey:@"title"];
            [dicToAdd setObject:@"item" forKey:@"subtitle"];
            NSMutableArray *arr=self->_propertyArray[0];
            [arr addObject:dicToAdd];
            [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            NSIndexSet *set=[[NSIndexSet alloc]initWithIndex:0];
            [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
            completionHandler(true);
        }];
    addAction.image=[UIImage imageNamed:@"lock"];
    return [UISwipeActionsConfiguration configurationWithActions:@[addAction]];
}
 */
-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if(proposedDestinationIndexPath.section==0)
        return proposedDestinationIndexPath;
    else
        //不可以返回nil值，会引起崩溃；
        return sourceIndexPath;    //此语句使得cell的move操作只能在特定的section中进行；
}
//高亮显示；
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
        return 80;
    else
        return 0;
}
//行高度的预估计算
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellMargin=4.0;
    CGFloat imageMaxHeight=40.0;
    UIFont *bodyfont=[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    CGFloat bodyfontheight=bodyfont.lineHeight+bodyfont.leading;
    CGFloat cellfontheight=bodyfontheight *2 +cellMargin*2;
    CGFloat cellestimateheight=(imageMaxHeight>cellfontheight)? imageMaxHeight :cellfontheight;
    return cellestimateheight;
}
//行高度的计算
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section!=2)
        return 80;
    else
    {
        NSNumber *cellHeight=[_propertyArray[2][indexPath.row] objectForKey:@"cellHeight"];
        return cellHeight.floatValue;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        header.backgroundColor=[UIColor clearColor];
        [header addSubview:_headerLabelView];
        UIButton *add=[UIButton buttonWithType:UIButtonTypeContactAdd];
        CGRect addRect=CGRectMake(10, 10, 30, 30);
        add.frame=addRect;
        [add addTarget:self action:@selector(seteditingmode) forControlEvents:UIControlEventTouchUpInside];
        UIButton *delete=[UIButton buttonWithType:UIButtonTypeClose];
        CGRect deleteRect=CGRectMake([UIScreen mainScreen].bounds.size.width-30, 10, 30, 30);
        delete.frame=deleteRect;
        [delete addTarget:self action:@selector(setEditingDeleteMode) forControlEvents:UIControlEventTouchUpInside];
        
        [header addSubview:add];
        [header addSubview:delete];
        return header;
    }
    else
        return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==2)
        return 120;
    else if(section==0)
        return 35;
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section==2)
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
    else if(section==0)
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
    return nil;
}
#pragma  mark---其他方法；
//编辑模式的响应方法；
-(void)seteditingmode
{
    if(!self.isInsert)
    {
        self.isInsert=YES;
        [UIView animateWithDuration:0.2 animations:^{
                self.myTableView.editing=YES;
        }];
    }
    else
    {
        self.isInsert=NO;
        [UIView animateWithDuration:0.2 animations:^{
                self.myTableView.editing=NO;
        }];
    }
}
-(void)setEditingDeleteMode
{
    if(self.myTableView.isEditing)
        [UIView animateWithDuration:0.2 animations:^{
                self.myTableView.editing=NO;
        }];
    else
        [UIView animateWithDuration:0.2 animations:^{
                self.myTableView.editing=YES;
        }];
}
@end
