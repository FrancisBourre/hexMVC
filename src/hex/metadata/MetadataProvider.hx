package hex.metadata;

import hex.core.IMetaDataParsable;
import hex.inject.IInjector;
import hex.inject.InjectionEvent;

/**
 * ...
 * @author Francis Bourre
 */
class MetadataProvider implements IMetaDataProvider
{
	static private var _Instance : IMetaDataProvider = null;

	public function new( constructorAccess : ConstructorAccess ) 
	{
		
	}
	
	static public function getInstance( injector : IInjector = null ) : IMetaDataProvider
	{
		if ( MetadataProvider._Instance == null )
		{
			MetadataProvider._Instance = new MetadataProvider( new ConstructorAccess() );
		}

		if ( injector != null )
		{
			MetadataProvider._Instance.registerInjector( injector );
		}

		return MetadataProvider._Instance;
	}
	
	public function registerMetaData( metaDataName : String, providerMethod : Dynamic ) : Void 
	{
		
	}
	
	public function clear() : Void 
	{
		
	}
	
	public function parse( object : Dynamic ) : Void 
	{
		
	}
	
	public function addProperty( metaDataName : String ) : Void 
	{
		
	}
	
	public function addProperties( metaDataNames : Array<String> ) : Void 
	{
		
	}
	
	public function registerInjector( injector : IInjector ) : Void
	{
		injector.addInjectionEventListener( InjectionEvent.POST_CONSTRUCT, _onPostconstruct );
	}

	public function unregisterInjector( injector : IInjector ) : Void
	{
		injector.removeInjectionEventListener( InjectionEvent.POST_CONSTRUCT, _onPostconstruct );
	}
	
	private function _onPostconstruct( event : InjectionEvent ) : Void
	{
		if ( Std.is( event.instance, IMetaDataParsable ) )
		{
			this.parse( event.instance );
		}
	}
}

private class ConstructorAccess
{
	public function new()
	{
		
	}
}