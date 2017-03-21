package hex.module;

import haxe.macro.Expr;
import hex.config.stateful.IStatefulConfig;
import hex.config.stateless.IStatelessConfig;
import hex.di.Dependency;
import hex.di.IBasicInjector;
import hex.di.IDependencyInjector;
import hex.di.Injector;
import hex.di.util.InjectionUtil;
import hex.domain.Domain;
import hex.domain.DomainExpert;
import hex.error.IllegalStateException;
import hex.log.ILogger;
import hex.log.LogManager;
import hex.metadata.AnnotationProvider;
import hex.metadata.IAnnotationProvider;
import hex.module.IContextModule;

/**
 * ...
 * @author Francis Bourre
 */
class ContextModule implements IContextModule
{
	var _injector 				: Injector;
	var _annotationProvider 	: IAnnotationProvider;
	var _logger 				: ILogger;

	public function new()
	{
		this._injector = new Injector();
		this._injector.mapToValue( IBasicInjector, this._injector );
		this._injector.mapToValue( IDependencyInjector, this._injector );
		
		this._annotationProvider = AnnotationProvider.getAnnotationProvider( this.getDomain() );
		this._annotationProvider.registerInjector( this._injector );
		
		this._injector.mapToValue( IContextModule, this );
		
		this._logger = LogManager.getLogger( this.getDomain().getName() );
		this._injector.mapToValue( ILogger, this._logger );
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
			this.isInitialized = true;
		}
		else
		{
			throw new IllegalStateException( "initialize can't be called more than once. Check your code." );
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
	 * Release this module
	 */
	@:final 
	public function release() : Void
	{
		if ( !this.isReleased )
		{
			this.isReleased = true;
			this._onRelease();

			DomainExpert.getInstance().releaseDomain( this );

			this._annotationProvider.unregisterInjector( this._injector );
			this._injector.destroyInstance( this );
			this._injector.teardown();
			
			this._logger = null;
		}
		else
		{
			throw new IllegalStateException( this + ".release can't be called more than once. Check your code." );
		}
	}
	
	public function getInjector() : IDependencyInjector
	{
		return this._injector;
	}
	
	public function getLogger() : ILogger
	{
		return this._logger;
	}
	
	/**
	 * Override and implement
	 */
	function _onInitialisation() : Void
	{

	}

	/**
	 * Override and implement
	 */
	function _onRelease() : Void
	{

	}
	
	/**
	 * Accessor for dependecy injector
	 * @return <code>IDependencyInjector</code> used by this module
	 */
	function _getDependencyInjector() : IDependencyInjector
	{
		return this._injector;
	}
	
	/**
	 * Add collection of module configuration classes that 
	 * need to be executed before initialisation's end
	 * @param	configurations
	 */
	function _addStatelessConfigClasses( configurations : Array<Class<IStatelessConfig>> ) : Void
	{
		for ( configurationClass in configurations )
		{
			var config : IStatelessConfig = this._injector.instantiateUnmapped( configurationClass );
			config.configure();
		}
	}
	
	/**
	 * Add collection of runtime configurations that 
	 * need to be executed before initialisation's end
	 * @param	configurations
	 */
	function _addStatefulConfigs( configurations : Array<IStatefulConfig> ) : Void
	{
		for ( configuration in configurations )
		{
			configuration.configure( this._injector, this );
		}
	}
	
	/**
	 * 
	 */
	function _get<T>( type : Class<T>, name : String = '' ) : T
	{
		return this._injector.getInstance( type, name );
	}
	
	/**
	 * 
	 */
	function _map<T>( tInterface : Class<T>, tClass : Class<T>,  name : String = "", asSingleton : Bool = false ) : Void
	{
		if ( asSingleton )
		{
			this._injector.mapToSingleton( tInterface, tClass, name );
		}
		else
		{
			this._injector.mapToType( tInterface, tClass, name );
		}
	}
	
	/**
	 * 
	 */
	macro public function _getDependency<T>( ethis : Expr, clazz : ExprOf<Dependency<T>>, ?id : ExprOf<String> ) : ExprOf<T>
	{
		var classRepresentation = InjectionUtil._getStringClassRepresentation( clazz );
		var classReference = InjectionUtil._getClassReference( clazz );
		var ct = InjectionUtil._getComplexType( clazz );
		
		var e = macro @:pos( ethis.pos ) $ethis._injector.getInstanceWithClassName( $v { classRepresentation }, $id );
		return 
		{
			expr: ECheckType
			( 
				e,
				ct
			),
			pos:ethis.pos
		};
	}
}