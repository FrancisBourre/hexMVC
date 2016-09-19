package hex.view.viewhelper;

import hex.event.IClosureDispatcher;
import hex.module.MockModule;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Tamas Kinsztler
 */
//TODO lot of tests are missing here
class ViewHelperTest
{
	var _viewHelper : MockViewHelper;
	var _view 		: MockView;

	@Before
    public function setUp() : Void
    {
        this._viewHelper = new MockViewHelper();
        this._view 		= new MockView();
    }

    @After
    public function tearDown() : Void
    {
        this._viewHelper    = null;
        this._view      	= null;
    }

	@Test( "Test 'view' property" )
	public function testGetSetView() : Void
	{
		var dispatcher = this._viewHelper.getDispatcher(); 
		var listener = new MockListener();
		dispatcher.addHandler( ViewHelperMessage.INIT, listener.init );
		dispatcher.addHandler( ViewHelperMessage.ATTACH_VIEW, listener.attach );
		dispatcher.addHandler( ViewHelperMessage.REMOVE_VIEW, listener.remove );
		dispatcher.addHandler( ViewHelperMessage.RELEASE, listener.release );
		
		//default assertions
		Assert.equals( 0, listener.initCallCount, "'initCallCount' should have not been called" );
		Assert.equals( 0, listener.attachCallCount, "'attachCallCount' should have not been called" );
		Assert.equals( 0, listener.removeCallCount, "'removeCallCount' should have not been called" );
		Assert.equals( 0, listener.releaseCallCount, "'releaseCallCount' should have not been called" );
		
		
		Assert.isNull( this._viewHelper.view, "'view' property should return null by default" );
		
		Assert.equals( 0, this._viewHelper.preInitializeCallCount, "'_preInitialize' should have not been called" );
		Assert.equals( 0, this._viewHelper.initializeCallCount, "'_initialize' should have not been called" );
		Assert.equals( 0, this._viewHelper.releaseCallCount, "'_release' should have not been called" );
		
		//setting a view
		this._viewHelper.view = this._view;
		
		//assertions after 1st view was setted
		Assert.equals( 1, listener.initCallCount, "'initCallCount' should have been called once" );
		Assert.equals( 1, listener.attachCallCount, "'attachCallCount' should have been called once" );
		Assert.equals( 0, listener.removeCallCount, "'removeCallCount' should have not been called" );
		Assert.equals( 0, listener.releaseCallCount, "'releaseCallCount' should have not been called" );
		
		Assert.equals( this._view, this._viewHelper.view, "'view' property should return setted value" );
		
		Assert.equals( 1, this._viewHelper.preInitializeCallCount, "'_preInitialize' should have been called once" );
		Assert.equals( 1, this._viewHelper.initializeCallCount, "'_initialize' should have been called once" );
		Assert.equals( 0, this._viewHelper.releaseCallCount, "'_release' should have not been called" );

		var view = new MockView();
		this._viewHelper.view = view;
		
		//assertions after 2nd view was setted
		Assert.equals( 2, listener.initCallCount, "'initCallCount' should have been called twice" );
		Assert.equals( 2, listener.attachCallCount, "'attachCallCount' should have been called twice" );
		Assert.equals( 1, listener.removeCallCount, "'removeCallCount' should have been called once" );
		Assert.equals( 0, listener.releaseCallCount, "'releaseCallCount' should have not been called" );
		
		Assert.equals( view, this._viewHelper.view, "'view' property should return new setted value" );
		Assert.equals( 1, this._viewHelper.preInitializeCallCount, "'_preInitialize' should have been called once" );
		Assert.equals( 2, this._viewHelper.initializeCallCount, "'_initialize' should have been called twice" );
		Assert.equals( 0, this._viewHelper.releaseCallCount, "'_release' should have not been called" );
	}

	@Test( "Test owner getter and setter" )
	public function testOwnerGetterAndSetter() : Void
	{
		Assert.isNull( this._viewHelper.getOwner(), "'getOwner' should return null by default" );
		
		var module = new MockModule();
		this._viewHelper.setOwner( module );
		Assert.equals( module, this._viewHelper.getOwner(), "'getOwner' should return setted value" );
		Assert.equals( module.getLogger(), this._viewHelper.getLogger(), "logger should be the same" );

		var anotherModule = new MockModule();
		this._viewHelper.setOwner( anotherModule );
		Assert.equals( anotherModule, this._viewHelper.getOwner(), "'getOwner' should return new setted value" );
		Assert.equals( anotherModule.getLogger(), this._viewHelper.getLogger(), "logger should be the same" );
	}

	@Test( "Test 'show' method" )
	public function testShow() : Void
	{
		this._viewHelper.show();
		Assert.isTrue( this._viewHelper.visible, "'show' method should set visibility to true" );
	}

	@Test( "Test 'hide' method" )
	public function testHide() : Void
	{
		this._viewHelper.hide();
		Assert.isFalse( this._viewHelper.visible, "'hide' method should set visibility to false" );
	}

	@Test( "Test 'visible' property" )
	public function testSetVisible() : Void
	{
		this._viewHelper.visible = true;
		Assert.isTrue( this._viewHelper.visible, "'visible' property should return true when it's setted to true" );

		this._viewHelper.visible = false;
		Assert.isFalse( this._viewHelper.visible, "'visible' property should return false when it's setted to false" );
	}

	@Test( "Test 'release' method" )
	public function testRelease() : Void
	{
		var dispatcher = this._viewHelper.getDispatcher(); 
		var listener = new MockListener();
		dispatcher.addHandler( ViewHelperMessage.INIT, listener.init );
		dispatcher.addHandler( ViewHelperMessage.ATTACH_VIEW, listener.attach );
		dispatcher.addHandler( ViewHelperMessage.REMOVE_VIEW, listener.remove );
		dispatcher.addHandler( ViewHelperMessage.RELEASE, listener.release );
		
		//default assertions
		Assert.equals( 0, listener.initCallCount, "'initCallCount' should have not been called" );
		Assert.equals( 0, listener.attachCallCount, "'attachCallCount' should have not been called" );
		Assert.equals( 0, listener.removeCallCount, "'removeCallCount' should have not been called" );
		Assert.equals( 0, listener.releaseCallCount, "'releaseCallCount' should have not been called" );
		
		//release
		this._viewHelper.release();
		Assert.equals( 0, listener.initCallCount, "'initCallCount' should have not been called" );
		Assert.equals( 0, listener.attachCallCount, "'attachCallCount' should have not been called" );
		Assert.equals( 0, listener.removeCallCount, "'removeCallCount' should have not been called" );
		Assert.equals( 1, listener.releaseCallCount, "'releaseCallCount' should have been once" );
		
		Assert.equals( 1, this._viewHelper.releaseCallCount, "'_release' should have been called once" );
		Assert.isNull( this._viewHelper.view, "'view' property should return null after viewHelper was released" );
		
		Assert.equals( 0, this._viewHelper.preInitializeCallCount, "'_preInitialize' should have not been called" );
		Assert.equals( 0, this._viewHelper.initializeCallCount, "'_initialize' should have not been called" );
	}
	
	@Test( "Test 'addHandler' and 'removeHandler' behaviors" )
	public function testAddAndRemoveHandler() : Void
	{
		var dispatcher = this._viewHelper.getDispatcher();
		var listener = new MockListener();
		Assert.isFalse( dispatcher.hasHandler( ViewHelperMessage.INIT, listener.init ), "internal dispatcher should not have any handler by default" );
		
		this._viewHelper.addHandler( ViewHelperMessage.INIT, listener.init );
		Assert.isTrue( dispatcher.hasHandler( ViewHelperMessage.INIT, listener.init ), "'addHandler' should add one handler to internal dispatcher" );
		
		this._viewHelper.removeHandler( ViewHelperMessage.INIT, listener.init );
		Assert.isFalse( dispatcher.hasHandler( ViewHelperMessage.INIT, listener.init ), "internal dispatcher should not have any handler left after 'removeHandler' call" );
	}
}

private class MockListener
{
	public var initCallCount 	: UInt = 0;
	public var attachCallCount 	: UInt = 0;
	public var removeCallCount 	: UInt = 0;
	public var releaseCallCount : UInt = 0;
	
	public function new()
	{
		
	}
	
	public function init() : Void
	{
		this.initCallCount++;
	}
	
	public function attach() : Void
	{
		this.attachCallCount++;
	}
	
	public function remove() : Void
	{
		this.removeCallCount++;
	}
	
	public function release() : Void
	{
		this.releaseCallCount++;
	}
}

private class MockViewHelper extends ViewHelper<MockView>
{
	public var preInitializeCallCount 	: UInt = 0;
	public var initializeCallCount 		: UInt = 0;
	public var releaseCallCount 		: UInt = 0;
	
	public function new()
	{
		super();
	}
	
	override function _preInitialize() : Void 
	{
		this.preInitializeCallCount++;
		super._preInitialize();
	}
	
	override function _initialize() : Void 
	{
		this.initializeCallCount++;
		super._initialize();
	}
	
	override function _release() : Void 
	{
		this.releaseCallCount++;
		super._release();
	}
	
	public function getDispatcher() : IClosureDispatcher
	{
		return this._internal;
	}
}

private class MockView implements IView
{
	public function new()
	{

	}

	@:isVar
	public var visible( get, set ) : Bool;

	public function get_visible() : Bool
	{
		return false;
	}

	public function set_visible( visible : Bool ) : Bool
	{
		return visible;
	}
}
