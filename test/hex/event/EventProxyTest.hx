package hex.event;

import hex.error.IllegalArgumentException;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class EventProxyTest
{
	@test( "Test EventProxy constructor" )
    public function testEventProxyconstructor() : Void
    {
		var target : MockEventProxyTarget = new MockEventProxyTarget();
		var eventProxy : EventProxy = new EventProxy( target, target.stubMethod );
		Assert.equals( target, eventProxy.scope, "scope should be the same" );
		Assert.equals( target.stubMethod, eventProxy.callback, "callback should be the same" );
	}
	
	@test( "Test EventProxy handling callback" )
    public function testEventProxyHandlingCallback() : Void
    {
		var target : MockEventProxyTarget = new MockEventProxyTarget();
		var eventProxy : EventProxy = new EventProxy( target, target.stubMethod );
		var parameters : Array<MockParameter> = [ new MockParameter(), new MockParameter() ];
		eventProxy.handleCallback( parameters );
		Assert.deepEquals( parameters, target.parameters, "parameters should be the same" );
	}
}

private class MockEventProxyTarget
{
	public var parameters:Array<MockParameter>;
	
	public function new()
	{
		
	}
	
	public function stubMethod( param0 : MockParameter, param1 : MockParameter ) : Void
	{
		this.parameters = [ param0, param1 ];
	}
}

private class MockParameter
{
	public function new()
	{
		
	}
}