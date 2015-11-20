package service.stateless;

import hex.service.stateless.AsyncStatelessService;
import hex.service.stateless.AsyncStatelessServiceEvent;

/**
 * ...
 * @author Francis Bourre
 */
class MockAsyncStatelessService extends AsyncStatelessService<AsyncStatelessServiceEvent>
{
	public function new()
	{
		super();
		this.setEventClass( AsyncStatelessServiceEvent );
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