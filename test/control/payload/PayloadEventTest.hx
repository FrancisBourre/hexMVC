package control.payload;

import hex.control.payload.ExecutionPayload;
import hex.control.payload.PayloadEvent;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class PayloadEventTest
{
    @test( "Test 'type' parameter passed to constructor" )
    public function testType() : Void
    {
        var type : String       = "type";
        var e : PayloadEvent    = new PayloadEvent( type, {}, [] );

        Assert.assertEquals( type, e.type, "'type' property should be the same passed to constructor" );
    }

    @test( "Test 'target' parameter passed to constructor" )
    public function testTarget() : Void
    {
        var target : MockTarget = new MockTarget();
        var e : PayloadEvent    = new PayloadEvent( "", target, [] );

        Assert.assertEquals( target, e.target, "'target' property should be the same passed to constructor" );
    }

    @test( "Test clone method" )
    public function testClone() : Void
    {
        var type : String               			= "type";
        var target : MockTarget         			= new MockTarget();
        var payloads : Array<ExecutionPayload> 		= [ new ExecutionPayload( "Hello", String ) ];
        var e : PayloadEvent            			= new PayloadEvent( type, target, payloads );
        var clonedEvent : PayloadEvent  			= cast e.clone();

        Assert.assertEquals( type, clonedEvent.type, "'clone' method should return cloned event with same 'type' property" );
        Assert.assertEquals( target, clonedEvent.target, "'clone' method should return cloned event with same 'target' property" );
        Assert.assertEquals( payloads, clonedEvent.getExecutionPayloads(), "'clone' method should return cloned event with same execution payloads" );
    }
	
	@test( "Test get execution payloads" )
    public function testGetExecutionPayloads() : Void
    {
		
	}
}

private class MockTarget
{
    public function new()
    {

    }
}