package hex.control.controller;

import haxe.Timer;
import hex.control.controller.Controller;
import hex.control.controller.IController;
import hex.di.IBasicInjector;
import hex.di.IDependencyInjector;
import hex.di.InjectionEvent;
import hex.domain.Domain;
import hex.event.MessageType;
import hex.log.ILogger;
import hex.module.IModule;
import hex.unittest.assertion.Assert;
import hex.unittest.runner.MethodRunner;

/**
 * ...
 * @author Francis Bourre
 */
class ControllerTest
{
	var _injector   		: MockDependencyInjector;
	var _module     		: MockModule;
	var _controller 		: MockController;

    @Before
    public function setUp() : Void
    {
		this._injector 				= new MockDependencyInjector();
		this._module 				= new MockModule();
        this._controller 			= new MockController();
		this._controller.injector 	= this._injector;
		this._controller.module 	= this._module;
    }

    @After
    public function tearDown() : Void
    {
		this._injector 			= null;
		this._module 			= null;
        this._controller 		= null;
    }
	
	@Test( "test controller call with mapping and without parameters" )
	public function testControllerCallWithMappingAndWithoutParameters() : Void
	{
		MockOrderClassWithoutParameters.callCount = 0;
		
		this._controller.print();
		Assert.equals( 1, MockOrderClassWithoutParameters.callCount, "" );
	}
	
	@Async( "test controller call with mapping and parameters" )
	public function testControllerCallWithMappingAndParameters() : Void
	{
		MockOrderClassWithoutParameters.callCount = 0;
		this._controller.say( "hola mundo", this ).onComplete( MethodRunner.asyncHandler( this._onTestComplete ) );
	}
	
	function _onTestComplete( message : String ) : Void
	{
		Assert.equals( 1, MockOrderClassWithParameters.callCount, "" );
		Assert.equals( "hola mundo", message, "" );
		Assert.equals( this, MockOrderClassWithParameters.sender, "" );
	}
	
	@Test( "test controller call without mapping" )
	public function testControllerCallWithoutMapping() : Void
	{
		Assert.equals( 5, this._controller.sum( 2, 3 ), "" );
	}
}

private class MockController extends Controller implements IMockController
{
	public function new()
	{
		super();
	}
	
	@Class( "hex.control.controller.MockOrderClassWithoutParameters" )
	public function print() : ICompletable<Void> { }
	
	@Class( "hex.control.controller.MockOrderClassWithParameters" )
	public function say( text : String, sender : ControllerTest ) : ICompletable<String> { }

	public function sum( a : Int, b : Int ) : Int 
	{ 
		return a + b;
	}
}

private interface IMockController extends IController
{
	function print() : ICompletable<Void>;
	function say( text : String, sender : ControllerTest ) : ICompletable<String>;
	function sum( a : Int, b : Int ) : Int ;
}

private class MockModule implements IModule
{
	public function new()
	{
		
	}
	
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
	
	public function dispatchPublicMessage( messageType : MessageType, ?data : Array<Dynamic> ) : Void
	{
		
	}
	
	public function addHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void
	{
		
	}
	
	public function removeHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void
	{
		
	}
	
	public function getDomain() : Domain 
	{
		return null;
	}
	
	public function getBasicInjector() : IBasicInjector
	{
		return null;
	}
	
	public function getLogger() : ILogger
	{
		return null;
	}
}

private class MockDependencyInjector implements IDependencyInjector
{
	public function new()
	{
		
	}
	
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
	
	public function getInstance<T>( type : Class<T>, name : String = '' ) : T 
	{
		return null;
	}
	
	public function getOrCreateNewInstance<T>( type : Class<Dynamic> ) : T 
	{
		return Type.createInstance( type, [] );
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

	public function addEventListener( eventType : String, callback : InjectionEvent->Void ) : Bool
	{
		return false;
	}

	public function removeEventListener( eventType : String, callback : InjectionEvent->Void ) : Bool
	{
		return false;
	}
}