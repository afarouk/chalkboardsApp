//
//  MessageTableViewCell.m
//  PushChatStarter
//
//  Created by Kauserali on 28/03/13.
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "SpeechBubbleView.h"

static UIColor* color = nil;

@interface MessageTableViewCell() {
    SpeechBubbleView *_bubbleView;
	UILabel *_label;
    UIImageView *saslImageView;
    UILabel *userNameLabel;
}
@end

@implementation MessageTableViewCell

+ (void)initialize
{
	if (self == [MessageTableViewCell class])
	{
		color = [UIColor colorWithRed:219/255.0 green:226/255.0 blue:237/255.0 alpha:1.0];
//        color = [UIColor clearColor];
	}
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
	{
		self.selectionStyle = UITableViewCellSelectionStyleNone;

		// Create the speech bubble view
		_bubbleView = [[SpeechBubbleView alloc] initWithFrame:CGRectZero];
		_bubbleView.backgroundColor = color;
		_bubbleView.opaque = YES;
		_bubbleView.clearsContextBeforeDrawing = NO;
		_bubbleView.contentMode = UIViewContentModeRedraw;
		_bubbleView.autoresizingMask = 0;
		[self.contentView addSubview:_bubbleView];

		// Create the label
		_label = [[UILabel alloc] initWithFrame:CGRectZero];
		_label.backgroundColor = color;
		_label.opaque = YES;
		_label.clearsContextBeforeDrawing = NO;
		_label.contentMode = UIViewContentModeRedraw;
		_label.autoresizingMask = 0;
		_label.font = [UIFont systemFontOfSize:13];
		_label.textColor = [UIColor blackColor];
		[self.contentView addSubview:_label];
        
        // image view
        saslImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 100, 30)];
        saslImageView.contentMode = UIViewContentModeScaleAspectFit;
        saslImageView.autoresizingMask =0;
        [self.contentView addSubview:saslImageView];
        
        // user Name label
        userNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        userNameLabel.textAlignment = NSTextAlignmentRight;
        userNameLabel.backgroundColor = [UIColor clearColor];
        userNameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        userNameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:userNameLabel];
	}
	return self;
}

- (void)layoutSubviews
{
	// This is a little trick to set the background color of a table view cell.
	[super layoutSubviews];
	self.backgroundColor = color;
}

- (void)setMessage:(NSString*)message isSentByUser:(BOOL)isSentByUser dateSent:(NSDate*)date senderName:(NSString*)senderName saslImage:(UIImage*)image
{
	CGPoint point = CGPointZero;
    point.y = 16;
	// We display messages that are sent by the user on the right-hand side of
	// the screen. Incoming messages are displayed on the left-hand side.
	BubbleType bubbleType;
    CGSize messageSize = [SpeechBubbleView sizeForText:message];
	if (isSentByUser)
	{
		bubbleType = BubbleTypeRighthand;
		senderName = NSLocalizedString(@"You", nil);
		point.x = self.bounds.size.width - messageSize.width-30;
		_label.textAlignment = NSTextAlignmentRight;
	}
	else
	{
		bubbleType = BubbleTypeLefthand;
//		senderName = message;
        point.x = 30;
		_label.textAlignment = NSTextAlignmentLeft;
	}

	// Resize the bubble view and tell it to display the message text
	CGRect rect;
	rect.origin = point;
	rect.size = messageSize;
	_bubbleView.frame = rect;
	[_bubbleView setText:message bubbleType:bubbleType];

	// Format the message date
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
	[formatter setDoesRelativeDateFormatting:YES];
	NSString* dateString = [formatter stringFromDate:date];

	// Set the sender's name and date on the label
    NSLog(@"sender name %@",senderName);
	_label.text = [NSString stringWithFormat:@"%@", dateString];
	[_label sizeToFit];
    if(isSentByUser)
        _label.frame = CGRectMake(8, 5, self.contentView.bounds.size.width - 16-40, 16);
    else
        _label.frame = CGRectMake(50, 5, self.contentView.bounds.size.width - 16-40, 16);

    // add image view at bottom
    if(image) {
        [saslImageView setImage:image];
        saslImageView.frame = CGRectMake(saslImageView.frame.origin.x, _label.frame.origin.y+_label.frame.size.height+_bubbleView.frame.size.height-8, saslImageView.frame.size.width, saslImageView.frame.size.height);
    }else {
        [userNameLabel setText:senderName];
        userNameLabel.frame = CGRectMake(_bubbleView.frame.origin.x, _label.frame.origin.y+_label.frame.size.height+_bubbleView.frame.size.height-8, _bubbleView.frame.size.width+20, 30);
    }
}

@end
