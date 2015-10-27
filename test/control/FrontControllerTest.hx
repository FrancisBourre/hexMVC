package control;

import hex.control.FrontController;
import hex.control.ICommand;
import hex.control.ICommandMapping;
import hex.di.IDependencyInjector;
import hex.event.BasicEvent;
import hex.event.EventDispatcher;
import hex.event.IEvent;
import hex.event.IEventDispatcher;
import hex.event.IEventListener;
import hex.module.IModule;
import hex.module.Module;
import hex.module.ModuleEvent;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class FrontControllerTest
{
	private var _dispatcher 		: IEventDispatcher<IEventListener, IEvent>;
    private var _injector   		: MockDependencyInjector;
	private var _module     		: MockModule;
	
	private var _frontcontroller 	: FrontController;

    @setUp
    public function setUp() : Void
    {
		this._dispatcher 		= new EventDispatcher<IEventListener, IEvent>();
		this._injector 			= new MockDependencyInjector();
		this._module 			= new MockModule();
        this._frontcontroller 	= new FrontController( this._dispatcher, this._injector, this._module );
    }

    @tearDown
    public function tearDown() : Void
    {
        this._frontcontroller = null;
    }
	
	@test( "Test map" )
    public function testMap() : Void
    {
		Assert.failTrue( this._dispatcher.hasEventListener( "eventType" ), "event type should not be listened" );
		
		var commandMapping : ICommandMapping = this._frontcontroller.map( "eventType", MockCommand );
		Assert.assertEquals( MockCommand, commandMapping.getCommandClass(), "Command class should be the same" );
		Assert.assertTrue( this._frontcontroller.isRegisteredWithKey( "eventType" ), "event type should be registered" );
		Assert.assertEquals( commandMapping, this._frontcontroller.locate( "eventType" ), "command mapping should be associated to event type" );
		
		Assert.assertTrue( this._dispatcher.hasEventListener( "eventType" ), "event type should be listened" );
    }
	
	@test( "Test unmap" )
    public function testUnmap() : Void
    {
		var commandMapping0 : ICommandMapping = this._frontcontroller.map( "eventType", MockCommand );
		var commandMapping1 : ICommandMapping = this._frontcontroller.unmap( "eventType" );
		
		Assert.assertEquals( commandMapping0, commandMapping1, "Command mappings should be the same" );
		Assert.failTrue( this._frontcontroller.isRegisteredWithKey( "eventType" ), "event type should not be registered anymore" );
		Assert.failTrue( this._dispatcher.hasEventListener( "eventType" ), "event type should not be listened anymore" );
    }
	
	@test( "Functional test of event handling" )
    public function testEventHandling() : Void
    {
		this._frontcontroller.map( "eventType", MockCommand );
		
		var event : BasicEvent = new BasicEvent( "eventType", this._module );
		this._dispatcher.dispatchEvent( event );
		
		Assert.assertEquals( 1, MockCommand.executeCallCount, "Command execution should happenned once" );
		Assert.assertEquals( event, MockCommand.executeEventCallParameter, "event received by the command should be the same that was dispatched" );
		
		var anotherEvent : BasicEvent = new BasicEvent( "anotherEventType", this._module );
		this._dispatcher.dispatchEvent( anotherEvent );
		
		Assert.assertEquals( 1, MockCommand.executeCallCount, "Command execution should happenned once" );
		Assert.assertEquals( event, MockCommand.executeEventCallParameter, "event received by the command should be the same that was dispatched" );
		
		this._frontcontroller.map( "anotherEventType", MockCommand );
		this._dispatcher.dispatchEvent( anotherEvent );
		
		Assert.assertEquals( 2, MockCommand.executeCallCount, "Command execution should happenned twice" );
		Assert.assertEquals( anotherEvent, MockCommand.executeEventCallParameter, "event received by the command should be the same that was dispatched" );
	}
	
}

private class MockCommand implements ICommand
{
	public static var executeCallCount 				: Int = 0;
	public static var executeEventCallParameter 	: IEvent;
	
	public function new()
	{
		
	}
	
	/* INTERFACE hex.control.ICommand */
	
	public function execute( ?e : IEvent ) : Void 
	{
		MockCommand.executeCallCount++;
		MockCommand.executeEventCallParameter = e;
	}
	
	public function getPayload() : Array<Dynamic> 
	{
		return null;
	}
	
	public function getOwner() : IModule 
	{
		return null;
	}
	
	public function setOwner( owner : IModule ) : Void 
	{
		
	}
}

private class MockModule implements IModule
{
	public function new()
	{
		
	}
	
	/* INTERFACE hex.module.IModule */
	
	public function initialize() : Void 
	{
		
	}
	
	@:isVar public var isInitialized( get, null ) : Bool;
	function get_isInitialized() : Bool
	{
		return false;
	}
	
	public function release() : Void 
	{
		
	}

	@:isVar public var isReleased( get, null ) : Bool;
	public function get_isReleased() : Bool
	{
		return false;
	}
	
	public function sendExternalEventFromDomain( e : ModuleEvent ) : Void 
	{
		
	}
	
	public function addHandler( type : String, callback : IEvent->Void ) : Void 
	{
		
	}
	
	public function removeHandler( type : String, callback : IEvent->Void ) : Void 
	{
		
	}
}

private class MockDependencyInjector implements IDependencyInjector
{
	public function new()
	{
		
	}
	
	/* INTERFACE hex.di.IDependencyInjector */
	public function hasMapping( type : Class<Dynamic>, name : String = '' ) : Bool 
	{
		return false;
	}
	
	public function hasDirectMapping( type : Class<Dynamic>, name:String = '' ) : Bool 
	{
		return false;
	}
	
	public function satisfies( type : Class<Dynamic>, name : String = '' ) : Bool 
	{
		return false;
	}
	
	public function injectInto( target : Dynamic ) : Void 
	{
		
	}
	
	public function getInstance( type : Class<Dynamic>, name : String = '', targetType : Class<Dynamic> = null ) : Dynamic 
	{
		return null;
	}
	
	public function getOrCreateNewInstance( type : Class<Dynamic> ) : Dynamic 
	{
		return Type.createInstance( MockCommand, [] );
	}
	
	public function instantiateUnmapped( type : Class<Dynamic> ) : Dynamic 
	{
		return null;
	}
	
	public function destroyInstance( instance : Dynamic ) : Void 
	{
		
	}
	
	public function mapToValue( clazz : Class<Dynamic>, value : Dynamic, ?name : String = '' ) : Void 
	{
		
	}
	
	public function mapToType( clazz : Class<Dynamic>, type : Class<Dynamic>, name : String = '' ) : Void 
	{
		
	}
	
	public function mapToSingleton( clazz : Class<Dynamic>, type : Class<Dynamic>, name : String = '' ) : Void 
	{
		
	}
	
	public function unmap( type : Class<Dynamic>, name : String = '' ) : Void 
	{
		
	}
}