package hex.config.stateful;

import hex.control.command.BasicCommand;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.control.IFrontController;
import hex.di.IDependencyInjector;
import hex.event.Dispatcher;
import hex.event.MessageType;
import hex.inject.errors.InjectorMissingMappingError;
import hex.MockDependencyInjector;
import hex.module.MockModule;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class StatefulCommandConfigTest
{

	@Test( "Test 'configure' throws 'InjectorMissingMappingError'" )
    public function testConfigureThrowsInjectorMissingMappingError() : Void
    {
		var config : StatefulCommandConfig = new StatefulCommandConfig();
        Assert.methodCallThrows( InjectorMissingMappingError, config, config.configure, [ new MockDependencyInjector(), new Dispatcher<{}>(), new MockModule() ], "constructor should throw IllegalArgumentException" );
    }
	
	@Test( "Test 'map' behavior" )
    public function testMapBehavior() : Void
    {
		var controller : MockFrontController = new MockFrontController();
		var injector : MockInjectorWithFrontController = new MockInjectorWithFrontController( controller );
		var config : StatefulCommandConfig = new StatefulCommandConfig();
		config.configure( injector, new Dispatcher<{}>(), new MockModule() );
		
		var messageType : MessageType = new MessageType( "test" );
		config.map( messageType, BasicCommand );
		
        Assert.deepEquals( [ messageType, BasicCommand ], controller.mapParameters, "parameters should be the same" );
    }
}

private class MockFrontController implements IFrontController
{
	public var mapParameters : Array<Dynamic>;
	
	public function new()
	{
		
	}
	
	public function map( messageType : MessageType, commandClass : Class<ICommand> ) : ICommandMapping 
	{
		this.mapParameters = [ messageType, commandClass ];
		return null;
	}
	
	public function unmap( messageType : MessageType ) : ICommandMapping
	{
		return null;
	}
}

private class MockInjectorWithFrontController implements IDependencyInjector
{
	private var _frontcontroller : IFrontController;
	
	public function new( frontcontroller : IFrontController ) 
	{
		this._frontcontroller = frontcontroller;
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
	
	public function getInstance( type : Class<Dynamic>, name : String = '', targetType : Class<Dynamic> = null ) : Dynamic 
	{
		return this._frontcontroller;
	}
	
	public function getOrCreateNewInstance( type : Class<Dynamic> ) : Dynamic 
	{
		return Type.createInstance( type, [] );
	}
	
	public function instantiateUnmapped( type : Class<Dynamic> ) : Dynamic 
	{
		return Type.createInstance( type, [] );
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