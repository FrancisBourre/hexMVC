package service;

import hex.event.BasicEventTest;
import hex.service.stateless.StatelessServiceEvent;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class ServiceEventTest extends BasicEventTest
{
	@test( "Test 'service' parameter passed to constructor" )
    public function testServiceParameter() : Void
    {
		var service : MockStatelessService = new MockStatelessService();
        var e : StatelessServiceEvent = new StatelessServiceEvent( "eventType", service );

        Assert.assertEquals( service, e.getService(), "'getStatelessService' accessor should return property passed to constructor" );
    }
}