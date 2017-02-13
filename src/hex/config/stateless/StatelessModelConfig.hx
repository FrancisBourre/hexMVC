package hex.config.stateless;

import hex.config.stateless.IStatelessConfig;
import hex.di.IDependencyInjector;
import hex.di.IInjectorContainer;
import hex.error.VirtualMethodException;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessModelConfig implements IStatelessConfig implements IInjectorContainer
{
	@Inject
	public var injector : IDependencyInjector;
	
	public function new() 
	{
		
	}
	
	public function configure() : Void 
	{
		throw new VirtualMethodException();
	}
	
	public function map<ModelType>( modelInterface : Class<ModelType>, modelClass : Class<ModelType>,  name : String = "" ) : Void
	{
		var instance = this.injector.instantiateUnmapped( modelClass );
		this.injector.mapToValue( modelInterface, instance, name );
		this.injector.mapToValue( Type.resolveClass( Type.getClassName( modelInterface ) + "RO" ), instance, name );
	}
}