//
//  BBView.h
//  BBView
//
//  Created by Cam Feenstra on 3/14/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for BBView.
FOUNDATION_EXPORT double BBViewVersionNumber;

//! Project version string for BBView.
FOUNDATION_EXPORT const unsigned char BBViewVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <BBView/PublicHeader.h>

@class BBView;

@protocol BBViewDelegate <NSObject>

@optional

//All of these methods simply pass the parameters of the corresponding built-in UIView methods to another object.  This protocol is simply meant to extend the non-subclassing customization options of UIView that BBView is implemented to improve

-(void)BBView:(BBView*)view firstResponderStatusDidChangeTo:(BOOL)isFirstResponder;

-(void)BBView:(BBView*)view pressesBegan:(NSSet<UIPress*>*)presses withEvent:(UIPressesEvent*)event;

-(void)BBView:(BBView*)view pressesChanged:(NSSet<UIPress*>*)presses withEvent:(UIPressesEvent*)event;

-(void)BBView:(BBView*)view pressesEnded:(NSSet<UIPress*>*)presses withEvent:(UIPressesEvent*)event;

-(void)BBView:(BBView*)view pressesCancelled:(NSSet<UIPress*>*)presses withEvent:(UIPressesEvent*)event;

-(void)BBView:(BBView*)view willMoveToSuperview:(UIView*)superview;

-(void)BBViewDidMoveToSuperView:(BBView*)view;

@end

@interface BBView : UIView

@property (readonly) NSDictionary *subviewDictionary;

@property (strong, nonatomic) void (^setFrameBlock)(BBView*);

@property (strong, nonatomic) void (^layoutSubviewsBlock)(BBView*);

@property (weak, nonatomic) id<BBViewDelegate> delegate;

//String-based management of subviews

-(void)addSubview:(UIView *)view withIdentifier:(NSString*)iden;

-(UIView*)subviewWithIdentifier:(NSString*)identifier;

-(void)setIdentifier:(NSString*)iden forSubview:(UIView*)sub;

-(UIView*)objectForKeyedSubscript:(NSString*)subscript;

-(void)setObject:(UIView*)ob forKeyedSubscript:(NSString*)key;

//Block-based management of gesture recognizers

-(void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer withActionBlock:(void(^)(UIGestureRecognizer*))actionBlock;

-(void)setActionBlock:(void(^)(UIGestureRecognizer*))actionBlock forGestureRecognizer:(UIGestureRecognizer*)gesture;

-(void)removeActionBlockForGestureRecognizer:(UIGestureRecognizer*)gesture;

@end


