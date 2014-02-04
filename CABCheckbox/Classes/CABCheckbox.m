//
//  CABCheckbox.m
//

#import "CABCheckbox.h"

#define kBoxSize .875
#define kCheckHorizontalExtention .125
#define kCheckVerticalExtension .125
#define kCheckIndent .125
#define kCheckRaise .1875
#define kCheckSize .8125
#define kCheckBoxSpacing 0.3125
#define kCABCheckboxMaxFontSize 100.0

//The view for the Check in the checkbox
@interface CheckView : UIView

@property (nonatomic, retain) CABCheckbox *checkbox;
@property (nonatomic, assign) BOOL selected;

@end

@implementation CheckView
@synthesize checkbox, selected;

- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Set area
    CGRect boxRect = CGRectMake(checkbox.boxStrokeWidth, (self.frame.size.height * kCheckVerticalExtension), (self.frame.size.height * kBoxSize) - checkbox.boxStrokeWidth, (self.frame.size.height * kBoxSize) - checkbox.boxStrokeWidth);
    
    //Set colors
    UIColor *fillColor = nil;
    UIColor *strokeColor = nil;
    UIColor *checkColor = nil;
    
    if (checkbox.checkState == CABCheckboxStateUnchecked) {
        fillColor = checkbox.boxFillColorUnchecked;
    } else {
        fillColor = checkbox.boxFillColorChecked;
    }
    
    if (self.selected) {
        CGFloat r, g, b, a;
        [fillColor getRed:&r green:&g blue:&b alpha:&a];
    }
    
    if (!checkbox.enabled) {
        CGFloat r, g, b, a;
        [fillColor getRed:&r green:&g blue:&b alpha:&a];
        fillColor = [UIColor colorWithRed:(r + .2) green:(g + .2) blue:(b + .2) alpha:a];
        [checkbox.boxStrokeColor getRed:&r green:&g blue:&b alpha:&a];
        strokeColor = [UIColor colorWithRed:(r + .2) green:(g + .2) blue:(b + .2) alpha:a];
        [checkbox.checkColor getRed:&r green:&g blue:&b alpha:&a];
        checkColor = [UIColor colorWithRed:(r + .2) green:(g + .2) blue:(b + .2) alpha:a];
    } else {
        strokeColor = checkbox.boxStrokeColor;
        checkColor = checkbox.checkColor;
    }
    
    //Draw box
	UIBezierPath *boxPath = [UIBezierPath bezierPathWithRoundedRect:boxRect cornerRadius:checkbox.boxCornerRadius];
	[fillColor setFill];
	[boxPath fill];
	[strokeColor setStroke];
	boxPath.lineWidth = checkbox.boxStrokeWidth;
	[boxPath stroke];
    
    //Draw Shape in middel of the box
    if (checkbox.checkState == CABCheckboxStateUnchecked) {
        //Do Nothing
    }
	else if (checkbox.checkState == CABCheckboxStateChecked) {
        [checkColor setFill];
        [[checkbox checkShape:boxRect] fill];
    }
	else if (checkbox.checkState == CABCheckboxStateMixed) {
        [checkColor setFill];
        [[checkbox mixedShape:boxRect] fill];
    }
    
    //Cleanup
    CGColorSpaceRelease(colorSpace);
}

@end

//User Visible Properties
@interface CABCheckbox ()

@property (nonatomic, assign) CGRect boxFrame;
@property (nonatomic, strong) CheckView *checkView;
@property (nonatomic, strong) UIColor *labelColor;

@end

@implementation CABCheckbox

@synthesize enabled=_enabled;

- (id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, CABCheckboxDefaultHeight, CABCheckboxDefaultHeight)];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setDefaults];
    }
    return self;
}

- (void)setDefaults {
	self.boxStrokeColor = [UIColor colorWithRed:0.02 green:0.47 blue:1 alpha:1];
	self.boxStrokeWidth = kBoxStrokeWidth * self.frame.size.height;
	self.checkColor = [UIColor colorWithRed:0.02 green:0.47 blue:1 alpha:1];
	self.boxFillColorChecked = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	self.boxFillColorUnchecked = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
	self.boxCornerRadius = kBoxRadius * self.frame.size.height;
	self.checkAlignment = CABCheckboxAlignmentRight;
	self.checkState = CABCheckboxStateUnchecked;
	self.enabled = YES;
	self.checkView = [[CheckView alloc] initWithFrame:CGRectMake(self.frame.size.width - ((kBoxSize + kCheckHorizontalExtention) * self.frame.size.height), 0, ((kBoxSize + kCheckHorizontalExtention) * self.frame.size.height), self.frame.size.height)];
	self.checkView.checkbox = self;
	self.checkView.selected = NO;
	self.checkView.backgroundColor = [UIColor clearColor];
	self.checkView.clipsToBounds = NO;
	self.checkView.userInteractionEnabled = NO;
	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height * kCheckVerticalExtension, self.frame.size.width - self.checkView.frame.size.width - (self.frame.size.height * kCheckBoxSpacing), self.frame.size.height * kBoxSize)];
	self.titleLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
	self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
	self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
	self.titleLabel.backgroundColor = [UIColor clearColor];
	self.titleLabel.userInteractionEnabled = NO;
	[self autoFitFontToHeight];
	[self addSubview:self.checkView];
	[self addSubview:self.titleLabel];
	self.clipsToBounds = NO;
	self.backgroundColor = [UIColor clearColor];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setDefaults];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
{
    self = [self initWithTitle:title andHeight:CABCheckboxDefaultHeight];
    return self;
}

- (id)initWithTitle:(NSString *)title andHeight:(CGFloat)height
{
    self = [self initWithFrame:CGRectMake(0, 0, 100.0, height)];
    if (self) {
        self.titleLabel.text = title;
        [self autoFitFontToHeight];
        CGSize labelSize = [title sizeWithFont:self.titleLabel.font];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, labelSize.width + (self.frame.size.height * kCheckBoxSpacing) + ((kBoxSize + kCheckHorizontalExtention) * self.frame.size.height), self.frame.size.height);
        [self layoutSubviews];
    }
    return self;
}

/*
 The shape is defined by the height of the frame. The decimal numbers are the percentage of the height that distance is. That way, the shape can be drawn for any height.
 */

- (UIBezierPath *)checkShape:(CGRect)boxRect
{
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake((0.17625 * self.frame.size.height), (0.368125 * self.frame.size.height))];
    [bezierPath addCurveToPoint: CGPointMake((0.17625 * self.frame.size.height), (0.46375 * self.frame.size.height)) controlPoint1: CGPointMake((0.13125 * self.frame.size.height), (0.418125 * self.frame.size.height)) controlPoint2: CGPointMake((0.17625 * self.frame.size.height), (0.46375 * self.frame.size.height))];
    [bezierPath addLineToPoint: CGPointMake((0.4 * self.frame.size.height), (0.719375 * self.frame.size.height))];
    [bezierPath addCurveToPoint: CGPointMake((0.45375* self.frame.size.height), (0.756875 * self.frame.size.height)) controlPoint1: CGPointMake((0.4 * self.frame.size.height), (0.719375 * self.frame.size.height)) controlPoint2: CGPointMake((0.4275 * self.frame.size.height), (0.756875 * self.frame.size.height))];
    [bezierPath addCurveToPoint: CGPointMake((0.505625 * self.frame.size.height), (0.719375 * self.frame.size.height)) controlPoint1: CGPointMake((0.480625 * self.frame.size.height), (0.75625 * self.frame.size.height)) controlPoint2: CGPointMake((0.505625 * self.frame.size.height), (0.719375 * self.frame.size.height))];
    [bezierPath addLineToPoint: CGPointMake((0.978125* self.frame.size.height), (0.145625* self.frame.size.height))];
    [bezierPath addCurveToPoint: CGPointMake((0.978125* self.frame.size.height), (0.050625* self.frame.size.height)) controlPoint1: CGPointMake((0.978125* self.frame.size.height), (0.145625* self.frame.size.height)) controlPoint2: CGPointMake((1.026875* self.frame.size.height), (0.09375* self.frame.size.height))];
    [bezierPath addCurveToPoint: CGPointMake((0.885625* self.frame.size.height), (0.050625* self.frame.size.height)) controlPoint1: CGPointMake((0.929375* self.frame.size.height), (0.006875* self.frame.size.height)) controlPoint2: CGPointMake((0.885625* self.frame.size.height), (0.050625* self.frame.size.height))];
    [bezierPath addLineToPoint: CGPointMake((0.45375* self.frame.size.height), (0.590625* self.frame.size.height))];
    [bezierPath addLineToPoint: CGPointMake((0.26875* self.frame.size.height), (0.368125 * self.frame.size.height))];
    [bezierPath addCurveToPoint: CGPointMake((0.17625 * self.frame.size.height), (0.368125 * self.frame.size.height)) controlPoint1: CGPointMake((0.26875* self.frame.size.height), (0.368125 * self.frame.size.height)) controlPoint2: CGPointMake((0.221875* self.frame.size.height), (0.318125* self.frame.size.height))];
    [bezierPath closePath];
    bezierPath.miterLimit = 0;
    return bezierPath;
}

-(UIBezierPath *)mixedShape:(CGRect)boxRect {
	UIBezierPath *mixedPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.boxStrokeWidth + ((boxRect.size.width - (.5 * self.frame.size.height)) * 0.5), (self.frame.size.height * .5) - ((0.09375 * self.frame.size.height) * .5), .5 * self.frame.size.height, 0.1875 * self.frame.size.height) cornerRadius:(0.09375 * self.frame.size.height)];
	return mixedPath;
}

- (void)autoFitFontToHeight
{
    CGFloat height = self.frame.size.height * kBoxSize;
    CGFloat fontSize = kCABCheckboxMaxFontSize;
    CGFloat tempHeight = MAXFLOAT;
    
    do {
        //Update font
        fontSize -= 1;
        UIFont *font = [UIFont fontWithName:self.titleLabel.font.fontName size:fontSize];
        //Get size
        CGSize labelSize = [@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" sizeWithFont:font];
        tempHeight = labelSize.height;
    } while (tempHeight >= height);
    
    self.titleLabel.font = [UIFont fontWithName:self.titleLabel.font.fontName size:fontSize];
}

- (void)autoFitWidthToText
{
    CGSize labelSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, labelSize.width + (self.frame.size.height * kCheckBoxSpacing) + ((kBoxSize + kCheckHorizontalExtention) * self.frame.size.height), self.frame.size.height);
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    if (self.checkAlignment == CABCheckboxAlignmentRight) {
        self.checkView.frame = CGRectMake(self.frame.size.width - ((kBoxSize + kCheckHorizontalExtention) * self.frame.size.height), 0, ((kBoxSize + kCheckHorizontalExtention) * self.frame.size.height), self.frame.size.height);
        self.titleLabel.frame = CGRectMake(0, self.frame.size.height * kCheckVerticalExtension, self.frame.size.width - self.checkView.frame.size.width - (self.frame.size.height * kCheckBoxSpacing), self.frame.size.height * kBoxSize);
    }
	else {
        self.checkView.frame = CGRectMake(0, 0, ((kBoxSize + kCheckHorizontalExtention) * self.frame.size.height), self.frame.size.height);
        self.titleLabel.frame = CGRectMake(self.checkView.frame.size.width + (self.frame.size.height * kCheckBoxSpacing), self.frame.size.height * kCheckVerticalExtension, self.frame.size.width - (self.frame.size.height * (kBoxSize + kCheckHorizontalExtention + kCheckBoxSpacing)), self.frame.size.height * kBoxSize);
    }
}

- (void)setCheckState:(CABCheckboxState)checkState{
	[self willChangeValueForKey:@"checkState"];
    _checkState = checkState;
	[self didChangeValueForKey:@"checkState"];
    [self.checkView setNeedsDisplay];
}

- (void)toggleCheckState
{
	if (self.checkState == CABCheckboxStateUnchecked) {
		self.checkState = CABCheckboxStateChecked;
	}
	else if (self.checkState == CABCheckboxStateChecked) {
		self.checkState = CABCheckboxStateMixed;
	}
	else if (self.checkState == CABCheckboxStateMixed) {
		self.checkState = CABCheckboxStateUnchecked;
	}
}

- (void)setEnabled:(BOOL)enabled
{
	[self willChangeValueForKey:@"enabled"];
    if (enabled) {
        self.titleLabel.textColor = self.labelColor;
    }
	else {
        self.labelColor = self.titleLabel.textColor;
        float r, g, b, a;
        [self.labelColor getRed:&r green:&g blue:&b alpha:&a];
        r = floorf(r * 100.0 + 0.5) / 100.0;
        g = floorf(g * 100.0 + 0.5) / 100.0;
        b = floorf(b * 100.0 + 0.5) / 100.0;
        self.titleLabel.textColor = [UIColor colorWithRed:(r + .4) green:(g + .4) blue:(b + .4) alpha:1];
    }
    _enabled = enabled;
	[self didChangeValueForKey:@"enabled"];
    [self.checkView setNeedsDisplay];
}

- (void)setCheckAlignment:(CABCheckboxAlignment)checkAlignment
{
	[self willChangeValueForKey:@"checkAlignment"];
    _checkAlignment = checkAlignment;
	[self didChangeValueForKey:@"checkAlignment"];
    [self layoutSubviews];
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
    [self autoFitFontToHeight];
    CGSize labelSize = [title sizeWithFont:self.titleLabel.font];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, labelSize.width + (self.frame.size.height * kCheckBoxSpacing) + ((kBoxSize + kCheckHorizontalExtention) * self.frame.size.height), self.frame.size.height);
    [self layoutSubviews];
}

- (id)value
{
    if (self.checkState == CABCheckboxStateUnchecked) {
        return self.uncheckedValue;
    }
	else if (self.checkState == CABCheckboxStateChecked) {
        return self.checkedValue;
    }
	else {
        return self.mixedValue;
    }
}

#pragma mark - UIControl overrides

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
    self.checkView.selected = YES;
    [self.checkView setNeedsDisplay];
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super continueTrackingWithTouch:touch withEvent:event];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.checkView.selected = NO;
    [self toggleCheckState];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [super endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    self.checkView.selected = NO;
    [self.checkView setNeedsDisplay];
    [super cancelTrackingWithEvent:event];
}

@end

