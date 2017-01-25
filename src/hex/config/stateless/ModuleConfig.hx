package hex.config.stateless;

import hex.config.stateless.IStatelessConfig;
import hex.di.IDependencyInjector;
import hex.di.IInjectorContainer;
import hex.error.VirtualMethodException;

/**
 * ...
 * @author Francis Bourre
 */
class ModuleConfig implements IStatelessConfig implements IInjectorContainer
{
	@Inject
	public var injector : IDependencyInjector;
	
	function new() 
	{
		
	}
	
	public function configure() : Void 
	{
		throw new VirtualMethodException( this + ".configure must be overridden" );
	}
	
	public function get<T>( type : Class<T>, name : String = "" ) : T
	{
		return this.injector.getInstance( type );
	}
	
	public function mapController<ControllerType>( controllerInterface : Class<ControllerType>, controllerClass : Class<ControllerType>,  name : String = "", asSingleton : Bool = false ) : Void
	{
		if ( asSingleton )
		{
			this.injector.mapToSingleton( controllerInterface, controllerClass, name );
		}
		else
		{
			this.injector.mapToType( controllerInterface, controllerClass, name );
		}
	}
	
	public function mapModel<ModelType>( modelInterface : Class<ModelType>, modelClass : Class<ModelType>,  name : String = "", asSingleton : Bool = false ) : Void
	{
		if ( asSingleton )
		{
			this.injector.mapToSingleton( modelInterface, modelClass, name );
		}
		else
		{
			this.injector.mapToType( modelInterface, modelClass, name );
		}
	}
	
	public function mapMediator<MediatorType>( mediatorInterface : Class<MediatorType>, mediatorClass : Class<MediatorType>,  name : String = "", asSingleton : Bool = false ) : Void
	{
		if ( asSingleton )
		{
			this.injector.mapToSingleton( mediatorInterface, mediatorClass, name );
		}
		else
		{
			this.injector.mapToType( mediatorInterface, mediatorClass, name );
		}
	}
}