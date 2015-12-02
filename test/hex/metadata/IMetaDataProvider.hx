package hex.metadata;

import hex.inject.IInjector;

/**
 * @author Francis Bourre
 */
interface IMetaDataProvider 
{
	function registerMetaData( metaDataName : String, providerMethod : Dynamic ) : Void;
	function clear() : Void;
	function parse( object : Dynamic ) : Void;
	function addProperty( metaDataName : String ) : Void;
	function addProperties( metaDataNames : Array<String> ) : Void;
	function registerInjector( injector : IInjector ) : Void;
	function unregisterInjector( injector : IInjector ) : Void;
}