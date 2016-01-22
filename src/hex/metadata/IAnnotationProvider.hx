package hex.metadata;

import hex.inject.IInjector;

/**
 * @author Francis Bourre
 */
interface IAnnotationProvider 
{
	function registerMetaData( metaDataName : String, scope : Dynamic, providerMethod : String->Dynamic ) : Void;
	function clear() : Void;
	function parse( object : {} ) : Void;
	function registerInjector( injector : IInjector ) : Void;
	function unregisterInjector( injector : IInjector ) : Void;
}