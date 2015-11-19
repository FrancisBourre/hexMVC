package service.stateless;

import hex.service.stateless.StatelessService;

/**
 * ...
 * @author Francis Bourre
 */
class MockStatelessService extends StatelessService
{
	public function new() 
	{
		super();
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