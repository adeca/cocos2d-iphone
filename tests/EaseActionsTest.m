//
// Ease Demo
// a cocos2d example
//

// local import
#import "cocos2d.h"
#import "EaseActionsTest.h"

static int sceneIdx=-1;
static NSString *transitions[] = {
				@"SpriteEase",
				@"SpriteEaseInOut",
				@"SpriteEaseExponential",
				@"SpriteEaseExponentialInOut",
				@"SpriteEaseSine",
				@"SpriteEaseSineInOut",
				@"SpriteEaseElastic",
				@"SpriteEaseElasticInOut",
				@"SpriteEaseBounce",
				@"SpriteEaseBounceInOut",
				@"SpriteEaseBack",
				@"SpriteEaseBackInOut",
				@"SpeedTest",
};

enum {
	kTagAction1 = 1,
	kTagAction2 = 2,
	kTagSlider = 1,
};

Class nextAction(void);
Class backAction(void);
Class restartAction(void);


Class nextAction()
{

	sceneIdx++;
	sceneIdx = sceneIdx % ( sizeof(transitions) / sizeof(transitions[0]) );
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}

Class backAction()
{
	sceneIdx--;
	if( sceneIdx < 0 )
		sceneIdx = sizeof(transitions) / sizeof(transitions[0]) -1;	
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}

Class restartAction()
{
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}



@implementation SpriteDemo
-(id) init
{
	if( (self=[super init])) {

		grossini = [[CCSprite alloc] initWithFile:@"grossini.png"];
		tamara = [[CCSprite alloc] initWithFile:@"grossinis_sister1.png"];
		kathia = [[CCSprite alloc] initWithFile:@"grossinis_sister2.png"];
		
		[self addChild: grossini z:3];
		[self addChild: kathia z:2];
		[self addChild: tamara z:1];

		CGSize s = [[CCDirector sharedDirector] winSize];
		
		[grossini setPosition: ccp(60, 50)];
		[kathia setPosition: ccp(60, 150)];
		[tamara setPosition: ccp(60, 250)];
		
 		CCLabelTTF *label = [CCLabelTTF labelWithString:[self title] fontName:@"Arial" fontSize:32];
		[self addChild: label];
		[label setPosition: ccp(s.width/2, s.height-50)];

		CCMenuItemImage *item1 = [CCMenuItemImage itemWithNormalImage:@"b1.png" selectedImage:@"b2.png" target:self selector:@selector(backCallback:)];
		CCMenuItemImage *item2 = [CCMenuItemImage itemWithNormalImage:@"r1.png" selectedImage:@"r2.png" target:self selector:@selector(restartCallback:)];
		CCMenuItemImage *item3 = [CCMenuItemImage itemWithNormalImage:@"f1.png" selectedImage:@"f2.png" target:self selector:@selector(nextCallback:)];
		
		CCMenu *menu = [CCMenu menuWithItems:item1, item2, item3, nil];
		menu.position = CGPointZero;
		item1.position = ccp(s.width/2-100,30);
		item2.position = ccp(s.width/2, 30);
		item3.position = ccp(s.width/2+100,30);
		[self addChild: menu z:1];
	}

	return self;
}

-(void) dealloc
{
	[grossini release];
	[tamara release];
	[kathia release];
	[super dealloc];
}


-(void) restartCallback: (id) sender
{
	CCScene *s = [CCScene node];
	[s addChild: [restartAction() node]];
	[[CCDirector sharedDirector] replaceScene: s];
}

-(void) nextCallback: (id) sender
{
	CCScene *s = [CCScene node];
	[s addChild: [nextAction() node]];
	[[CCDirector sharedDirector] replaceScene: s];
}

-(void) backCallback: (id) sender
{
	CCScene *s = [CCScene node];
	[s addChild: [backAction() node]];
	[[CCDirector sharedDirector] replaceScene: s];
}


-(void) positionForTwo
{	
	grossini.position = ccp( 60, 120 );
	tamara.position = ccp( 60, 220);
	kathia.visible = NO;
}
-(NSString*) title
{
	return @"No title";
}
@end

#pragma mark -
#pragma mark Ease Actions

#define CCCA(x) [[x copy] autorelease]

@implementation SpriteEase
-(void) onEnter
{
	[super onEnter];
	
	CGSize s = [[CCDirector sharedDirector] winSize];

	id move = [CCMoveBy actionWithDuration:3 position:ccp(s.width-130,0)];
	id move_back = [move reverse];
	
	id move_ease_in = [CCEaseIn actionWithAction:[[move copy] autorelease] rate:2.5f];
	id move_ease_in_back = [move_ease_in reverse];
	
	id move_ease_out = [CCEaseOut actionWithAction:[[move copy] autorelease] rate:2.5f];
	id move_ease_out_back = [move_ease_out reverse];
	
	id delay = [CCDelayTime actionWithDuration:0.25f];
	
	id seq1 = [CCSequence actions: move, delay, move_back, CCCA(delay), nil];
	id seq2 = [CCSequence actions: move_ease_in, CCCA(delay), move_ease_in_back, CCCA(delay), nil];
	id seq3 = [CCSequence actions: move_ease_out, CCCA(delay), move_ease_out_back, CCCA(delay), nil];
	
	
	CCAction *a2 = [grossini runAction: [CCRepeatForever actionWithAction:seq1]];
	[a2 setTag:1];

	CCAction *a1 =[tamara runAction: [CCRepeatForever actionWithAction:seq2]];
	[a1 setTag:1];

	CCAction *a = [kathia runAction: [CCRepeatForever actionWithAction:seq3]];
	[a setTag:1];
	
	[self schedule:@selector(testStopAction:) interval:6.25f];
}

-(void) testStopAction:(ccTime)dt
{
	[self unschedule:_cmd];
	[tamara stopActionByTag:1];
	[kathia stopActionByTag:1];
	[grossini stopActionByTag:1];
}

-(NSString *) title
{
	return @"EaseIn - EaseOut - Stop";
}
@end

@implementation SpriteEaseInOut
-(void) onEnter
{
	[super onEnter];
	
	CGSize s = [[CCDirector sharedDirector] winSize];

	id move = [CCMoveBy actionWithDuration:3 position:ccp(s.width-130,0)];
//	id move_back = [move reverse];
	
	id move_ease_inout1 = [CCEaseInOut actionWithAction:[[move copy] autorelease] rate:0.65f];
	id move_ease_inout_back1 = [move_ease_inout1 reverse];
	
	id move_ease_inout2 = [CCEaseInOut actionWithAction:[[move copy] autorelease] rate:1.35f];
	id move_ease_inout_back2 = [move_ease_inout2 reverse];

	id move_ease_inout3 = [CCEaseInOut actionWithAction:[[move copy] autorelease] rate:1.0f];
	id move_ease_inout_back3 = [move_ease_inout3 reverse];
	
	id delay = [CCDelayTime actionWithDuration:0.25f];

	id seq1 = [CCSequence actions: move_ease_inout1, delay, move_ease_inout_back1, CCCA(delay), nil];
	id seq2 = [CCSequence actions: move_ease_inout2, CCCA(delay), move_ease_inout_back2, CCCA(delay), nil];
	id seq3 = [CCSequence actions: move_ease_inout3, CCCA(delay), move_ease_inout_back3, CCCA(delay), nil];
		
	[tamara runAction: [CCRepeatForever actionWithAction:seq1]];
	[kathia runAction: [CCRepeatForever actionWithAction:seq2]];
	[grossini runAction: [CCRepeatForever actionWithAction:seq3]];
}
-(NSString *) title
{
	return @"EaseInOut and rates";
}
@end


@implementation SpriteEaseSine
-(void) onEnter
{
	[super onEnter];
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	id move = [CCMoveBy actionWithDuration:3 position:ccp(s.width-130,0)];
	id move_back = [move reverse];
	
	id move_ease_in = [CCEaseSineIn actionWithAction:[[move copy] autorelease]];
	id move_ease_in_back = [move_ease_in reverse];
	
	id move_ease_out = [CCEaseSineOut actionWithAction:[[move copy] autorelease]];
	id move_ease_out_back = [move_ease_out reverse];
	
	id delay = [CCDelayTime actionWithDuration:0.25f];

	
	id seq1 = [CCSequence actions: move, delay, move_back, CCCA(delay), nil];
	id seq2 = [CCSequence actions: move_ease_in, CCCA(delay), move_ease_in_back, CCCA(delay), nil];
	id seq3 = [CCSequence actions: move_ease_out, CCCA(delay), move_ease_out_back, CCCA(delay), nil];
	
	
	[grossini runAction: [CCRepeatForever actionWithAction:seq1]];
	[tamara runAction: [CCRepeatForever actionWithAction:seq2]];
	[kathia runAction: [CCRepeatForever actionWithAction:seq3]];
}
-(NSString *) title
{
	return @"EaseSineIn - EaseSineOut";
}
@end

@implementation SpriteEaseSineInOut
-(void) onEnter
{
	[super onEnter];
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	id move = [CCMoveBy actionWithDuration:3 position:ccp(s.width-130,0)];
	id move_back = [move reverse];
	
	id move_ease = [CCEaseSineInOut actionWithAction:[[move copy] autorelease]];
	id move_ease_back = [move_ease reverse];
	
	id delay = [CCDelayTime actionWithDuration:0.25f];

	id seq1 = [CCSequence actions: move, delay, move_back, CCCA(delay), nil];
	id seq2 = [CCSequence actions: move_ease, CCCA(delay), move_ease_back, CCCA(delay), nil];

	[self positionForTwo];

	[grossini runAction: [CCRepeatForever actionWithAction:seq1]];
	[tamara runAction: [CCRepeatForever actionWithAction:seq2]];
}
-(NSString *) title
{
	return @"EaseSineInOut action";
}
@end

#pragma mark SpriteEaseExponential

@implementation SpriteEaseExponential
-(void) onEnter
{
	[super onEnter];
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	id move = [CCMoveBy actionWithDuration:3 position:ccp(s.width-130,0)];
	id move_back = [move reverse];
	
	id move_ease_in = [CCEaseExponentialIn actionWithAction:[[move copy] autorelease]];
	id move_ease_in_back = [move_ease_in reverse];
	
	id move_ease_out = [CCEaseExponentialOut actionWithAction:[[move copy] autorelease]];
	id move_ease_out_back = [move_ease_out reverse];
	
	id delay = [CCDelayTime actionWithDuration:0.25f];
	
	id seq1 = [CCSequence actions: move, delay, move_back, CCCA(delay), nil];
	id seq2 = [CCSequence actions: move_ease_in, CCCA(delay), move_ease_in_back, CCCA(delay), nil];
	id seq3 = [CCSequence actions: move_ease_out, CCCA(delay), move_ease_out_back, CCCA(delay), nil];
	

	[grossini runAction: [CCRepeatForever actionWithAction:seq1]];
	[tamara runAction: [CCRepeatForever actionWithAction:seq2]];
	[kathia runAction: [CCRepeatForever actionWithAction:seq3]];
}
-(NSString *) title
{
	return @"ExpIn - ExpOut actions";
}
@end

#pragma mark SpriteEaseExponentialInOut

@implementation SpriteEaseExponentialInOut
-(void) onEnter
{
	[super onEnter];
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	id move = [CCMoveBy actionWithDuration:3 position:ccp(s.width-130,0)];
	id move_back = [move reverse];
	
	id move_ease = [CCEaseExponentialInOut actionWithAction:[[move copy] autorelease]];
	id move_ease_back = [move_ease reverse];
	
	id delay = [CCDelayTime actionWithDuration:0.25f];

	id seq1 = [CCSequence actions: move, delay, move_back, CCCA(delay), nil];
	id seq2 = [CCSequence actions: move_ease, CCCA(delay), move_ease_back, CCCA(delay), nil];
	

	[self positionForTwo];
	
	[grossini runAction: [CCRepeatForever actionWithAction:seq1]];
	[tamara runAction: [CCRepeatForever actionWithAction:seq2]];
}
-(NSString *) title
{
	return @"EaseExponentialInOut action";
}
@end

#pragma mark SpriteEaseElasticInOut

@implementation SpriteEaseElasticInOut
-(void) onEnter
{
	[super onEnter];

	CGSize s = [[CCDirector sharedDirector] winSize];
	
	id move = [CCMoveBy actionWithDuration:3 position:ccp(s.width-130,0)];
	
	id move_ease_inout1 = [CCEaseElasticInOut actionWithAction:[[move copy] autorelease] period:0.3f];
	id move_ease_inout_back1 = [move_ease_inout1 reverse];
	
	id move_ease_inout2 = [CCEaseElasticInOut actionWithAction:[[move copy] autorelease] period:0.45f];
	id move_ease_inout_back2 = [move_ease_inout2 reverse];
	
	id move_ease_inout3 = [CCEaseElasticInOut actionWithAction:[[move copy] autorelease] period:0.6f];
	id move_ease_inout_back3 = [move_ease_inout3 reverse];
	
	id delay = [CCDelayTime actionWithDuration:0.25f];

	
	id seq1 = [CCSequence actions: move_ease_inout1, delay, move_ease_inout_back1, CCCA(delay), nil];
	id seq2 = [CCSequence actions: move_ease_inout2, CCCA(delay), move_ease_inout_back2, CCCA(delay), nil];
	id seq3 = [CCSequence actions: move_ease_inout3, CCCA(delay), move_ease_inout_back3, CCCA(delay), nil];
	
	[tamara runAction: [CCRepeatForever actionWithAction:seq1]];
	[kathia runAction: [CCRepeatForever actionWithAction:seq2]];
	[grossini runAction: [CCRepeatForever actionWithAction:seq3]];
}
-(NSString *) title
{
	return @"EaseElasticInOut action";
}
@end

#pragma mark SpriteEaseElastic

@implementation SpriteEaseElastic
-(void) onEnter
{
	[super onEnter];
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	id move = [CCMoveBy actionWithDuration:3 position:ccp(s.width-130,0)];
	id move_back = [move reverse];
	
	id move_ease_in = [CCEaseElasticIn actionWithAction:[[move copy] autorelease]];
	id move_ease_in_back = [move_ease_in reverse];
	
	id move_ease_out = [CCEaseElasticOut actionWithAction:[[move copy] autorelease]];
	id move_ease_out_back = [move_ease_out reverse];

	id delay = [CCDelayTime actionWithDuration:0.25f];

	id seq1 = [CCSequence actions: move, delay, move_back, CCCA(delay), nil];
	id seq2 = [CCSequence actions: move_ease_in, CCCA(delay), move_ease_in_back, CCCA(delay), nil];
	id seq3 = [CCSequence actions: move_ease_out, CCCA(delay), move_ease_out_back, CCCA(delay), nil];
	
	[grossini runAction: [CCRepeatForever actionWithAction:seq1]];
	[tamara runAction: [CCRepeatForever actionWithAction:seq2]];
	[kathia runAction: [CCRepeatForever actionWithAction:seq3]];
}
-(NSString *) title
{
	return @"Elastic In - Out actions";
}
@end

#pragma mark SpriteEaseBounce

@implementation SpriteEaseBounce
-(void) onEnter
{
	[super onEnter];
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	id move = [CCMoveBy actionWithDuration:3 position:ccp(s.width-130,0)];
	id move_back = [move reverse];
	
	id move_ease_in = [CCEaseBounceIn actionWithAction:[[move copy] autorelease]];
	id move_ease_in_back = [move_ease_in reverse];
	
	id move_ease_out = [CCEaseBounceOut actionWithAction:[[move copy] autorelease]];
	id move_ease_out_back = [move_ease_out reverse];
	
	id delay = [CCDelayTime actionWithDuration:0.25f];

	id seq1 = [CCSequence actions: move, delay, move_back, CCCA(delay), nil];
	id seq2 = [CCSequence actions: move_ease_in, CCCA(delay), move_ease_in_back, CCCA(delay), nil];
	id seq3 = [CCSequence actions: move_ease_out, CCCA(delay), move_ease_out_back, CCCA(delay), nil];
	
	[grossini runAction: [CCRepeatForever actionWithAction:seq1]];
	[tamara runAction: [CCRepeatForever actionWithAction:seq2]];
	[kathia runAction: [CCRepeatForever actionWithAction:seq3]];
}
-(NSString *) title
{
	return @"Bounce In - Out actions";
}
@end

@implementation SpriteEaseBounceInOut
-(void) onEnter
{
	[super onEnter];
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	id move = [CCMoveBy actionWithDuration:3 position:ccp(s.width-130,0)];
	id move_back = [move reverse];
	
	id move_ease = [CCEaseBounceInOut actionWithAction:[[move copy] autorelease]];
	id move_ease_back = [move_ease reverse];
	
	id delay = [CCDelayTime actionWithDuration:0.25f];

	id seq1 = [CCSequence actions: move, delay, move_back, CCCA(delay), nil];
	id seq2 = [CCSequence actions: move_ease, CCCA(delay), move_ease_back, CCCA(delay), nil];
	
	[self positionForTwo];
	
	[grossini runAction: [CCRepeatForever actionWithAction:seq1]];
	[tamara runAction: [CCRepeatForever actionWithAction:seq2]];
}
-(NSString *) title
{
	return @"EaseBounceInOut action";
}
@end

#pragma mark SpriteEaseBack

@implementation SpriteEaseBack
-(void) onEnter
{
	[super onEnter];
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	id move = [CCMoveBy actionWithDuration:3 position:ccp(s.width-130,0)];
	id move_back = [move reverse];
	
	id move_ease_in = [CCEaseBackIn actionWithAction:[[move copy] autorelease]];
	id move_ease_in_back = [move_ease_in reverse];
	
	id move_ease_out = [CCEaseBackOut actionWithAction:[[move copy] autorelease]];
	id move_ease_out_back = [move_ease_out reverse];
	
	id delay = [CCDelayTime actionWithDuration:0.25f];

	id seq1 = [CCSequence actions: move, delay, move_back, CCCA(delay), nil];
	id seq2 = [CCSequence actions: move_ease_in, CCCA(delay), move_ease_in_back, CCCA(delay), nil];
	id seq3 = [CCSequence actions: move_ease_out, CCCA(delay), move_ease_out_back, CCCA(delay), nil];
	
	[grossini runAction: [CCRepeatForever actionWithAction:seq1]];
	[tamara runAction: [CCRepeatForever actionWithAction:seq2]];
	[kathia runAction: [CCRepeatForever actionWithAction:seq3]];
}
-(NSString *) title
{
	return @"Back In - Out actions";
}
@end

@implementation SpriteEaseBackInOut
-(void) onEnter
{
	[super onEnter];
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	id move = [CCMoveBy actionWithDuration:3 position:ccp(s.width-130,0)];
	id move_back = [move reverse];
	
	id move_ease = [CCEaseBackInOut actionWithAction:[[move copy] autorelease]];
	id move_ease_back = [move_ease reverse];

	id delay = [CCDelayTime actionWithDuration:0.25f];

	id seq1 = [CCSequence actions: move, delay, move_back, CCCA(delay), nil];
	id seq2 = [CCSequence actions: move_ease, CCCA(delay), move_ease_back, CCCA(delay), nil];
	

	[self positionForTwo];
	
	[grossini runAction: [CCRepeatForever actionWithAction:seq1]];
	[tamara runAction: [CCRepeatForever actionWithAction:seq2]];
}
-(NSString *) title
{
	return @"EaseBackInOut action";
}
@end


#pragma mark SpeedTest

@implementation SpeedTest
-(void) onEnter
{
	[super onEnter];
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	// rotate and jump
	CCActionInterval *jump1 = [CCJumpBy actionWithDuration:4 position:ccp(-s.width+80,0) height:100 jumps:4];
	CCActionInterval *jump2 = [jump1 reverse];
	CCActionInterval *rot1 = [CCRotateBy actionWithDuration:4 angle:360*2];
	CCActionInterval *rot2 = [rot1 reverse];
	
	id seq3_1 = [CCSequence actions:jump2, jump1, nil];
	id seq3_2 = [CCSequence actions: rot1, rot2, nil];
	id spawn = [CCSpawn actions:seq3_1, seq3_2, nil];
	id action = [CCSpeed actionWithAction: [CCRepeatForever actionWithAction:spawn] speed:1.0f];
	[action setTag: kTagAction1];
	
	id action2 = [[action copy] autorelease];
	id action3 = [[action copy] autorelease];

	[action2 setTag:kTagAction1];
	[action3 setTag:kTagAction1];
	
	[grossini runAction: action2 ];
	[tamara runAction: action3];
	[kathia runAction:action];
	
	
	[self schedule:@selector(altertime:) interval:1.0f];
}

-(void) altertime:(ccTime)dt
{	
	id action1 = [grossini getActionByTag:kTagAction1];
	id action2 = [tamara getActionByTag:kTagAction1];
	id action3 = [kathia getActionByTag:kTagAction1];
	
	[action1 setSpeed: CCRANDOM_0_1() * 2];
	[action2 setSpeed: CCRANDOM_0_1() * 2];
	[action3 setSpeed: CCRANDOM_0_1() * 2];

}

-(NSString *) title
{
	return @"Speed action";
}
@end

#pragma mark - AppController

// CLASS IMPLEMENTATIONS

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

@implementation AppController

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[super application:application didFinishLaunchingWithOptions:launchOptions];

	// Turn on display FPS
	[director_ setDisplayStats:YES];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	// When in iPad / RetinaDisplay mode, CCFileUtils will append the "-ipad" / "-hd" to all loaded files
	// If the -ipad  / -hdfile is not found, it will load the non-suffixed version
	[CCFileUtils setiPadSuffix:@"-ipad"];			// Default on iPad is "" (empty string)
	[CCFileUtils setRetinaDisplaySuffix:@"-hd"];	// Default on RetinaDisplay is "-hd"
	
	CCScene *scene = [CCScene node];
	[scene addChild: [nextAction() node]];	
	
	[director_ pushScene: scene];
	
	return YES;
}
@end

#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)

@implementation cocos2dmacAppDelegate

@synthesize window=window_, glView=glView_;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
	
	[director setDisplayStats:YES];
	
	[director setView:glView_];
	
	//	[director setProjection:kCCDirectorProjection2D];
	
	// Enable "moving" mouse event. Default no.
	[window_ setAcceptsMouseMovedEvents:NO];
	
	// EXPERIMENTAL stuff.
	// 'Effects' don't work correctly when autoscale is turned on.
	[director setResizeMode:kCCDirectorResize_AutoScale];
	
	CCScene *scene = [CCScene node];
	[scene addChild: [nextAction() node]];
	
	[director runWithScene:scene];
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) theApplication
{
	return YES;
}

- (IBAction)toggleFullScreen: (id)sender
{
	CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
	[director setFullScreen: ! [director isFullScreen] ];
}

@end
#endif
