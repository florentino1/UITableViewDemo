//
//  myTableViewCell.m
//  UITableViewDemo
//
//  Created by 莫玄 on 2021/10/6.
//

#import "myTableViewCell.h"

@interface myTableViewCell()
@property(strong,nonatomic)UIImageView *avatar;   //用户头像
@property(strong,nonatomic)UIImageView *mbType;   //会员类型；
@property(strong,nonatomic)UILabel *userName;     //用户名
@property(strong,nonatomic)UILabel *createAt;     //该用户信息发布的时间；
@property(strong,nonatomic)UILabel *source;       //发布的设备来源；
@property(strong,nonatomic)UILabel *text;         //发布的用户正文；

@end


@implementation myTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initSubviews];
    }
    return self;
}
-(void)initSubviews
{
    self.backgroundColor=[UIColor clearColor];
    self.selectionStyle=UITableViewCellSelectionStyleDefault;
    //用户头像
    self.avatar=[[UIImageView alloc]init];
    [self.contentView addSubview:self.avatar];
    
    //会员类型
    self.mbType=[[UIImageView alloc]init];
    [self.contentView addSubview:self.mbType];
    
    //用户名
    self.userName=[[UILabel alloc]init];
    _userName.textAlignment=NSTextAlignmentLeft;
    _userName.font=[UIFont systemFontOfSize:14];
    _userName.textColor=[UIColor whiteColor];
    [self.contentView addSubview:_userName];
    
    //用户发布的时间;
    self.createAt=[[UILabel alloc]init];
    _createAt.textAlignment=NSTextAlignmentLeft;
    _createAt.font=[UIFont systemFontOfSize:12];
    _createAt.textColor=[UIColor whiteColor];
    [self.contentView addSubview:_createAt];
    
    //发布的设备来源
    self.source=[[UILabel alloc]init];
    _source.font=[UIFont systemFontOfSize:12];
    _source.textColor=[UIColor whiteColor];
    _source.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_source];
    
    //内容;
    self.text=[[UILabel alloc]init];
    _text.numberOfLines=0;
    _text.font=[UIFont systemFontOfSize:14];
    _text.textAlignment=NSTextAlignmentLeft;
    _text.textColor=[UIColor whiteColor];
    [self.contentView addSubview:_text];
}
-(void)setWeibo:(NSDictionary *)weibo
{
        _weibo=weibo;
        //设置头像大小和位置
        CGFloat avatarX=10,avatarY=10;
        CGRect avatarRect=CGRectMake(avatarX, avatarY, 40, 40);
        _avatar.image=[UIImage imageNamed:[self.weibo objectForKey:@"profileImageUrl"]];
        _avatar.frame=avatarRect;
        
        
        //设置用户名框大小和位置
        CGFloat userNameX= CGRectGetMaxX(_avatar.frame)+10 ;
        CGFloat userNameY=avatarY;
                       
        //根据文本内容取得文本占用空间大小
        CGSize userNameSize=[_weibo[@"userName"] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
        CGRect userNameRect=CGRectMake(userNameX, userNameY, userNameSize.width,userNameSize.height);
        _userName.text=_weibo[@"userName"];
        _userName.frame=userNameRect;
        
        
        //设置会员图标大小和位置
        CGFloat mbTypeX=CGRectGetMaxX(_userName.frame)+10;
        CGFloat mbTypeY=avatarY;
        CGRect mbTypeRect=CGRectMake(mbTypeX, mbTypeY, 13, 13);
        _mbType.image=[UIImage imageNamed:_weibo[@"mbtype"]];
        _mbType.frame=mbTypeRect;
        
        
        //设置发布日期大小和位置
        CGSize createAtSize=[_weibo[@"createAt"] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        CGFloat createAtX=userNameX;
        CGFloat createAtY=CGRectGetMaxY(_avatar.frame)-createAtSize.height;
        CGRect createAtRect=CGRectMake(createAtX, createAtY, createAtSize.width, createAtSize.height);
        _createAt.text=_weibo[@"createAt"];
        _createAt.frame=createAtRect;
        
        
        //设置设备信息大小和位置
        CGSize sourceSize=[_weibo[@"source"] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        CGFloat sourceX=CGRectGetMaxX(_createAt.frame)+10;
        CGFloat sourceY=createAtY;
        CGRect sourceRect=CGRectMake(sourceX, sourceY, sourceSize.width,sourceSize.height);
        _source.text=_weibo[@"source"];
        _source.frame=sourceRect;
        
        
        //设置微博内容大小和位置
        CGFloat textX=avatarX;
        CGFloat textY=CGRectGetMaxY(_avatar.frame)+10;
        CGFloat textWidth=self.frame.size.width-10*2;
        CGSize textSize=[_weibo[@"text"] boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
        CGRect textRect=CGRectMake(textX, textY, textSize.width, textSize.height);
        _text.text=_weibo[@"text"];
        _text.frame=textRect;
        
        NSNumber *cellHeight=[NSNumber numberWithFloat:CGRectGetMaxY(_text.frame)+10];
        [weibo setValue:cellHeight forKey:@"cellHeight"];
}

@end
