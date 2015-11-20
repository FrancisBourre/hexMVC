package service.stateless;

import hex.service.stateless.StatelessService;
import hex.service.stateless.StatelessServiceEvent;

/**
 * ...
 * @author Francis Bourre
 */
class MockStatelessService extends StatelessService<StatelessServiceEvent>
{
	public function new() 
	{
		super();
		this.setEventClass( StatelessServiceEvent );
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