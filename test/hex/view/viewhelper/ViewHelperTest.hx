package hex.view.viewhelper;

import hex.event.MessageType;
import hex.module.MockModule;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Tamas Kinsztler
 */
class ViewHelperTest
{
		@Test( "Test get/set view methods" )
	  public function testGetSetView() : Void
	  {
	    	var viewHelper = new ViewHelper<MockView>();
        var view = new MockView();
        Assert.isNull( viewHelper.get_view(), "get_view should return null when no view set" );
        viewHelper.set_view( view );
	      Assert.equals( view, viewHelper.get_view(), "get_view should return the previously set view" );
	  }

    @Test( "Test get/set owner methods" )
	  public function testGetSetOwner() : Void
	  {
	    	var viewHelper = new ViewHelper<MockView>();
        var module = new MockModule();
        Assert.isNull( viewHelper.getOwner(), "getOwner should return null when no owner set" );
        viewHelper.setOwner( module );
	      Assert.equals( module, viewHelper.getOwner(), "getOwner should return the previously set owner" );
	  }

    @Test( "Test 'show' method" )
	  public function testShow() : Void
	  {
	    	var viewHelper = new ViewHelper<MockView>();
        viewHelper.show();
        Assert.isTrue( viewHelper.get_visible(), "show method should set visibility to true" );
	  }

    @Test( "Test 'hide' method" )
	  public function testHide() : Void
	  {
	    	var viewHelper = new ViewHelper<MockView>();
        viewHelper.hide();
        Assert.isFalse( viewHelper.get_visible(), "hide method should set visibility to false" );
	  }

    @Test( "Test 'set_visible' method" )
	  public function testSetVisible() : Void
	  {
	    	var viewHelper = new ViewHelper<MockView>();
        viewHelper.set_visible( true );
        Assert.isTrue( viewHelper.get_visible(), "set_visible method should set visibility to true" );
        viewHelper.set_visible( false );
        Assert.isFalse( viewHelper.get_visible(), "set_visible method should set visibility to false" );
	  }

    @Test( "Test 'release' method" )
	  public function testRelease() : Void
	  {
	    	var viewHelper = new ViewHelper<MockView>();
        var view = new MockView();
        Assert.isNull( viewHelper.get_view(), "get_view should return null when no view set" );
        viewHelper.set_view( view );
	      Assert.equals( view, viewHelper.get_view(), "get_view should return the previously set view" );
        viewHelper.release();
        Assert.isNull( viewHelper.get_view(), "get_view should return null when view is released" );
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
