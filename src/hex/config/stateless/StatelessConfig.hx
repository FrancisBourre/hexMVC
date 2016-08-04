package hex.config.stateless;

import hex.di.IDependencyInjector;
import hex.di.IInjectorContainer;
import hex.error.VirtualMethodException;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessConfig implements IStatelessConfig implements IInjectorContainer
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
	
	public function map<T>( interfaceRef : Class<T>, classRef : Class<T>,  name : String = "" ) : Void
	{
		var instance : Dynamic = this.injector.instantiateUnmapped( classRef );
		this.injector.mapToValue( interfaceRef, instance, name );
	}
	
	public function mapToSingleton<T>( interfaceRef : Class<T>, classRef : Class<T>,  name : String = "" ) : Void
	{
		this.injector.mapToSingleton( interfaceRef, classRef, name );
	}
}