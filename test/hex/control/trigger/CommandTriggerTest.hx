package hex.control.trigger;

import hex.collection.Locator;
import hex.control.async.Nothing;
import hex.control.trigger.MockCommandClassWithParameters;
import hex.control.trigger.MockCommandClassWithoutParameters;
import hex.control.trigger.MockController;
import hex.control.trigger.mock.AnotherMockCommand;
import hex.control.trigger.mock.MockCommand;
import hex.control.trigger.mock.MockMacroCommand;
import hex.di.IDependencyInjector;
import hex.di.IInjectorListener;
import hex.di.Injector;
import hex.di.provider.IDependencyProvider;
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
class CommandTriggerTest
{
	var _injector   		: Injector;
	var _module     		: MockModule;
	var _controller 		: MockController;

    @Before
    public function setUp() : Void
    {
		this._injector 				= new Injector();
		this._module 				= new MockModule();
		this._injector.mapToValue( IDependencyInjector, this._injector );
		this._injector.mapToValue( IModule, this._module );
		
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
		MockCommandClassWithoutParameters.callCount = 0;
		
		this._controller.print();
		Assert.equals( 1, MockCommandClassWithoutParameters.callCount, "" );
	}
	
	@Async( "test controller call with mapping and parameters" )
	public function testControllerCallWithMappingAndParameters() : Void
	{
		MockCommandClassWithParameters.callCount = 0;
		
		var f = function ( message : String )
		{
			Assert.equals( 1, MockCommandClassWithParameters.callCount );
			Assert.equals( "hola mundo", message );
			Assert.equals( message, MockCommandClassWithParameters.message );
			Assert.equals( this, MockCommandClassWithParameters.test );
			Assert.isNull( MockCommandClassWithParameters.ignored, 'Last parameter should be ignored' );
		}
		
		this._controller.say( "hola mundo", this, "ignore that", new Locator<String, Bool>() ).onComplete( MethodRunner.asyncHandler( f ) );
	}
	
	@Test( "test controller call without mapping" )
	public function testControllerCallWithoutMapping() : Void
	{
		Assert.equals( 5, this._controller.sum( 2, 3 ), "" );
	}
	
	@Test( "test controller call with macro and injections" )
	public function testControllerCallWithMacroAndInjections() : Void
	{
		MockMacroCommand.command 	= null;
		MockCommand.command 		= null;
		AnotherMockCommand.command 	= null;
		
		var controller 			= new MockMacroController();
		controller.injector 	= this._injector;
		controller.module 		= this._module;
		
		var vos : Array<Dynamic> = [];
		vos[ 0 ] = 'string1';
		vos[ 1 ] = 'string2';
		vos[ 2 ] = -3;
		vos[ 3 ] = 4;
		vos[ 4 ] = 5.6;
		vos[ 5 ] = true;
		vos[ 6 ] = [ 'hello', 'world' ];
		vos[ 7 ] = [ 'hello' => 'world' ];
		vos[ 8 ] = Date.now();
		
		var result = '';
		controller.doSomething( vos[ 0 ], vos[ 1 ], vos[ 2 ], vos[ 3 ], vos[ 4 ], vos[ 5 ], vos[ 6 ], vos[ 7 ], [3, 4], vos[ 8 ] )
			.onComplete( function(r) result = r );
		
		Assert.equals( 'string2', result );
		
		var mo = MockMacroCommand.command;
		Assert.equals( vos[ 0 ], mo.pString1 );
		Assert.equals( vos[ 1 ], mo.pString2 );
		Assert.equals( vos[ 2 ], mo.pInt );
		Assert.equals( vos[ 3 ], mo.pUInt );
		Assert.equals( vos[ 4 ], mo.pFloat );
		Assert.equals( vos[ 5 ], mo.pBool );
		Assert.equals( vos[ 6 ], mo.pArray );
		Assert.equals( vos[ 7 ], mo.pStringMap );
		Assert.equals( vos[ 8 ], mo.pDate );
		
		//
		var cmd = MockCommand.command;
		Assert.equals( vos[ 0 ], cmd.pString1 );
		Assert.equals( vos[ 1 ], cmd.pString2 );
		Assert.equals( vos[ 2 ], cmd.pInt );
		Assert.equals( vos[ 3 ], cmd.pUInt );
		Assert.equals( vos[ 4 ], cmd.pFloat );
		Assert.equals( vos[ 5 ], cmd.pBool );
		Assert.equals( vos[ 6 ], cmd.pArray );
		Assert.equals( vos[ 7 ], cmd.pStringMap );
		Assert.equals( vos[ 8 ], cmd.pDate );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( vos[ 0 ], acmd.pString1 );
		Assert.equals( vos[ 1 ], acmd.pString2 );
		Assert.equals( vos[ 2 ], acmd.pInt );
		Assert.equals( vos[ 3 ], acmd.pUInt );
		Assert.equals( vos[ 4 ], acmd.pFloat );
		Assert.equals( vos[ 5 ], acmd.pBool );
		Assert.equals( vos[ 6 ], acmd.pArray );
		Assert.equals( vos[ 7 ], acmd.pStringMap );
		Assert.equals( vos[ 8 ], acmd.pDate );
	}
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
	
	public function getInjector() : IDependencyInjector
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
	
	public function getInstanceWithClassName<T>( className : String, name : String = '' ) : T
	{
		return null;
	}
	
	public function getOrCreateNewInstance<T>( type : Class<Dynamic> ) : T 
	{
		return Type.createInstance( type, [] );
	}
	
	public function instantiateUnmapped<T>( type : Class<Dynamic> ) : T 
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

	public function addListener( listener : IInjectorListener ) : Bool
	{
		return false;
	}

	public function removeListener( listener : IInjectorListener ) : Bool
	{
		return false;
	}
	
	public function getProvider( className : String, name : String = '' ) : IDependencyProvider
	{
		return null;
	}
	
	public function mapClassNameToValue( className : String, value : Dynamic, ?name : String = '' ) : Void
	{
		
	}

    public function mapClassNameToType( className : String, type : Class<Dynamic>, name:String = '' ) : Void
	{
		
	}

    public function mapClassNameToSingleton( className : String, type : Class<Dynamic>, name:String = '' ) : Void
	{
		
	}
	
	public function unmapClassName( className : String, name : String = '' ) : Void
	{
		
	}
}