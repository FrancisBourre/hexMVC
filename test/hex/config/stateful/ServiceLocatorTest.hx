package hex.config.stateful;

import hex.error.NoSuchElementException;
import hex.event.IEvent;
import hex.event.LightweightClosureDispatcher;
import hex.MockDependencyInjector;
import hex.service.ServiceConfiguration;
import hex.service.ServiceEvent;
import hex.service.stateful.IStatefulService;
import hex.service.stateful.StatefulService;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class ServiceLocatorTest
{
	private var _serviceLocator : ServiceLocator;

    @setUp
    public function setUp() : Void
    {
        this._serviceLocator = new ServiceLocator();
    }

    @tearDown
    public function tearDown() : Void
    {
        this._serviceLocator = null;
    }
	
	@test( "Test getService with stateful service unnamed" )
    public function testGetServiceWithStatefulServiceUnnamed() : Void
    {
		var statefulService : MockStatefulService = new MockStatefulService();
		this._serviceLocator.addService( IStatefulService, statefulService );
		Assert.equals( statefulService, this._serviceLocator.getService( IStatefulService ), "'getService' should return service added previously" );
	}
	
	@test( "Test getService with stateful service named" )
    public function testGetServiceWithStatefulServiceNamed() : Void
    {
		var statefulService : MockStatefulService = new MockStatefulService();
		this._serviceLocator.addService( IStatefulService, statefulService, "myServiceName" );
		Assert.equals( statefulService, this._serviceLocator.getService( IStatefulService, "myServiceName" ), "'getService' should return service added previously" );
		Assert.methodCallThrows( NoSuchElementException, this._serviceLocator, this._serviceLocator.getService, [IStatefulService], "'getService' without service name should throw NoSuchElementException" );
	}
	
	@test( "Test configure with stateful service unnnamed" )
    public function testGetConfigureWithStatefulServiceUnnamed() : Void
    {
		var dispatcher : LightweightClosureDispatcher<IEvent> = new LightweightClosureDispatcher();
		
		var statefulService : MockStatefulService = new MockStatefulService();
		this._serviceLocator.addService( IStatefulService, statefulService );
		var injector : MockInjectorForMapToValueTest = new MockInjectorForMapToValueTest();
		this._serviceLocator.configure( injector, dispatcher, null );
		
		Assert.equals( IStatefulService, injector.clazz, "injector should map the class" );
		Assert.equals( statefulService, injector.value, "injector should map the service instance" );
		Assert.equals( "", injector.name, "injector should map the service name" );
		
		var listener : MockServiceListener = new MockServiceListener();
		dispatcher.addEventListener( "test", listener.onTest );
		var event : ServiceEvent = new ServiceEvent( "test", statefulService );
		statefulService.dispatchEvent( event );
		
		Assert.equals( event, listener.lastEventReceived, "event should be received by sub-dispatcher listener" );
		Assert.equals( 1, listener.eventReceivedCount, "event should be received by sub-dispatcher listener once" );
	}
	
	@test( "Test configure with stateful service named" )
    public function testGetConfigureWithStatefulService() : Void
    {
		var dispatcher : LightweightClosureDispatcher<IEvent> = new LightweightClosureDispatcher();
		
		var statefulService : MockStatefulService = new MockStatefulService();
		this._serviceLocator.addService( IStatefulService, statefulService, "myServiceName" );
		var injector : MockInjectorForMapToValueTest = new MockInjectorForMapToValueTest();
		this._serviceLocator.configure( injector, dispatcher, null );
		
		Assert.equals( IStatefulService, injector.clazz, "injector should map the class" );
		Assert.equals( statefulService, injector.value, "injector should map the service instance" );
		Assert.equals( "myServiceName", injector.name, "injector should map the service name" );
		
		var listener : MockServiceListener = new MockServiceListener();
		dispatcher.addEventListener( "test", listener.onTest );
		var event : ServiceEvent = new ServiceEvent( "test", statefulService );
		statefulService.dispatchEvent( event );
		
		Assert.equals( event, listener.lastEventReceived, "event should be received by sub-dispatcher listener" );
		Assert.equals( 1, listener.eventReceivedCount, "event should be received by sub-dispatcher listener once" );
	}
}

private class MockStatefulService extends StatefulService<ServiceEvent, ServiceConfiguration>
{
	public function new()
	{
		super();
	}
	
	public function dispatchEvent( e : ServiceEvent ) : Void
	{
		this._compositeDispatcher.dispatchEvent( e );
	}
}

private class MockInjectorForMapToValueTest extends MockDependencyInjector
{
	public var clazz	: Class<Dynamic>;
	public var value	: Dynamic;
	public var name		: String;
	
	override public function mapToValue( clazz : Class<Dynamic>, value : Dynamic, ?name : String = '' ) : Void 
	{
		this.clazz 	= clazz;
		this.value 	= value;
		this.name 	= name;
	}
}

private class MockServiceListener
{
	public var lastEventReceived 	: IEvent;
	public var eventReceivedCount 	: Int = 0;
	
	public function new()
	{
		
	}
	
	public function onTest( e : IEvent ) : Void
	{
		this.lastEventReceived = e;
		this.eventReceivedCount++;
	}
}