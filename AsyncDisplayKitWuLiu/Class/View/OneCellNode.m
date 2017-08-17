//
//  OneCellNode.m
//  AsyncDisplayKitWuLiu
//
//  Created by ZZCN77 on 2017/8/15.
//  Copyright © 2017年 ZZCN77. All rights reserved.
//

#import "OneCellNode.h"

@implementation OneCellNode
- (instancetype)initWithCommentItem:(OrderModel *)item indexPath:(NSIndexPath *)indexPath{
    if (self = [super init]) {
        _allHeight = 0;
        _tableHeight = 0;
        self.index = indexPath;
        self.orderNodel = item;
        [self addDateNode];
        [self addTitleNode];
        [self addDescNode];
        [self addGoodNode];
    }
    return self;

}
- (void)addDateNode{
    self.dateNode = [[DateView alloc] initWithCommentItem:self.orderNodel.time date:self.orderNodel.date dateNum:self.orderNodel.dayCount];
    self.dateNode.backgroundColor = [UIColor whiteColor];
    [self addSubnode:self.dateNode];
    


}
- (void)addTitleNode{
    self.titleNode = [[ASTextNode alloc] init];
    self.titleNode.layerBacked = YES;
    self.titleNode.maximumNumberOfLines = 0;
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15.0f] ,NSForegroundColorAttributeName:UIColorFromRGB(0x444444)};
    self.titleNode.attributedText = [[NSAttributedString alloc]initWithString:self.orderNodel.title attributes:attrs];
    [self addSubnode:self.titleNode];
    
    //计算title高度
    CGSize attSize = [self.titleNode.attributedText boundingRectWithSize:CGSizeMake(200, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    _allHeight += attSize.height + 8;//加上8是加上布局间距
}
- (void)addDescNode{
    self.descNode = [[ASTextNode alloc] init];
    self.descNode.layerBacked = YES;
    self.descNode.maximumNumberOfLines = 0;
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15.0f] ,NSForegroundColorAttributeName:UIColorFromRGB(0x444444)};
    self.descNode.attributedText = [[NSAttributedString alloc]initWithString:self.orderNodel.desc attributes:attrs];
    [self addSubnode:self.descNode];
    
    CGSize attSize = [self.descNode.attributedText boundingRectWithSize:CGSizeMake(200, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;

    _allHeight += attSize.height  + 8;//加上8是加上布局间距

}

- (void)addGoodNode{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.orderNodel.goodArray.count];

    for (int i = 0; i<self.orderNodel.goodArray.count; i++) {
                GoodImageView *node = [[GoodImageView alloc]initWithCommentItem:self.orderNodel.goodArray[i]];
                [self addSubnode:node];
                [array addObject:node];
   
            }

      _replayNodes = [array copy];
}
- (void)layout{
    [super layout];
}
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    NSArray *goodArray = self.orderNodel.goodArray;
     //for循环计算每个cell高度
    for (GoodModel *goodModel in goodArray) {
        NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]};  //指定字号
        CGRect rect = [goodModel.name boundingRectWithSize:CGSizeMake(0, 50)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading attributes:dic context:nil];
        _tableHeight += rect.size.height;
        if (goodModel.productImageArray.count % 4 == 0) {
            _tableHeight += 60 * widthScale * (goodModel.productImageArray.count / 4);
        }else{
            _tableHeight += 60 * widthScale * (goodModel.productImageArray.count / 4 + 1);
        }
    }
    _allHeight += _tableHeight;
   
    NSLog(@"%ld", self.index.row);
    NSMutableArray *rightArray =[[NSMutableArray alloc] initWithObjects:_titleNode, _descNode,nil];
    [rightArray addObjectsFromArray:_replayNodes];
    ASStackLayoutSpec *verStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:8 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:rightArray];
    verStackLayout.style.flexGrow = YES;
    verStackLayout.style.flexShrink  = YES;

    //设置个每个cell间距10
    self.dateNode.style.preferredSize =  CGSizeMake(130 * widthScale,_allHeight + 10);
    self.dateNode.style.flexShrink = YES;
     ASStackLayoutSpec *horStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[self.dateNode,verStackLayout]];
    horStackLayout.style.flexShrink = YES;
    return horStackLayout;
}

@end
