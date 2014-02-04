//
//  CABCheckbox.h
//
//  A checkbox inspired by others in particular M13Checkbox but customised for my use case.
//

#import <UIKit/UIKit.h>

#define CABCheckboxDefaultHeight 16.0

#define kBoxRadius 0.1875
#define kBoxStrokeWidth 0.05

//States
typedef enum {
    CABCheckboxStateUnchecked = NO, //Default
    CABCheckboxStateChecked = YES,
    CABCheckboxStateMixed
} CABCheckboxState;

//Box location compared to text
typedef enum {
    CABCheckboxAlignmentLeft,
    CABCheckboxAlignmentRight //Default
} CABCheckboxAlignment;

@interface CABCheckbox : UIControl

@property (nonatomic, strong) UILabel *titleLabel; //Label will fill available frame - box size.
@property (nonatomic, assign) CABCheckboxState checkState;
@property (nonatomic, assign) CABCheckboxAlignment checkAlignment UI_APPEARANCE_SELECTOR; //Set the box to the left or right of the text
@property (nonatomic, readonly) CGRect boxFrame; //Location of checkbox in control

//Values, the values returned by using the - (id)value method, this is a convenience method if you have a group of boxes on a page. That way one does not have to do if(box == mybox) {if( mybox.checkState == ... for every checkbox
@property (nonatomic, strong) id checkedValue;
@property (nonatomic, strong) id uncheckedValue;
@property (nonatomic, strong) id mixedValue;
- (id)value;

- (id)init; // create with default height
- (id)initWithFrame:(CGRect)frame; //manually override default frame, checkbox will fill height of frame, and label font size will be determined by the height
- (id)initWithTitle:(NSString *)title; // set the frame with a default height, width will expand to fit text
- (id)initWithTitle:(NSString *)title andHeight:(CGFloat)height;//set the frame with the specified height, width will expand to fit text

- (void)setTitle:(NSString *)title;
- (void)setCheckState:(CABCheckboxState)state;//Change state programitically
// Toggle through the check states, override this if you wish to change behaviour
- (void)toggleCheckState;
- (void)autoFitFontToHeight;//If you change the font, run this to change the font size to fit the frame.
- (void)autoFitWidthToText;

//Subclass CABCheckbox and override these method to customise. see method for more details.
- (UIBezierPath *)checkShape:(CGRect)boxRect;
- (UIBezierPath *)mixedShape:(CGRect)boxRect;

//Appearance
@property (nonatomic, assign) CGFloat boxStrokeWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *boxStrokeColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *checkColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *boxFillColorChecked UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *boxFillColorUnchecked UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat boxCornerRadius UI_APPEARANCE_SELECTOR;

@end
