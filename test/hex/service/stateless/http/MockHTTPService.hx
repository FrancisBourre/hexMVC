package hex.service.stateless.http;

import hex.service.stateless.http.HTTPService;
import hex.service.stateless.http.HTTPServiceConfiguration;
import hex.service.stateless.http.HTTPServiceEvent;

/**
 * ...
 * @author Francis Bourre
 */
class MockHTTPService extends HTTPService<HTTPServiceEvent, HTTPServiceConfiguration>
{
	public function new()
	{
		super();
	}
	
	@postConstruct
	override public function createConfiguration() : Void
	{
		this._configuration 	= new HTTPServiceConfiguration();
		this._serviceEventClass = HTTPServiceEvent;
	}
	
	public function call_getRemoteArguments() : Array<Dynamic> 
	{
		return this._getRemoteArguments();
	}
	
	public function call_reset() : Void 
	{
		this._reset();
	}
	
	public function testSetResult( result : Dynamic ) : Void
	{
		this._setResult( result );
	}
}