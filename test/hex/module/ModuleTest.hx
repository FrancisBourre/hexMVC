package hex.module;

import hex.config.stateful.IStatefulConfig;
import hex.config.stateless.IStatelessConfig;
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
		Assert.isInstanceOf( module.domainDispatcher, IDispatcher, "domainDispatcher shouldn't be null" );
		Assert.isInstanceOf( module.annotationProvider, AnnotationProvider, "annotationProvider shouldn't be null" );
	}
	
	@Test( "Test _addStatefulConfigs protected method" )
	public function testAddStatefulConfig() : Void
	{
		var config : MockStatefulConfig = new MockStatefulConfig();
		var module : MockModuleForTestingStateFulConfig = new MockModuleForTestingStateFulConfig( config );
		
		Assert.equals( module, config.module, "module should be the same" );
		Assert.equals( module.injector, config.injector, "injector should be the same" );
		Assert.equals( module.dispatcher, config.dispatcher, "dispatcher should be the same" );
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
		Assert.methodCallThrows( VirtualMethodException, module, module.initialize, [], "initialize should throw 'VirtualMethodException' when _getRuntimeDependencies is not overriden" );
		
		var anotherModule : MockModuleForTestingRuntimeDependencies = new MockModuleForTestingRuntimeDependencies();
		Assert.methodCallThrows( RuntimeDependencyException, anotherModule, anotherModule.initialize, [], "initialize should throw 'RuntimeDependencyException' when dependency is not filled" );
		
		anotherModule.mapServiceClass( MockService );
		anotherModule.initialize();
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
		var listener : MockModuleListener = new MockModuleListener();
		module.addHandler( ModuleMessage.INITIALIZED, listener, listener.onInit );
		
		module.initialize();
		Assert.equals( 1, module.initialisationCallCount, "initialise should have been called once" );
		Assert.isTrue( module.isInitialized, "'isInitialized' should return true" );
		
		Assert.equals( 1, listener.onInitCallCount, "message should have been dispatched to listeners" );
		Assert.equals( module, listener.moduleReference, "module should be the same" );
		
		Assert.isInstanceOf( module.getPrivateDispatcher(), Dispatcher,  "private dispatcher should not be null" );
		Assert.isInstanceOf( module.getPublicDispatcher(), Dispatcher,  "public dispatcher should not be null" );
		Assert.isInstanceOf( module.getLogger(), ILogger,  "logger should not be null" );
		
		Assert.methodCallThrows( IllegalStateException, module, module.initialize, [], "'initialize' called twice should throw 'IllegalStateException'" );
		Assert.equals( 1, module.initialisationCallCount, "initialise should have been called once" );
	}
	
	@Test( "Test release" )
	public function testRelease() : Void
	{
		var module : MockModuleForTestingRelease = new MockModuleForTestingRelease();
		var listener : MockModuleListener = new MockModuleListener();
		module.addHandler( ModuleMessage.RELEASED, listener, listener.onRelease );
		
		module.release();
		Assert.equals( 1, module.releaseCallCount, "release should have been called once" );
		Assert.isTrue( module.isReleased, "'isReleased' should return true" );
		
		Assert.equals( 1, listener.onReleaseCallCount, "message should have been dispatched to listeners" );
		Assert.equals( module, listener.moduleReference, "module should be the same" );
		
		Assert.isTrue( module.getPrivateDispatcher().isEmpty(),  "all listeners should have been removed" );
		Assert.isTrue( module.getPublicDispatcher().isEmpty(),  "all listeners should have been removed" );
		Assert.isNull( DomainExpert.getInstance().getDomainFor( module ), "domain should be null" );
		Assert.isNull( module.getLogger(), "logger should be null" );
		
		Assert.methodCallThrows( IllegalStateException, module, module.release, [], "'release' called twice should throw 'IllegalStateException'" );
		Assert.equals( 1, listener.onReleaseCallCount, "message should have been dispatched to listeners" );
	}
	
	@Test( "Test get accessor" )
	public function testGetAccessor() : Void
	{
		var module : MockModuleForTestigInjector = new MockModuleForTestigInjector();
		module.getInjector().mapToValue( ModuleTest, this );
		Assert.equals ( this, module.get( ModuleTest ), "'_get' method call should return mapping result from internal module's injector" );
		Assert.methodCallThrows ( MissingMappingException, module, module.get, [ Exception ], "_get' method call should throw 'MissingMappingException' when the mapping is missing" );
	}
	
	@Test( "Test module mappings" )
	public function testModuleMappings() : Void
	{
		var module : MockModuleForTestigInjector = new MockModuleForTestigInjector();
		Assert.equals ( module.getLogger(), module.get( ILogger ), "'_get' method call should return module's logger" );
		Assert.equals ( module.getInjector(), module.get( IBasicInjector ), "'_get' method call should return module's injector" );
		Assert.equals ( module.getInjector(), module.get( IDependencyInjector ), "'_get' method call should return module's injector" );
	}
}

private class MockModuleForTestigInjector extends Module
{
	public function new()
	{
		super();

	}
	
	public function get<T>( type : Class<T> ) : T
	{
		return this._get( type );
	}
}

private class MockModuleForTestingVirtualException extends Module
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

private class MockModuleForTestingInitialisation extends Module
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
		rd.addMappedDependencies( [IService]);
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
	public var dispatcher 	: IDispatcher<{}>;
	public var module 		: IModule;
	
	public function new()
	{
		
	}
	
	public function configure( injector : IDependencyInjector, dispatcher : IDispatcher<{}>, module : IModule ) : Void
	{
		this.injector 		= injector;
		this.dispatcher 	= dispatcher;
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