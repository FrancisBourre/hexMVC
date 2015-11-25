package hex.viewhelper;

import hex.MockDependencyInjector;
import hex.module.IModule;
import hex.unittest.assertion.Assert;
import hex.view.IView;
import hex.view.viewhelper.IMainViewHelperManagerListener;
import hex.view.viewhelper.IViewHelper;
import hex.view.viewhelper.IViewHelperManagerListener;
import hex.view.viewhelper.MainViewHelperManagerEvent;
import hex.view.viewhelper.ViewHelper;
import hex.view.viewhelper.ViewHelperManager;
import hex.view.viewhelper.ViewHelperManagerEvent;
import hex.module.MockModule;

/**
 * ...
 * @author Francis Bourre
 */
class ViewHelperManagerTest
{
	@test( "test getInstance" )
	public function testGetInstance() : Void 
	{
		var listener : MainViewHelperManagerListener = new MainViewHelperManagerListener();
		ViewHelperManager.addGlobalListener( listener );
		
		var module : IModule = new MockModule();
		var viewHelperManager : ViewHelperManager = ViewHelperManager.getInstance( module );
		Assert.failIsNull( viewHelperManager, "viewHelperManager shouldn't be null" );
		Assert.assertEquals( 1, listener.onViewHelperManagerCreationCallbackCount, "creation event should be dispatched once" );
		Assert.assertIsType( listener.lastMainViewHelperManagerEvent, MainViewHelperManagerEvent, "event received should be an instance of MainViewHelperManagerEvent" );
		Assert.assertEquals( viewHelperManager, listener.lastMainViewHelperManagerEvent.getviewHelperManager(), "viewHelperManager should be the same" );
		
		Assert.assertEquals( viewHelperManager, ViewHelperManager.getInstance( module ), "viewHelperManager should be the same" );
		Assert.assertEquals( 1, listener.onViewHelperManagerCreationCallbackCount, "creation event shouldn't be dispatched again" );
		
		Assert.assertEquals( module, viewHelperManager.getOwner(), "owner should be the same" );
	}
	
	@test( "test release" )
	public function testRelease() : Void 
	{
		var listener : MainViewHelperManagerListener = new MainViewHelperManagerListener();
		ViewHelperManager.addGlobalListener( listener );
		
		var module : IModule = new MockModule();
		var viewHelperManager : ViewHelperManager = ViewHelperManager.getInstance( module );
		var viewHelper : IViewHelper = viewHelperManager.buildViewHelper( new MockDependencyInjector(), ViewHelper, new MockView() );
		Assert.assertEquals( 1, viewHelperManager.size(), "size should return 1" );
		ViewHelperManager.release( module );
		Assert.assertEquals( 0, viewHelperManager.size(), "size should return 0" );
		
		Assert.assertEquals( 1, listener.onViewHelperManagerReleaseCallbackCount, "release event should be dispatched once" );
		Assert.assertIsType( listener.lastMainViewHelperManagerEvent, MainViewHelperManagerEvent, "event received should be an instance of MainViewHelperManagerEvent" );
		Assert.assertEquals( viewHelperManager, listener.lastMainViewHelperManagerEvent.getviewHelperManager(), "viewHelperManager should be the same" );
		
		ViewHelperManager.release( module );
		Assert.assertEquals( 1, listener.onViewHelperManagerReleaseCallbackCount, "release event shouldn't be dispatched again" );
		Assert.assertEquals( 0, viewHelperManager.size(), "size should return 0" );
	}
	
	@test( "test buildViewHelper" )
	public function testBuildViewHelper() : Void 
	{
		var listener : ViewHelperManagerListener = new ViewHelperManagerListener();
		
		var module : IModule = new MockModule();
		var viewHelperManager : ViewHelperManager = ViewHelperManager.getInstance( module );
		
		viewHelperManager.addListener( listener );
		
		var viewHelper : IViewHelper = viewHelperManager.buildViewHelper( new MockDependencyInjector(), ViewHelper, new MockView() );
		Assert.failIsNull( viewHelper, "viewHelper shouldn't be null" );
		Assert.assertIsType( viewHelper, ViewHelper, "viewHelper should be an instance of ViewHelper" );
		Assert.assertEquals( module, viewHelper.getOwner(), "owner should be the same" );
		
		Assert.assertEquals( 1, viewHelperManager.size(), "size should return 1" );
		
		Assert.assertEquals( 1, listener.onViewHelperCreationCallbackCount, "creation event should be dispatched once" );
		Assert.assertIsType( listener.lastViewHelperManagerEvent,ViewHelperManagerEvent, "event received should be an instance of ViewHelperManagerEvent" );
		Assert.assertEquals( viewHelperManager, listener.lastViewHelperManagerEvent.getViewHelperManager(), "viewHelperManager should be the same" );
		Assert.assertEquals( viewHelper, listener.lastViewHelperManagerEvent.getViewHelper(), "viewHelper should be the same" );
		
		var anotherViewHelper : IViewHelper = viewHelperManager.buildViewHelper( new MockDependencyInjector(), ViewHelper, new MockView() );
		Assert.failIsNull( anotherViewHelper, "viewHelper shouldn't be null" );
		Assert.assertIsType( anotherViewHelper, ViewHelper, "viewHelper should be an instance of ViewHelper" );
		Assert.assertEquals( module, anotherViewHelper.getOwner(), "owner should be the same" );
		
		Assert.assertEquals( 2, viewHelperManager.size(), "size should return 2" );
		
		Assert.assertEquals( 2, listener.onViewHelperCreationCallbackCount, "creation event should be dispatched once" );
		Assert.assertIsType( listener.lastViewHelperManagerEvent,ViewHelperManagerEvent, "event received should be an instance of ViewHelperManagerEvent" );
		Assert.assertEquals( viewHelperManager, listener.lastViewHelperManagerEvent.getViewHelperManager(), "viewHelperManager should be the same" );
		Assert.assertEquals( anotherViewHelper, listener.lastViewHelperManagerEvent.getViewHelper(), "viewHelper should be the same" );
		
		Assert.failEquals( viewHelper, anotherViewHelper, "viewHelpers shouldn't be the same" );
		
		viewHelper.release();
		Assert.assertEquals( 1, viewHelperManager.size(), "size should return 1" );
		
		Assert.assertEquals( 1, listener.onViewHelperReleaseCallbackCount, "release event should be dispatched once" );
		Assert.assertIsType( listener.lastViewHelperManagerEvent,ViewHelperManagerEvent, "event received should be an instance of ViewHelperManagerEvent" );
		Assert.assertEquals( viewHelperManager, listener.lastViewHelperManagerEvent.getViewHelperManager(), "viewHelperManager should be the same" );
		Assert.assertEquals( viewHelper, listener.lastViewHelperManagerEvent.getViewHelper(), "viewHelper should be the same" );
		
		anotherViewHelper.release();
		Assert.assertEquals( 0, viewHelperManager.size(), "size should return 0" );
		
		Assert.assertEquals( 2, listener.onViewHelperReleaseCallbackCount, "release event should be dispatched one more time" );
		Assert.assertIsType( listener.lastViewHelperManagerEvent,ViewHelperManagerEvent, "event received should be an instance of ViewHelperManagerEvent" );
		Assert.assertEquals( viewHelperManager, listener.lastViewHelperManagerEvent.getViewHelperManager(), "viewHelperManager should be the same" );
		Assert.assertEquals( anotherViewHelper, listener.lastViewHelperManagerEvent.getViewHelper(), "viewHelper should be the same" );
	}
	
	@test( "test releaseViewHelper" )
	public function testReleaseViewHelpers() : Void 
	{
		var listener : ViewHelperManagerListener = new ViewHelperManagerListener();
		
		var module : IModule = new MockModule();
		var viewHelperManager : ViewHelperManager = ViewHelperManager.getInstance( module );
		
		viewHelperManager.addListener( listener );
		var viewHelper : IViewHelper = viewHelperManager.buildViewHelper( new MockDependencyInjector(), ViewHelper, new MockView() );
		var anotherViewHelper : IViewHelper = viewHelperManager.buildViewHelper( new MockDependencyInjector(), ViewHelper, new MockView() );
		
		viewHelperManager.releaseAllViewHelpers();
		
		Assert.assertEquals( 0, viewHelperManager.size(), "size should return 0" );
		
		Assert.assertEquals( 2, listener.onViewHelperReleaseCallbackCount, "release event should be dispatched one more time" );
		Assert.assertIsType( listener.lastViewHelperManagerEvent,ViewHelperManagerEvent, "event received should be an instance of ViewHelperManagerEvent" );
		Assert.assertEquals( viewHelperManager, listener.lastViewHelperManagerEvent.getViewHelperManager(), "viewHelperManager should be the same" );
		Assert.assertEquals( viewHelper, listener.lastViewHelperManagerEvent.getViewHelper(), "viewHelper should be the same" );
	}
}

private class ViewHelperManagerListener implements IViewHelperManagerListener
{
	public var onViewHelperCreationCallbackCount 	: Int;
	public var onViewHelperReleaseCallbackCount 	: Int;
	
	public var lastViewHelperManagerEvent 			: ViewHelperManagerEvent;
	
	public function new()
	{
		this.onViewHelperCreationCallbackCount 	= 0;
		this.onViewHelperReleaseCallbackCount 	= 0;
	}
	
	public function onViewHelperCreation( event : ViewHelperManagerEvent ) : Void 
	{
		this.onViewHelperCreationCallbackCount++;
		this.lastViewHelperManagerEvent = event;
	}
	
	public function onViewHelperRelease( event : ViewHelperManagerEvent ) : Void 
	{
		this.onViewHelperReleaseCallbackCount++;
		this.lastViewHelperManagerEvent = event;
	}
}

private class MainViewHelperManagerListener implements IMainViewHelperManagerListener
{
	public var onViewHelperManagerCreationCallbackCount : Int;
	public var onViewHelperManagerReleaseCallbackCount 	: Int;
	
	public var lastMainViewHelperManagerEvent 			: MainViewHelperManagerEvent;
	
	public function new()
	{
		this.onViewHelperManagerCreationCallbackCount 	= 0;
		this.onViewHelperManagerReleaseCallbackCount 	= 0;
	}

	public function onViewHelperManagerCreation( event : MainViewHelperManagerEvent ) : Void 
	{
		this.onViewHelperManagerCreationCallbackCount++;
		this.lastMainViewHelperManagerEvent = event;
	}
	
	public function onViewHelperManagerRelease( event : MainViewHelperManagerEvent ) : Void 
	{
		this.onViewHelperManagerReleaseCallbackCount++;
		this.lastMainViewHelperManagerEvent = event;
	}
}

private class MockView implements IView
{
	public function new()
	{
		
	}

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