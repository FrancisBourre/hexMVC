package hex.module;

import hex.config.stateful.IStatefulConfig;
import hex.config.stateless.IStatelessConfig;
import hex.control.FrontController;
import hex.control.IFrontController;
import hex.control.macro.IMacroExecutor;
import hex.control.macro.MacroExecutor;
import hex.core.HashCodeFactory;
import hex.di.IDependencyInjector;
import hex.domain.ApplicationDomainDispatcher;
import hex.domain.Domain;
import hex.domain.DomainExpert;
import hex.error.IllegalStateException;
import hex.error.VirtualMethodException;
import hex.event.EventDispatcher;
import hex.event.IEvent;
import hex.event.IEventDispatcher;
import hex.event.IEventListener;
import hex.inject.Injector;
import hex.log.Stringifier;
import hex.metadata.IMetaDataProvider;
import hex.module.dependency.IRuntimeDependencies;
import hex.module.dependency.RuntimeDependencyChecker;
import hex.view.IView;
import hex.view.viewhelper.IViewHelper;
import hex.view.viewhelper.ViewHelperManager;

/**
 * ...
 * @author Francis Bourre
 */
class Module implements IModule
{
	private var _internalDispatcher : IEventDispatcher<IEventListener, IEvent>;
	private var _domainDispatcher 	: IEventDispatcher<IModuleListener, IEvent>;
	private var _injector 			: Injector;
	private var _metaDataProvider 	: IMetaDataProvider;

	public function new()
	{
		this._injector = new Injector();
		this._injector.mapToValue( IDependencyInjector, this._injector );
		this._injector.mapToValue( IModuleInjector, this._injector );
		this._domainDispatcher = ApplicationDomainDispatcher.getInstance().getDomainDispatcher( this.getDomain() );
		//this._metaDataProvider 	= MetaDataProvider.getInstance( this._injector );
		
		this._internalDispatcher = new EventDispatcher<IEventListener, IEvent>();
		this._injector.mapToValue( IFrontController, new FrontController( this._internalDispatcher, this._injector, this ) );
		this._injector.mapToValue( IEventDispatcher, this._internalDispatcher );
		this._injector.mapToType( IMacroExecutor, MacroExecutor );
		this._injector.mapToValue( IModule, this );
	}
			
	/**
	 * Initialize the module
	 */
	@:final 
	public function initialize() : Void
	{
		if ( !this.isInitialized )
		{
			this._onInitialisation();

			#if debug
				this._checkRuntimeDependencies( this._getRuntimeDependencies() );
			#end

			this.isInitialized = true;
			this._fireInitialisationEvent();
		}
		else
		{
			throw new IllegalStateException( this + ".initialize can't be called more than once. Check your code." );
		}
	}

	/**
	 * Accessor for module initialisation state
	 * @return <code>true</code> if the module is initialized
	 */
	@:final 
	@:isVar public var isInitialized( get, null ) : Bool;
	function get_isInitialized() : Bool
	{
		return this.isInitialized;
	}

	/**
	 * Accessor for module release state
	 * @return <code>true</code> if the module is released
	 */
	@:final 
	@:isVar public var isReleased( get, null ) : Bool;
	public function get_isReleased() : Bool
	{
		return this.isReleased;
	}

	/**
	 * Get module's domain
	 * @return Domain
	 */
	public function getDomain() : Domain
	{
		return DomainExpert.getInstance().getDomainFor( this );
	}

	/**
	 * Sends an event outside of the module
	 * @param	event
	 */
	public function sendExternalEventFromDomain( event : ModuleEvent ) : Void
	{
		if ( this._domainDispatcher != null )
		{
			this._domainDispatcher.dispatchEvent( event );
		}
	}
	
	/**
	 * Add event callback for specific event type
	 * @param	type
	 * @param	callback
	 */
	public function addHandler( type : String, callback : IEvent->Void ) : Void
	{
		this._domainDispatcher.addEventListener( type, callback );
	}

	/**
	 * Remove event callback for specific event type
	 * @param	type
	 * @param	callback
	 */
	public function removeHandler( type : String, callback : IEvent->Void ) : Void
	{
		this._domainDispatcher.addEventListener( type, callback );
	}
	
	private function _dispatchInternalEvent( e : IEvent ) : Void
	{
		this._internalDispatcher.dispatchEvent( e );
	}
	
	private function _dispatchDomainEvent( e : IEvent ) : Void
	{
		this._domainDispatcher.dispatchEvent( e );
	}

	private function buildViewHelper( type : Class<IViewHelper>, view : IView ) : IViewHelper
	{
		return ViewHelperManager.getInstance( this ).buildViewHelper( this._injector, type, view );
	}

	/**
	 * Release this module
	 */
	@:final 
	public function release() : Void
	{
		if ( !this.isReleased )
		{
			this.isReleased = true;
			this._onRelease();
			_fireReleaseEvent();

			ViewHelperManager.release( this );
			this._domainDispatcher.removeAllListeners();
			this._internalDispatcher.removeAllListeners();
			DomainExpert.getInstance().releaseDomain( this );

			this._injector.destroyInstance( this );
			this._injector.teardown();
		}
		else
		{
			throw new IllegalStateException( this + ".release can't be called more than once. Check your code." );
		}
	}

	/*public function registerInjectorUser( user : IInjectorUser ) : void
	{
		user.registerInjector( this._injector );
	}*/
	
	/**
	 * Fire initialisation event
	 */
	private function _fireInitialisationEvent() : Void
	{
		if ( this.isInitialized )
		{
			this.sendExternalEventFromDomain( new ModuleEvent( ModuleEvent.INITIALIZED, this ) );
		}
		else
		{
			throw new IllegalStateException( this + ".fireModuleInitialisationNote can't be called with previous initialize call." );
		}
	}

	/**
	 * Fire release event
	 */
	private function _fireReleaseEvent() : Void
	{
		if ( this.isReleased )
		{
			this.sendExternalEventFromDomain( new ModuleEvent( ModuleEvent.RELEASED, this ) );
		}
		else
		{
			throw new IllegalStateException( this + ".fireModuleReleaseNote can't be called with previous release call." );
		}
	}
	
	/**
	 * Override and implement
	 */
	private function _onInitialisation() : Void
	{

	}

	/**
	 * Override and implement
	 */
	private function _onRelease() : Void
	{

	}
	
	/**
	 * Accessor for dependecy injector
	 * @return <code>IDependencyInjector</code> used by this module
	 */
	private function _getDependencyInjector() : IDependencyInjector
	{
		return this._injector;
	}
	
	/**
	 * Getter for runtime dependencies that needs to be
	 * checked before initialisation end
	 * @return <code>IRuntimeDependencies</code> used by this module
	 */
	private function _getRuntimeDependencies() : IRuntimeDependencies
	{
		throw new VirtualMethodException( Stringifier.stringify( this ) + ".checkDependencies is not implemented" );
	}
	
	/**
	 * Check collection of injected dependencies
	 * @param	dependencies
	 */
	private function _checkRuntimeDependencies( dependencies : IRuntimeDependencies ) : Void
	{
		RuntimeDependencyChecker.check( this, this._injector, dependencies );
	}
	
	/**
	 * Add collection of module configuration classes that 
	 * need to be executed before initialisation's end
	 * @param	configurations
	 */
	private function _addStatelessConfigClasses( configurations : Array<Class<IStatelessConfig>> ) : Void
	{
		var i : Int = configurations.length;
		while ( --i > -1 )
		{
			var configurationClass : Class<IStatelessConfig> = configurations[ i ];
			var configClassInstance : IStatelessConfig = this._injector.instantiateUnmapped( configurationClass );
			configClassInstance.configure();
		}
	}
	
	/**
	 * Add collection of runtime configurations that 
	 * need to be executed before initialisation's end
	 * @param	configurations
	 */
	private function _addStatefulConfigs( configurations : Array<IStatefulConfig> ) : Void
	{
		var i : Int = configurations.length;
		while ( --i > -1 )
		{
			var configuration : IStatefulConfig = configurations[ i ];
			if ( configuration != null )
			{
				configuration.configure( this._injector, this._internalDispatcher, this );
			}
		}
	}
	
	/**
	 * Only use it before super() call in constructor if this module is not 
	 * used in IoC architecture to allow module communication.
	 */
	private static function registerInternalDomain( module : IModule ) : Void
	{
		var key : String = Type.getClassName( Type.getClass( module ) ) + HashCodeFactory.getKey( module );
		DomainExpert.getInstance().registerDomain( new Domain( key ) );
	}
}