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
import hex.error.VirtualMethodException;
import hex.event.Dispatcher;
import hex.event.IDispatcher;
import hex.event.MessageType;
import hex.log.ILogger;
import hex.metadata.AnnotationProvider;
import hex.metadata.IAnnotationProvider;
import hex.module.IModule;
import hex.module.dependency.IRuntimeDependencies;
import hex.module.dependency.RuntimeDependencies;
import hex.module.dependency.RuntimeDependencyException;
import hex.service.IService;
import hex.service.ServiceConfiguration;
import hex.unittest.assertion.Assert;
import hex.view.IView;
import hex.view.viewhelper.IViewHelperTypedef;
import hex.view.viewhelper.MockView;
import hex.view.viewhelper.ViewHelper;

using hex.di.util.InjectorUtil;

/**
 * ...
 * @author Francis Bourre
 */
class ModuleTest
{
	@Test( "Test constructor" )
	public function testconstructor() : Void
	{
		var module : MockModuleForTestingConstructor = new MockModuleForTestingConstructor();
		Assert.isInstanceOf( module.injector, Injector, "injector shouldn't be null" );
		Assert.isInstanceOf( module.dispatcher, Dispatcher, "dispatcher shouldn't be null" );
		Assert.isNull( module.domainDispatcher, "domainDispatcher should be null" );
		Assert.isNull( module.annotationProvider, "annotationProvider should be null" );
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
	
	
	@Test( "Test runtime dependencies" )
	public function testRuntimeDependencies() : Void
	{
		var module : MockModuleForTestingVirtualException = new MockModuleForTestingVirtualException();
		
		#if debug
		Assert.methodCallThrows( VirtualMethodException, module, module.initialize, [], "initialize should throw 'VirtualMethodException' when _getRuntimeDependencies is not overriden" );
		#end
		
		var anotherModule : MockModuleForTestingRuntimeDependencies = new MockModuleForTestingRuntimeDependencies();
		
		#if debug
		Assert.methodCallThrows( RuntimeDependencyException, anotherModule, anotherModule.initialize, [], "initialize should throw 'RuntimeDependencyException' when dependency is not filled" );
		#end
		
		anotherModule.mapServiceClass( MockService );
		anotherModule.initialize( null );
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
		
		var context = new MockApplicationContext();
		module.initialize( context );
		
		Assert.equals( 1, module.initialisationCallCount, "initialise should have been called once" );
		Assert.isTrue( module.isInitialized, "'isInitialized' should return true" );
		
		Assert.isInstanceOf( module.getPrivateDispatcher(), Dispatcher,  "private dispatcher should not be null" );
		Assert.isInstanceOf( module.getPublicDispatcher(), Dispatcher,  "public dispatcher should not be null" );
		Assert.isInstanceOf( module.getLogger(), ILogger,  "logger should not be null" );
		
		#if debug
		Assert.methodCallThrows( IllegalStateException, module, module.initialize, [], "'initialize' called twice should throw 'IllegalStateException'" );
		#end
		
		Assert.equals( 1, module.initialisationCallCount, "initialise should have been called once" );
		
		Assert.isInstanceOf( module.annotationProvider, AnnotationProvider, "annotationProvider shouldn't be null" );
		Assert.equals( module.annotationProvider, AnnotationProvider.getAnnotationProvider( module.getDomain(), null, context ), "AnnotationProvider should be the same" );
	}
	
	@Test( "Test release" )
	public function testRelease() : Void
	{
		var module : MockModuleForTestingRelease = new MockModuleForTestingRelease();
		var context = new MockApplicationContext();
		module.initialize( context );
		
		module.release();
		Assert.equals( 1, module.releaseCallCount, "release should have been called once" );
		Assert.isTrue( module.isReleased, "'isReleased' should return true" );
		
		Assert.isTrue( module.getPrivateDispatcher().isEmpty(),  "all listeners should have been removed" );
		Assert.isTrue( module.getPublicDispatcher().isEmpty(),  "all listeners should have been removed" );
		Assert.isNull( DomainExpert.getInstance().getDomainFor( module ), "domain should be null" );
		Assert.isNull( module.getLogger(), "logger should be null" );
		
		#if debug
		Assert.methodCallThrows( IllegalStateException, module, module.release, [], "'release' called twice should throw 'IllegalStateException'" );
		#end
	}
	
	@Test( "Test get accessor" )
	public function testGetAccessor() : Void
	{
		var module : MockModuleForTestigInjector = new MockModuleForTestigInjector();
		module.getInjector().mapToValue( ModuleTest, this );
		Assert.equals ( this, module.get( ModuleTest ), "'_get' method call should return mapping result from internal module's injector" );
		Assert.methodCallThrows ( MissingMappingException, module, module.get, [ Exception ], "_get' method call should throw 'MissingMappingException' when the mapping is missing" );
	}
	
	@Test( "Test get accessor with name" )
	public function testGetAccessorWithName() : Void
	{
		var module : MockModuleForTestigInjector = new MockModuleForTestigInjector();
		module.getInjector().mapToValue( ModuleTest, this, 'name' );
		Assert.equals ( this, module.get( ModuleTest, 'name' ), "'_get' method call should return mapping result from internal module's injector" );
		Assert.methodCallThrows ( MissingMappingException, module, module.get, [ ModuleTest ], "_get' method call should throw 'MissingMappingException' when the mapping is missing" );
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
	
	@Test( "Test build ViewHelper" )
	public function testBuildViewHelper() : Void
	{
		var module 		= new MockModuleForTestingViewHelper();
		var view 		= new MockView();
		var viewHelper 	= module.mockBuildViewHelper( ViewHelper, view );
		
		Assert.isInstanceOf( viewHelper, ViewHelper );
		Assert.equals( view, viewHelper.view );
		Assert.isTrue( module.getInjector().hasMapping( ViewHelper ) );
		Assert.equals( viewHelper, module.getInjector().getInstance( ViewHelper ) );
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

private class MockModuleForTestingViewHelper extends Module
{
	public function new()
	{
		super();

	}
	
	public function mockBuildViewHelper( type : Class<IViewHelperTypedef>, view : IView ) : IViewHelperTypedef
	{
		return this.buildViewHelper( type, view );
	}
}

private class MockModuleForTestigInjector extends Module
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

private class MockModuleForTestingVirtualException extends Module
{
	public function new()
	{
		super();
	}
}

private class MockModuleForTestingInitialisation extends Module
{
	public var initialisationCallCount : Int = 0;
	public var annotationProvider	: IAnnotationProvider;
	
	public function new()
	{
		super();
	}
	
	override function _onInitialisation():Void 
	{
		super._onInitialisation();
		this.annotationProvider = this._annotationProvider;
		this.initialisationCallCount++;
	}
	
	override function _getRuntimeDependencies() : IRuntimeDependencies 
	{
		return new RuntimeDependencies();
	}
	
	public function getPrivateDispatcher() : IDispatcher<{}>
	{
		return this._internalDispatcher;
	}
	
	public function getPublicDispatcher() : IDispatcher<{}>
	{
		return this._domainDispatcher;
	}
}

private class MockModuleForTestingRelease extends Module
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
	
	override function _getRuntimeDependencies() : IRuntimeDependencies 
	{
		return new RuntimeDependencies();
	}
	public function getPrivateDispatcher() : IDispatcher<{}>
	{
		return this._internalDispatcher;
	}
	
	public function getPublicDispatcher() : IDispatcher<{}>
	{
		return this._domainDispatcher;
	}
}

private class MockModuleForTestingConstructor extends Module
{
	public var injector 			: Injector;
	public var dispatcher 			: IDispatcher<{}>;
	public var domainDispatcher		: IDispatcher<{}>;
	public var annotationProvider	: IAnnotationProvider;
	
	public function new()
	{
		super();

		this.injector 			= this._injector;
		this.dispatcher 		= this._internalDispatcher;
		this.domainDispatcher 	= this._domainDispatcher;
		this.annotationProvider = this._annotationProvider;
	}
}

private class MockModuleForTestingRuntimeDependencies extends Module
{
	public function new()
	{
		super();
	}
	
	public function mapServiceClass( serviceClass : Class<IService> ) : Void
	{
		this._injector.mapToType( IService, serviceClass );
	}
	
	override function _getRuntimeDependencies() : IRuntimeDependencies 
	{
		var rd : RuntimeDependencies = new RuntimeDependencies();
		rd.addMappedDependencies([ {type: IService } ]);
		return rd;
	}
}

private class MockModuleForTestingStatelessConfig extends Module
{
	public var injector 	: Injector;
	public var dispatcher 	: IDispatcher<{}>;
	
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

private class MockModuleForTestingStateFulConfig extends Module
{
	public var injector 	: Injector;
	public var dispatcher 	: IDispatcher<{}>;
	
	public function new( ?statefulConfig : IStatefulConfig )
	{
		super();
		
		this._addStatefulConfigs( [statefulConfig] );

		this.injector = this._injector;
		this.dispatcher = this._internalDispatcher;
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
