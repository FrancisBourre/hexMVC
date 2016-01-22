package hex.service.stateful;

import hex.error.IllegalStateException;
import hex.event.MessageType;
import hex.service.ServiceConfiguration;
import hex.service.stateful.StatefulService;
import hex.unittest.assertion.Assert;

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
	
	@test( "Test 'lock' and 'release' behavior" )
    public function testLockAndRelease() : Void
    {
		Assert.isFalse( this.service.inUse(), "the inUse property should be false by default" );
		
		this.service.run();
		
		Assert.isTrue( this.service.inUse(), "the inUse property should be true after _lock called" );
		
		this.service.stop();
		
		Assert.isFalse( this.service.inUse(), "the inUse property should be false after _release called" );
	}
	
	@test( "Test event subscription" )
    public function testAddAndRemoveHandler() : Void
	{
		var listener : MockAsyncEventListener = new MockAsyncEventListener();
		
		this.service.addHandler( MockMessage.ON_SAMPLE, listener, listener.onAddHandlerSuccess );
		this.service.getDispatcher().dispatch( MockMessage.ON_SAMPLE, [ "test" ] );
		
		Assert.equals( 1, listener.addHandlerSuccessCount, "dispatch should happen after call dispatchEvent on service" );
		Assert.equals( "test", listener.lastDataReceived, "dispatched event should be equal to the imput" );
		
		this.service.removeHandler( MockMessage.ON_SAMPLE, listener, listener.onAddHandlerSuccess );
		this.service.getDispatcher().dispatch( MockMessage.ON_SAMPLE, [ "test" ] );
		
		Assert.equals( 1, listener.addHandlerSuccessCount, "dispatch should not happen after call removeHandler" );
	}
	
	@test( "Test removeAllListeners" )
    public function testRemoveAllListeners() : Void
	{
		var listener : MockAsyncEventListener = new MockAsyncEventListener();
		
		this.service.addHandler( MockMessage.ON_SAMPLE, listener, listener.onAddHandlerSuccess );
		this.service.getDispatcher().dispatch( MockMessage.ON_SAMPLE, [ "test" ] );
		
		Assert.equals( 1, listener.addHandlerSuccessCount, "dispatch should happen after call dispatchEvent on service" );
		Assert.equals( "test", listener.lastDataReceived, "dispatched event should be equal to the imput" );
		
		this.service.removeAllListeners( );
		this.service.getDispatcher().dispatch( MockMessage.ON_SAMPLE, [ "test" ] );
		
		Assert.equals( 1, listener.addHandlerSuccessCount, "dispatch should not happen after call removeAllListeners" );
	}
	
}

private class MockStatefulService extends StatefulService<ServiceConfiguration>
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


private class MockMessage
{
	public static var ON_SAMPLE : MessageType = new MessageType( "onSample" );
	
	private function new ()
	{

	}
}

private class MockAsyncEventListener
{
	public var lastDataReceived 		: String;
	public var addHandlerSuccessCount 	: Int = 0;
	
	public function new()
	{
		
	}
	
	
	public function onAddHandlerSuccess( data : String ) : Void 
	{
		this.lastDataReceived = data;
		this.addHandlerSuccessCount++;
	}
}