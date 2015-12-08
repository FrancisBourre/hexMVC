package hex.service.stateful;

import haxe.Constraints.Function;
import haxe.Timer;
import hex.error.IllegalStateException;
import hex.service.ServiceConfiguration;
import hex.service.stateful.StatefulService;
import hex.unittest.assertion.Assert;
import hex.unittest.runner.MethodRunner;
import hex.service.ServiceEvent;

/**
 * ...
 * @author duke
 */
class StatefulServiceTest
{
	public var service : MockStatefulService;
	
	@setUp
    public function setUp() : Void
    {
        this.service = new MockStatefulService();
    }

    @tearDown
    public function tearDown() : Void
    {
        this.service = null;
    }

	@test( "Test 'setConfiguration' method" )
    public function testSetConfiguration() : Void
    {
		var dummyConfig : ServiceConfiguration = new ServiceConfiguration();
		this.service.setConfiguration( dummyConfig );
		
		Assert.equals( dummyConfig, this.service.getConfiguration(), "setted configuration should be returned" );
		
		this.service.run();
		Assert.methodCallThrows( IllegalStateException, this.service, this.service.setConfiguration, [ dummyConfig ], "StatefulService should throw IllegalStateException when calling setConfiguration when in use" );
		
		this.service.stop();
		
		Assert.equals( dummyConfig, this.service.getConfiguration(), "should be able to call setConfiguration after _release called" );
	}
	
	@test( "Test 'lock' and 'release' behavion" )
    public function testLockAndRelease() : Void
    {
		Assert.isFalse( this.service.inUse, "the inUse property should be false by default" );
		
		this.service.run();
		
		Assert.isTrue( this.service.inUse, "the inUse property should be true after _lock called" );
		
		this.service.stop();
		
		Assert.isFalse( this.service.inUse, "the inUse property should be false after _release called" );
	}
	
	@test( "event subscription" )
    public function testAddAndRemoveHandler() : Void
	{
		var event:MockEvent = new MockEvent(MockEvent.ON_SAMPLE, this);
		
		//var callback:Dynamic =  MethodRunner.asyncHandler( this._mockAddEventHandler, [event] );
		
		var listener:MockAsyncEventListener = new MockAsyncEventListener();
		
		this.service.addHandler(MockEvent.ON_SAMPLE, listener.onAddHandlerSuccess);
		this.service.getDispatcher().dispatchEvent(event);
		
		Assert.equals( 1, listener.addHandlerSuccessCount, "dispatch should happen after call dispatchEvent on service" );
		Assert.equals( event, listener.lastEventReceived, "dispatched event should be equal to the imput" );
		
		this.service.removeHandler(MockEvent.ON_SAMPLE, listener.onAddHandlerSuccess);
		this.service.getDispatcher().dispatchEvent( event );
		
		Assert.equals( 1, listener.addHandlerSuccessCount, "dispatch should not happen after call removeHandler" );
	}
	
}

private class MockStatefulService extends StatefulService<ServiceEvent, ServiceConfiguration>
{
	public function new() 
	{
		super();
		
	}
	
	public function run()
	{
		this._lock();
	}
	
	public function stop()
	{
		this._release();
	}
}


private class MockEvent extends ServiceEvent
{
	public static var ON_SAMPLE:String = "onSample";
	
	public function new ( eventType : String, target : Dynamic )
	{
		super( eventType, target );
	}
}

private class MockAsyncEventListener
{
	public var lastEventReceived 		: MockEvent;
	public var addHandlerSuccessCount 	: Int = 0;
	
	public function new()
	{
		
	}
	
	
	public function onAddHandlerSuccess( e : ServiceEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.addHandlerSuccessCount++;
	}
}