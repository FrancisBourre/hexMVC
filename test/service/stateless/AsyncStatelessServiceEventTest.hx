package service.stateless;

import hex.service.stateless.AsyncStatelessServiceEvent;
import hex.unittest.assertion.Assert;
import service.stateless.MockAsyncStatelessService;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncStatelessServiceEventTest
{
	@test( "Test 'type' parameter passed to constructor" )
    public function testType() : Void
    {
        var type : String = "type";
		var target : MockAsyncStatelessService = new MockAsyncStatelessService();
        var e : AsyncStatelessServiceEvent = new AsyncStatelessServiceEvent( type, target );
        Assert.assertEquals( type, e.type, "'type' property should be the same passed to constructor" );
    }

    @test( "Test 'target' parameter passed to constructor" )
    public function testTarget() : Void
    {
        var target : MockAsyncStatelessService = new MockAsyncStatelessService();
        var e : AsyncStatelessServiceEvent = new AsyncStatelessServiceEvent( "", target );

        Assert.assertEquals( target, e.target, "'target' property should be the same passed to constructor" );
    }

    @test( "Test clone method" )
    public function testClone() : Void
    {
        var type : String = "type";
        var target : MockAsyncStatelessService = new MockAsyncStatelessService();
        var e : AsyncStatelessServiceEvent = new AsyncStatelessServiceEvent( type, target );
        var clonedEvent : AsyncStatelessServiceEvent = cast e.clone();

        Assert.assertEquals( type, clonedEvent.type, "'clone' method should return cloned event with same 'type' property" );
        Assert.assertEquals( target, clonedEvent.target, "'clone' method should return cloned event with same 'target' property" );
    }
	
	@test( "Test 'service' parameter passed to constructor" )
    public function testServiceParameter() : Void
    {
		var service : MockAsyncStatelessService = new MockAsyncStatelessService();
        var e : AsyncStatelessServiceEvent = new AsyncStatelessServiceEvent( "eventType", service );

        Assert.assertEquals( service, e.getService(), "'getStatelessService' accessor should return property passed to constructor" );
    }
}