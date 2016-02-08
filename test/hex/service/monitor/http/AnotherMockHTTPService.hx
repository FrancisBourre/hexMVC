package hex.service.monitor.http;

import hex.error.Exception;
import hex.service.stateless.http.HTTPService;
import hex.service.stateless.http.HTTPServiceConfiguration;

/**
 * ...
 * @author Francis Bourre
 */
@:rtti
class AnotherMockHTTPService<ServiceConfigurationType:HTTPServiceConfiguration> extends HTTPService<ServiceConfigurationType>
{
	public static var serviceCallCount 	: UInt 		= 0;
	public static var errorThrown 		: Exception = null;
	
	@Inject
	public var serviceMonitor : IServiceMonitor;
	
	public function new() 
	{
		super();
		
	}
	
	override function _onError( msg : String ) : Void
	{
		if ( !this.serviceMonitor.handleError( this, new MockHTTPServiceException( msg ) ) )
		{
			super._onError( msg );
		}
		else
		{
			this._reset();
		}
	}
	
	override public function call() : Void
	{
		try
		{
			AnotherMockHTTPService.serviceCallCount++;
			super.call();
		}
		catch( e : Exception )
		{
			if ( !this.serviceMonitor.handleError( this, new MockHTTPServiceException( e.message ) ) )
			{
				AnotherMockHTTPService.errorThrown = e;
			}
		}
	}
}