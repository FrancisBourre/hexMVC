package hex.module;

import hex.config.stateful.IStatefulConfig;
import hex.config.stateless.IStatelessConfig;
import hex.di.Dependency;
import hex.di.IBasicInjector;
import hex.di.IDependencyInjector;
import hex.di.Injector;
import hex.di.error.MissingMappingException;
import hex.domain.DomainExpert;
import hex.error.Exception;
import hex.error.IllegalStateException;
import hex.event.MessageType;
import hex.log.ILogger;
import hex.metadata.AnnotationProvider;
import hex.metadata.IAnnotationProvider;
import hex.module.IModule;
import hex.service.IService;
import hex.service.ServiceConfiguration;
import hex.unittest.assertion.Assert;

using hex.di.util.InjectorUtil;

/**
 * ...
 * @author Francis Bourre
 */
class ContextModuleTest
{
	@Test( "Test constructor" )
	public function testconstructor() : Void
	{
		var module : MockModuleForTestingConstructor = new MockModuleForTestingConstructor();
		Assert.isInstanceOf( module.injector, Injector, "injector shouldn't be null" );
		Assert.isInstanceOf( module.annotationProvider, AnnotationProvider, "annotationProvider shouldn't be null" );
	}
	
	@Test( "Test _addStatefulConfigs protected method" )
	public function testAddStatefulConfig() : Void
	{
		var config : MockStatefulConfig = new MockStatefulConfig();
		var module : MockModuleForTestingStateFulConfig = new MockModuleForTestingStateFulConfig( config );
		
		Assert.equals( module, config.module, "module should be the same" );
		Assert.equals( module.injector, config.injector, "injector should be the same" );
	}
	
	@Test( "Test _addStatelessConfigClasses protected method" )
	public function testAddStatelessConfig() : Void
	{
		var module : MockModuleForTestingStatelessConfig = new MockModuleForTestingStatelessConfig( MockStatelessConfig );
		
		Assert.equals( 1, MockStatelessConfig.wasInstantiated, "configuration should have been instantiated once" );
		Assert.equals( 1, MockStatelessConfig.configureWasCalled, "'configure' method should have been called once" );
	}
	
	@Test( "Test getInjector behavior" )
	public function testGetInjector() : Void
	{
		var module : MockModuleForTestigInjector = new MockModuleForTestigInjector();
		Assert.isNotNull( module.getInjector(), "injector shouldn't be null" );
	}
	
	@Test( "Test initialize" )
	public function testInitialize() : Void
	{
		var module : MockModuleForTestingInitialisation = new MockModuleForTestingInitialisation();

		module.initialize();
		Assert.equals( 1, module.initialisationCallCount, "initialise should have been called once" );
		Assert.isTrue( module.isInitialized, "'isInitialized' should return true" );
		
		Assert.isInstanceOf( module.getLogger(), ILogger,  "logger should not be null" );
		
		Assert.methodCallThrows( IllegalStateException, module, module.initialize, [], "'initialize' called twice should throw 'IllegalStateException'" );
		Assert.equals( 1, module.initialisationCallCount, "initialise should have been called once" );
	}
	
	@Test( "Test release" )
	public function testRelease() : Void
	{
		var module : MockModuleForTestingRelease = new MockModuleForTestingRelease();

		module.release();
		Assert.equals( 1, module.releaseCallCount, "release should have been called once" );
		Assert.isTrue( module.isReleased, "'isReleased' should return true" );
		
		Assert.isNull( DomainExpert.getInstance().getDomainFor( module ), "domain should be null" );
		Assert.isNull( module.getLogger(), "logger should be null" );
		
		Assert.methodCallThrows( IllegalStateException, module, module.release, [], "'release' called twice should throw 'IllegalStateException'" );
	}
	
	@Test( "Test get accessor" )
	public function testGetAccessor() : Void
	{
		var module : MockModuleForTestigInjector = new MockModuleForTestigInjector();
		module.getInjector().mapToValue( ContextModuleTest, this );
		Assert.equals ( this, module.get( ContextModuleTest ), "'_get' method call should return mapping result from internal module's injector" );
		Assert.methodCallThrows ( MissingMappingException, module, module.get, [ Exception ], "_get' method call should throw 'MissingMappingException' when the mapping is missing" );
	}
	
	@Test( "Test get accessor with name" )
	public function testGetAccessorWithName() : Void
	{
		var module : MockModuleForTestigInjector = new MockModuleForTestigInjector();
		module.getInjector().mapToValue( ContextModuleTest, this, 'name' );
		Assert.equals ( this, module.get( ContextModuleTest, 'name' ), "'_get' method call should return mapping result from internal module's injector" );
		Assert.methodCallThrows ( MissingMappingException, module, module.get, [ ContextModuleTest ], "_get' method call should throw 'MissingMappingException' when the mapping is missing" );
	}
	
	@Test( "Test map" )
	public function testMap() : Void
	{
		var module : MockModuleForTestigInjector = new MockModuleForTestigInjector();
		module.map( IMockInterface, MockClass );
		Assert.isInstanceOf ( module.get( IMockInterface ), MockClass );
	}
	
	@Test( "Test map with name" )
	public function testMapWithName() : Void
	{
		var module : MockModuleForTestigInjector = new MockModuleForTestigInjector();
		module.map( IMockInterface, MockClass, 'name' );
		Assert.isInstanceOf ( module.get( IMockInterface, 'name' ), MockClass );
	}
	
	@Test( "Test map as singleton" )
	public function testMapAsSingleton() : Void
	{
		var module : MockModuleForTestigInjector = new MockModuleForTestigInjector();
		module.map( IMockInterface, MockClass, '', true );
		var instance = module.get( IMockInterface );
		Assert.isInstanceOf ( instance, MockClass );
		Assert.equals ( instance, module.get( IMockInterface ) );
	}
	
	@Test( "Test map as singleton with name" )
	public function testMapAsSingletonWithName() : Void
	{
		var module : MockModuleForTestigInjector = new MockModuleForTestigInjector();
		module.map( IMockInterface, MockClass, 'name', true );
		var instance = module.get( IMockInterface, 'name' );
		Assert.isInstanceOf ( instance, MockClass );
		Assert.equals ( instance, module.get( IMockInterface, 'name' ) );
	}
	
	@Test( "Test module mappings" )
	public function testModuleMappings() : Void
	{
		var module : MockModuleForTestigInjector = new MockModuleForTestigInjector();
		Assert.equals ( module.getLogger(), module.get( ILogger ), "'_get' method call should return module's logger" );
		Assert.equals ( module.getInjector(), module.get( IBasicInjector ), "'_get' method call should return module's injector" );
		Assert.equals ( module.getInjector(), module.get( IDependencyInjector ), "'_get' method call should return module's injector" );
		Assert.deepEquals ( [ 3, 4 ], module.a, "'_getDependency' method call should return module's injector call" );
	}
}

private interface IMockInterface
{
	
}

private class MockClass implements IMockInterface
{
	public function new()
	{
		
	}
}

private class MockModuleForTestigInjector extends ContextModule
{
	public var a : Array<Int>;
	
	public function new()
	{
		super();
		
		this._injector.mapDependencyToValue( new Dependency<Array<Int>>(), [ 3, 4 ] );
		this.a = this._getDependency( new Dependency<Array<Int>>() );
	}
	
	public function get<T>( type : Class<T>, name : String = '' ) : T
	{
		return this._get( type, name );
	}
	
	public function map<T>( tInterface : Class<T>, tClass : Class<T>,  name : String = "", asSingleton : Bool = false ) : Void
	{
		this._map( tInterface, tClass, name, asSingleton );
	}
}

private class MockModuleForTestingVirtualException extends ContextModule
{
	public function new()
	{
		super();
	}
}

private class MockModuleListener
{
	public var onInitCallCount 		: UInt = 0;
	public var onReleaseCallCount 	: UInt = 0;
	
	public var moduleReference 		: IModule;
	
	public function new()
	{
		
	}
	
	public function onInit( moduleReference : IModule ) : Void
	{
		this.onInitCallCount++;
		this.moduleReference = moduleReference;
	}
	
	public function onRelease( moduleReference : IModule ) : Void
	{
		this.onReleaseCallCount++;
		this.moduleReference = moduleReference;
	}
}

private class MockModuleForTestingInitialisation extends ContextModule
{
	public var initialisationCallCount : Int = 0;
	
	public function new()
	{
		super();
	}
	
	override function _onInitialisation():Void 
	{
		super._onInitialisation();
		this.initialisationCallCount++;
	}
}

private class MockModuleForTestingRelease extends ContextModule
{
	public var releaseCallCount : Int = 0;
	
	public function new()
	{
		super();
	}
	
	override function _onRelease():Void 
	{
		super._onRelease();
		this.releaseCallCount++;
	}
}

private class MockModuleForTestingConstructor extends ContextModule
{
	public var injector 			: Injector;
	public var annotationProvider	: IAnnotationProvider;
	
	public function new()
	{
		super();

		this.injector 			= this._injector;
		this.annotationProvider = this._annotationProvider;
	}
}

private class MockModuleForTestingStatelessConfig extends ContextModule
{
	public var injector 	: Injector;
	
	public function new( ?statelessConfigClass : Class<IStatelessConfig> )
	{
		super();
		
		this._addStatelessConfigClasses( [ statelessConfigClass ] );
	}
}

private class MockStatelessConfig implements IStatelessConfig
{
	static public var wasInstantiated 		: Int = 0;
	static public var configureWasCalled 	: Int = 0;
	
	public function new()
	{
		MockStatelessConfig.wasInstantiated++;
	}
	
	public function configure() : Void
	{
		
		MockStatelessConfig.configureWasCalled++;
	}
}

private class MockModuleForTestingStateFulConfig extends ContextModule
{
	public var injector 	: Injector;

	public function new( ?statefulConfig : IStatefulConfig )
	{
		super();
		
		this._addStatefulConfigs( [statefulConfig] );

		this.injector = this._injector;
	}
}

private class MockStatefulConfig implements IStatefulConfig
{
	public var injector 	: IDependencyInjector;
	public var module 		: IContextModule;
	
	public function new()
	{
		
	}
	
	public function configure( injector : IDependencyInjector, module : IContextModule ) : Void
	{
		this.injector 		= injector;
		this.module 		= module;
	}
}

private class MockService implements IService
{
	public function createConfiguration() : Void 
	{
		
	}
	
	public function addHandler( messageType : MessageType, callback : Dynamic ) : Bool 
	{
		return false;
	}
	
	public function removeHandler( messageType : MessageType, callback : Dynamic ) : Bool 
	{
		return false;
	}
	
	public function getConfiguration() : ServiceConfiguration 
	{
		return null;
	}
	
	public function setConfiguration( configuration : ServiceConfiguration ) : Void 
	{
		
	}
	
	public function removeAllListeners() : Void 
	{
		
	}
}