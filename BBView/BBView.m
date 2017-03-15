//
//  BBView.m
//  BBView
//
//  Created by Cam Feenstra on 3/14/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "BBView.h"

@interface BBView(){
    NSMutableDictionary *subViewDict;
    NSMutableArray *gestureArr;
    NSMutableArray *actionArr;
}

@end

@implementation BBView

-(id)init
{
    self=[super init];
    subViewDict=[[NSMutableDictionary alloc] init];
    gestureArr=[[NSMutableArray alloc] init];
    actionArr=[[NSMutableArray alloc] init];
    self.layoutSubviewsBlock=nil;
    self.setFrameBlock=nil;
    self.delegate=nil;
    return self;
}

-(NSDictionary*)subviewDictionary
{
    return subViewDict;
}

-(BOOL)becomeFirstResponder{
    BOOL can=[super becomeFirstResponder];
    if(can){
        if(self.delegate!=nil&&[self.delegate respondsToSelector:@selector(BBView:firstResponderStatusDidChangeTo:)]){
            [self.delegate BBView:self firstResponderStatusDidChangeTo:YES];
        }
    }
    return can;
}

-(BOOL)resignFirstResponder
{
    BOOL can=[super resignFirstResponder];
    if(can){
        if(self.delegate!=nil&&[self.delegate respondsToSelector:@selector(BBView:firstResponderStatusDidChangeTo:)]){
            [self.delegate BBView:self firstResponderStatusDidChangeTo:NO];
        }
    }
    return can;
}

-(void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event
{
    [super pressesBegan:presses withEvent:event];
    if(self.delegate!=nil&&[self.delegate respondsToSelector:@selector(BBView:pressesBegan:withEvent:)]){
        [self.delegate BBView:self pressesBegan:presses withEvent:event];
    }
}

-(void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event
{
    [super pressesEnded:presses withEvent:event];
    if(self.delegate!=nil&&[self.delegate respondsToSelector:@selector(BBView:pressesEnded:withEvent:)]){
        [self.delegate BBView:self pressesEnded:presses withEvent:event];
    }
}

-(void)pressesChanged:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event
{
    [super pressesChanged:presses withEvent:event];
    if(self.delegate!=nil&&[self.delegate respondsToSelector:@selector(BBView:pressesChanged:withEvent:)]){
        [self.delegate BBView:self pressesChanged:presses withEvent:event];
    }
}

-(void)pressesCancelled:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event{
    [super pressesCancelled:presses withEvent:event];
    if(self.delegate!=nil&&[self.delegate respondsToSelector:@selector(BBView:pressesCancelled:withEvent:)]){
        [self.delegate BBView:self pressesCancelled:presses withEvent:event];
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if(self.delegate!=nil&&[self.delegate respondsToSelector:@selector(BBView:willMoveToSuperview:)]){
        [self.delegate BBView:self willMoveToSuperview:newSuperview];
    }
}

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    if(self.delegate!=nil&&[self.delegate respondsToSelector:@selector(BBViewDidMoveToSuperView:)]){
        [self.delegate BBViewDidMoveToSuperView:self];
    }
}


//Implementing layout blocks

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(self.setFrameBlock!=nil){
        self.setFrameBlock(self);
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if(self.layoutSubviewsBlock!=nil){
        self.layoutSubviewsBlock(self);
    }
}

//Methods for string-based management of subviews

-(UIView*)objectForKeyedSubscript:(NSString*)key{
    return [self subviewWithIdentifier:key];
}

-(void)setObject:(UIView*)sub forKeyedSubscript:(NSString*)key{
    [self setSubview:sub forIdentifier:key];
}

-(void)addSubview:(UIView *)view withIdentifier:(NSString *)iden{
    [self addSubview:view];
    [subViewDict setObject:view forKey:iden];
}

-(UIView*)subviewWithIdentifier:(NSString *)identifier
{
    return self.subviewDictionary[identifier];
}

-(void)setIdentifier:(NSString *)iden forSubview:(UIView *)sub
{
    [self setSubview:sub forIdentifier:iden];
}

-(void)setSubview:(UIView *)sub forIdentifier:(NSString *)iden
{
    if([self.subviewDictionary.objectEnumerator.allObjects containsObject:sub])
    {
        subViewDict[iden]=sub;
    }
    else
    {
        [self addSubview:sub withIdentifier:iden];
    }
}

-(void)addSubview:(UIView *)view
{
    [super addSubview:view];
}

-(void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];
    if([self.subviewDictionary.objectEnumerator.allObjects containsObject:subview]){
        [subViewDict removeObjectForKey:[subViewDict allKeysForObject:subview].firstObject];
    }
}

//Methods for block-based management of gesture recognizers

-(void)gestureFired:(UIGestureRecognizer*)gesture{
    if([gestureArr containsObject:gesture]){
        void (^block)(UIGestureRecognizer*)=(void(^)(UIGestureRecognizer*))actionArr[[gestureArr indexOfObject:gesture]];
        if(block!=nil){
            block(gesture);
        }
    }
}

-(void)setActionBlock:(void (^)(UIGestureRecognizer *))actionBlock forGestureRecognizer:(UIGestureRecognizer *)gesture
{
    if(![self.gestureRecognizers containsObject:gesture]){
        return;
    }
    if(![gestureArr containsObject:gesture]){
        [gesture addTarget:self action:@selector(gestureFired:)];
        [gestureArr addObject:gesture];
        [actionArr addObject:actionBlock];
    }
    else{
        actionArr[[gestureArr indexOfObject:gesture]]=actionBlock;
    }
}

-(void)removeActionBlockForGestureRecognizer:(UIGestureRecognizer *)gesture
{
    if([gestureArr containsObject:gesture]){
        [gesture removeTarget:self action:@selector(gestureFired:)];
        NSInteger index=[gestureArr indexOfObject:gesture];
        [gestureArr removeObjectAtIndex:index];
        [actionArr removeObjectAtIndex:index];
    }
}

-(void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer withActionBlock:(void (^)(UIGestureRecognizer *))actionBlock
{
    [self addGestureRecognizer:gestureRecognizer];
    [self setActionBlock:actionBlock forGestureRecognizer:gestureRecognizer];
}

-(void)removeGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    [self removeActionBlockForGestureRecognizer:gestureRecognizer];
    [super removeGestureRecognizer:gestureRecognizer];
}


@end

