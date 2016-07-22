package hex.view.viewhelper;

import hex.module.MockModule;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Tamas Kinsztler
 */
//TODO lot of tests are missing here
class ViewHelperTest
{
	var _viewHelper : ViewHelper<MockView>;
	var _view 		: MockView;

	@Before
    public function setUp() : Void
    {
        this._viewHelper = new ViewHelper<MockView>();
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
		Assert.isNull( this._viewHelper.view, "'view' property should return null by default" );

		this._viewHelper.view = this._view;
		Assert.equals( this._view, this._viewHelper.view, "'view' property should return setted value" );

		var view = new MockView();
		this._viewHelper.view = view;
		Assert.equals( view, this._viewHelper.view, "'view' property should return new setted value" );
	}

	@Test( "Test owner getter and setter" )
	public function testOwnerGetterAndSetter() : Void
	{
		Assert.isNull( this._viewHelper.getOwner(), "'getOwner' should return null by default" );

		var module = new MockModule();
		this._viewHelper.setOwner( module );
		Assert.equals( module, this._viewHelper.getOwner(), "'getOwner' should return setted value" );

		var anotherModule = new MockModule();
		this._viewHelper.setOwner( anotherModule );
		Assert.equals( anotherModule, this._viewHelper.getOwner(), "'getOwner' should return new setted value" );
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
		this._viewHelper.release();
		Assert.isNull( this._viewHelper.view, "'view' property should return null after viewHelper was released" );
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
