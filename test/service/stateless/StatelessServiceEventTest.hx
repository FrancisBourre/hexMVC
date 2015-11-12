package service.stateless;

import hex.service.stateless.StatelessServiceEvent;
import hex.unittest.assertion.Assert;
import service.ServiceEventTest;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessServiceEventTest
{
	@test( "Test 'type' parameter passed to constructor" )
    public function testType() : Void
    {
        var type : String = "type";
		var target : MockStatelessService = new MockStatelessService();
        var e : StatelessServiceEvent = new StatelessServiceEvent( type, target );
        Assert.assertEquals( type, e.type, "'type' property should be the same passed to constructor" );
    }

    @test( "Test 'target' parameter passed to constructor" )
    public function testTarget() : Void
    {
        var target : MockStatelessService = new MockStatelessService();
        var e : StatelessServiceEvent = new StatelessServiceEvent( "", target );

        Assert.assertEquals( target, e.target, "'target' property should be the same passed to constructor" );
    }

    @test( "Test clone method" )
    public function testClone() : Void
    {
        var type : String = "type";
        var target : MockStatelessService = new MockStatelessService();
        var e : StatelessServiceEvent = new StatelessServiceEvent( type, target );
        var clonedEvent : StatelessServiceEvent = cast e.clone();

        Assert.assertEquals( type, clonedEvent.type, "'clone' method should return cloned event with same 'type' property" );
        Assert.assertEquals( target, clonedEvent.target, "'clone' method should return cloned event with same 'target' property" );
    }
	
	@test( "Test 'service' parameter passed to constructor" )
    public function testServiceParameter() : Void
    {
		var service : MockStatelessService = new MockStatelessService();
        var e : StatelessServiceEvent = new StatelessServiceEvent( "eventType", service );

        Assert.assertEquals( service, e.getService(), "'getStatelessService' accessor should return property passed to constructor" );
    }
}