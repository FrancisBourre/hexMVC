package hex.config.stateful;

import hex.error.IllegalArgumentException;
import hex.error.NoSuchElementException;
import hex.event.Dispatcher;
import hex.event.MessageType;
import hex.MockDependencyInjector;
import hex.service.ServiceConfiguration;
import hex.service.stateful.IStatefulService;
import hex.service.stateful.StatefulService;
import hex.service.stateless.IStatelessService;
import hex.service.stateless.MockStatelessService;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class ServiceLocatorTest
{
	var _serviceLocator : ServiceLocator;

    @Before
    public function setUp() : Void
    {
        this._serviceLocator = new ServiceLocator();
    }

    @After
    public function tearDown() : Void
    {
        this._serviceLocator = null;
    }
	
	@Test( "Test configure with instance of not a stateful service" )
    public function testConfigureWithInstanceOfNotAStatefulService() : Void
    {
		this._serviceLocator.addService( IStatelessService, new MockStatelessService(), "myServiceName" );
		var injector : MockInjectorForMapToTypeTest = new MockInjectorForMapToTypeTest();
		Assert.methodCallThrows( IllegalArgumentException, this._serviceLocator, this._serviceLocator.configure, [ injector, null, null ], "'getService' should throw IllegalArgumentException" );
	}
	
	@Test( "Test getService with stateless service unnamed" )
    public function testGetServiceWithStatelessServiceUnnamed() : Void
    {
		this._serviceLocator.addService( IStatelessService, MockStatelessService );
		Assert.isInstanceOf( this._serviceLocator.getService( IStatelessService ), MockStatelessService, "'getService' should return an instance of 'MockStatelessService'" );
	}
	
	@Test( "Test getService with stateless service named" )
    public function testGetServiceWithStatelessServiceNamed() : Void
    {
		this._serviceLocator.addService( IStatelessService, MockStatelessService, "myServiceName" );
		Assert.isInstanceOf( this._serviceLocator.getService( IStatelessService, "myServiceName" ), MockStatelessService, "'getService' should return instance of 'MockStatelessService'" );
		Assert.methodCallThrows( NoSuchElementException, this._serviceLocator, this._serviceLocator.getService, [IStatelessService], "'getService' without service name should throw NoSuchElementException" );
	}
	
	@Test( "Test configure with stateless service unnnamed" )
    public function testConfigureWithStatelessServiceUnnamed() : Void
    {
		this._serviceLocator.addService( IStatelessService, MockStatelessService );
		var injector : MockInjectorForMapToTypeTest = new MockInjectorForMapToTypeTest();
		this._serviceLocator.configure( injector, null, null );
		
		Assert.equals( IStatelessService, injector.clazz, "injector should map the class" );
		Assert.equals( injector.type, MockStatelessService, "injector should map the service instance" );
		Assert.equals( "", injector.name, "injector should map the service name" );
	}
	
	@Test( "Test configure with stateless service named" )
    public function testConfigureWithStatelessServiceNamed() : Void
    {
		this._serviceLocator.addService( IStatelessService, MockStatelessService, "myServiceName" );
		var injector : MockInjectorForMapToTypeTest = new MockInjectorForMapToTypeTest();
		this._serviceLocator.configure( injector, null, null );
		
		Assert.equals( IStatelessService, injector.clazz, "injector should map the service class" );
		Assert.equals( injector.type, MockStatelessService, "injector should map the service type" );
		Assert.equals( "myServiceName", injector.name, "injector should map the service name" );
	}
	
	@Test( "Test getService with stateful service unnamed" )
    public function testGetServiceWithStatefulServiceUnnamed() : Void
    {
		var statefulService : MockStatefulService = new MockStatefulService();
		this._serviceLocator.addService( IStatefulService, statefulService );
		Assert.equals( statefulService, this._serviceLocator.getService( IStatefulService ), "'getService' should return service added previously" );
	}
	
	@Test( "Test getService with stateful service named" )
    public function testGetServiceWithStatefulServiceNamed() : Void
    {
		var statefulService : MockStatefulService = new MockStatefulService();
		this._serviceLocator.addService( IStatefulService, statefulService, "myServiceName" );
		Assert.equals( statefulService, this._serviceLocator.getService( IStatefulService, "myServiceName" ), "'getService' should return service added previously" );
		Assert.methodCallThrows( NoSuchElementException, this._serviceLocator, this._serviceLocator.getService, [IStatefulService], "'getService' without service name should throw NoSuchElementException" );
	}
	
	@Test( "Test configure with stateful service unnnamed" )
    public function testConfigureWithStatefulServiceUnnamed() : Void
    {
		var dispatcher : Dispatcher<{}> = new Dispatcher();
		
		var statefulService : MockStatefulService = new MockStatefulService();
		this._serviceLocator.addService( IStatefulService, statefulService );
		var injector : MockInjectorForMapToValueTest = new MockInjectorForMapToValueTest();
		this._serviceLocator.configure( injector, dispatcher, null );
		
		Assert.equals( IStatefulService, injector.clazz, "injector should map the class" );
		Assert.equals( statefulService, injector.value, "injector should map the service instance" );
		Assert.equals( "", injector.name, "injector should map the service name" );
		
		var mt : MessageType = new MessageType( "test" );
		var listener : MockServiceListener = new MockServiceListener();
		dispatcher.addHandler( mt, listener, listener.onTest );
		//var event : ServiceEvent = new ServiceEvent( "test", statefulService );
		statefulService.dispatch( mt, [statefulService] );
		
		Assert.equals( statefulService, listener.lastDataReceived, "event should be received by sub-dispatcher listener" );
		Assert.equals( 1, listener.eventReceivedCount, "event should be received by sub-dispatcher listener once" );
	}
	
	@Test( "Test configure with stateful service named" )
    public function testConfigureWithStatefulServiceNamed() : Void
    {
		var dispatcher : Dispatcher<{}> = new Dispatcher();
		
		var statefulService : MockStatefulService = new MockStatefulService();
		this._serviceLocator.addService( IStatefulService, statefulService, "myServiceName" );
		var injector : MockInjectorForMapToValueTest = new MockInjectorForMapToValueTest();
		this._serviceLocator.configure( injector, dispatcher, null );
		
		Assert.equals( IStatefulService, injector.clazz, "injector should map the class" );
		Assert.equals( statefulService, injector.value, "injector should map the service instance" );
		Assert.equals( "myServiceName", injector.name, "injector should map the service name" );
		
		var mt : MessageType = new MessageType( "test" );
		var listener : MockServiceListener = new MockServiceListener();
		dispatcher.addHandler( mt, listener, listener.onTest );
		//var event : ServiceEvent = new ServiceEvent( "test", statefulService );
		statefulService.dispatch( mt, [statefulService] );
		
		Assert.equals( statefulService, listener.lastDataReceived, "event should be received by sub-dispatcher listener" );
		Assert.equals( 1, listener.eventReceivedCount, "event should be received by sub-dispatcher listener once" );
	}
}

private class MockStatefulService extends StatefulService<ServiceConfiguration>
{
	public function new()
	{
		super();
	}
	
	public function dispatch( messageType : MessageType, data : Array<Dynamic> ) : Void
	{
		this._compositeDispatcher.dispatch( messageType, data );
	}
}

private class MockInjectorForMapToTypeTest extends MockDependencyInjector
{
	public var clazz	: Class<Dynamic>;
	public var type		: Class<Dynamic>;
	public var name		: String;
	
	override public function mapToType( clazz : Class<Dynamic>, type : Class<Dynamic>, name : String = '' ) : Void 
	{
		this.clazz 	= clazz;
		this.type 	= type;
		this.name 	= name;
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
	public var lastDataReceived 	: MockStatefulService;
	public var eventReceivedCount 	: Int = 0;
	
	public function new()
	{
		
	}
	
	public function onTest( service : MockStatefulService ) : Void
	{
		this.lastDataReceived = service;
		this.eventReceivedCount++;
	}
}