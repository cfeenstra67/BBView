# BBView
BBView is a UIView subclass that leverages the power of block-based programming to allow for far greater non-subclassing customization of
UIView.  There are three main components to BBView: layout blocks, gesture recognizer action blocks, and a delegate protocol which "cleans up around the edges" a bit, allowing for even greater customization if more than just layout blocks and action blocks are required for the desired customization.  The first component, layout blocks, are implemented as the setFrameBlock and layoutSubviewsBlock properties of BBView.  To supplement this, string identifiers can be set for subviews to help access them in layout blocks.  Each of these allows the developer to append code to the standard UIView methods of setFrame and layoutSubviews, respectively.  A code example is given below.
```
-(void)function{
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
  
}
```
