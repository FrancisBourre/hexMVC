package hex.metadata;

import hex.di.IDependencyInjector;

/**
 * @author Francis Bourre
 */
interface IAnnotationProvider 
{
	function registerMetaData( metaDataName : String, scope : Dynamic, providerMethod : String->Dynamic ) : Void;
	function clear() : Void;
	function parse( object : {} ) : Void;
	function registerInjector( injector : IDependencyInjector ) : Void;
	function unregisterInjector( injector : IDependencyInjector ) : Void;
}