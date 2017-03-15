# BBView
The easiest way to install this framework is using CocoaPods.  Simply add:
```
pod 'BBView'
```
`to the Podfile of your Xcode project.

BBView is a UIView subclass that leverages the power of block-based programming to allow for far greater non-subclassing customization of
UIView.  There are three main components to BBView: layout blocks, gesture recognizer action blocks, and a delegate protocol which "cleans up around the edges" a bit, allowing for even greater customization if more than just layout blocks and action blocks are required for the desired customization.  The first component, layout blocks, are implemented as the setFrameBlock and layoutSubviewsBlock properties of BBView.  To supplement this, string identifiers can be set for subviews to help access them in layout blocks.  Each of these allows the developer to append code to the standard UIView methods of setFrame and layoutSubviews, respectively.  A code example is given below.
```
  BBView *super=[[BBView alloc] init];
  UIView *sub=[[UIView alloc] init];
  [super addSubview:sub]
  [super setIdentifier:@"subview" forSubview:sub];
  //Note that setting an identifier for a subview will add it as a subview if it is not one already.  The addSubview line could be omitted.
  super.frameChangeBlock=^(BBView *view){
    [(BBView*)view subViewForIdentifier:@"subview"].frame=view.bounds;
  };
  super.frame=CGRectMake(0,0,100,100);
  //sub's frame is now also CGRectMake(0,0,100,100)
```
Another way that BBView uses blocks to improve UIView customization is by allowing the developer the set "action blocks" for the gesture recognizers they add to the view.  A code example for this is also provided below.
```
    BBView *view=[[BBView alloc] init];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] init];
    [view addGestureRecognizer:tap];
    [view setActionBlock:(UIGestureRecognizer *gesture){
        NSLog(@"tapped!");
        [(BBView*)gesture.view removeActionBlockForGestureRecognizer:gesture];
    } forGestureRecognizer:tap];
```

The above code creates a tap gesture recognizer which will only fire once, at which point it will print "tapped!" to the console.

The last capability it has is adding a delegate protocol.  All of the methods are optional and function similarly to the layout blocks in that they simply append the corresponding standard UIView methods of the same names.  The protocol is defined below:
```
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
```
