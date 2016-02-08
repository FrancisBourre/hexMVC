package hex.service.monitor.http;

import hex.collection.HashMap;
import hex.error.Exception;
import hex.service.stateless.http.HTTPService;
import hex.service.stateless.http.HTTPServiceConfiguration;
import hex.service.stateless.http.HTTPServiceErrorHelper;
import hex.service.stateless.http.IHTTPServiceErrorHelperListener;

/**
 * ...
 * @author Francis Bourre
 */
class BasicHTTPServiceErrorStrategy<ServiceType:HTTPService<HTTPServiceConfiguration>> implements IServiceMonitorStrategy<ServiceType> implements IHTTPServiceErrorHelperListener<ServiceType>
{
	var _timeout 		: UInt;
	var _retryMaxCount 	: UInt;
	
	var _services 		: HashMap<HTTPService<HTTPServiceConfiguration>, HTTPServiceErrorHelper>;
	
	public function new( retryMaxCount : UInt = 3, timeout : UInt = 1000 ) 
	{
		this._timeout 		= timeout;
		this._retryMaxCount = retryMaxCount;
		this._services 		= new HashMap();
	}
	
	public function handleError( service : ServiceType, error : Exception ) : Bool
	{
		var helper : HTTPServiceErrorHelper = null;
		
		if ( this._services.containsKey( service ) )
		{
			helper = this._services.get( service );
		}
		else
		{
			helper = new HTTPServiceErrorHelper( service, this._retryMaxCount, this._timeout );
			helper.addListener( this );
			this._services.put( service, helper );
		}
		
		return helper.retry();
	}
	
	public function onReleaseHelper( service : ServiceType ) : Void 
	{
		if ( this._services.containsKey( service ) )
		{
			this._services.remove( service );
		}
	}
}