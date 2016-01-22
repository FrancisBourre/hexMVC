package hex.config.stateless;

import hex.di.IDependencyInjector;
import hex.error.VirtualMethodException;

/**
 * ...
 * @author Francis Bourre
 */
@:rtti
class StatelessModelConfig implements IStatelessConfig
{
	@Inject
	public var injector : IDependencyInjector;
	
	public function new() 
	{
		
	}
	
	public function configure() : Void 
	{
		throw new VirtualMethodException( this + ".configure must be overridden" );
	}
	
	public function mapModel<ModelType>( modelInterface : Class<ModelType>, modelClass : Class<ModelType>,  name : String = "" ) : Void
	{
		var instance : Dynamic = this.injector.instantiateUnmapped( modelClass );
		this.injector.mapToValue( modelInterface, instance, name );
		this.injector.mapToValue( Type.resolveClass( Type.getClassName( modelInterface ) + "RO" ), instance );
	}
}