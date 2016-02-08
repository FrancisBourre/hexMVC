package hex.service.monitor;

import hex.collection.HashMap;
import hex.core.HashCodeFactory;
import hex.error.Exception;
import hex.error.IllegalArgumentException;
import hex.log.Stringifier;
import hex.service.ServiceConfiguration;
import hex.service.monitor.http.BasicHTTPServiceErrorStrategy;
import hex.service.stateful.StatefulService;
import hex.service.stateless.http.HTTPService;
import hex.util.ClassUtil;

/**
 * ...
 * @author Francis Bourre
 */
@:rtti
class BasicServiceMonitor extends StatefulService<ServiceConfiguration> implements IServiceMonitor
{
	var _map : HashMap<Dynamic, Dynamic>;
	
	public function new() 
	{
		super();
		this._map = new HashMap();
	}
	
	public function handleError<ServiceType:Service>( service : ServiceType, error : Exception ) : Bool
	{trace("@handleError");
		var serviceMonitorStrategy : IServiceMonitorStrategy<ServiceType> = null;
		
		var serviceClasses : Array<Class<Dynamic>> = ClassUtil.getInheritanceChainFrom( service );
		for ( serviceClass in serviceClasses )
		{
			if ( this._map.containsKey( serviceClass ) )
			{
				serviceMonitorStrategy = this._map.get( serviceClass );
				trace( "#####", Stringifier.stringify( serviceMonitorStrategy ) + HashCodeFactory.getKey( serviceMonitorStrategy ) );
				break;
			}
		}
		
		if ( serviceMonitorStrategy != null )
		{
			return serviceMonitorStrategy.handleError( service, error );
		}
		
		
		return false;
	}
	
	public function mapStrategy<ServiceType:Service>( serviceClass : Class<ServiceType>, strategy : IServiceMonitorStrategy<ServiceType> ) : Bool
	{trace( "map:", Type.getClassName( serviceClass ) );
		if ( !this._map.containsKey( serviceClass ) )
		{
			this._map.put( serviceClass, strategy );
			return true;
		}
		trace( "mapStrategy failed with '" +  Stringifier.stringify( serviceClass ) + "'. this class was already mapped." );
		throw new IllegalArgumentException( "mapStrategy failed with '" +  Stringifier.stringify( serviceClass ) + "'. this class was already mapped." );
	}
	
	function _handleFatalError<ServiceType:Service>( service : ServiceType, error : Exception ) : Void
	{
		this._compositeDispatcher.dispatch( ServiceMonitorMessage.FATAL, [ new ServiceMonitorMessage( service, error ) ] );
	}
}