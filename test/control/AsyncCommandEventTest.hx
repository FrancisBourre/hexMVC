package control;

import hex.control.AsyncCommand;
import hex.control.AsyncCommandEvent;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncCommandEventTest
{
    @test( "Test 'type' parameter passed to constructor" )
    public function testType() : Void
    {
        var type : String 			= "type";
        var e : AsyncCommandEvent 	= new AsyncCommandEvent( type, new AsyncCommand() );
        Assert.assertEquals( type, e.type, "'type' property should be the same passed to constructor" );
    }

    @test( "Test 'target' parameter passed to constructor" )
    public function testTarget() : Void
    {
        var target : AsyncCommand 	= new AsyncCommand();
        var e : AsyncCommandEvent 	= new AsyncCommandEvent( "", target );

        Assert.assertEquals( target, e.target, "'target' property should be the same passed to constructor" );
    }

    @test( "Test clone method" )
    public function testClone() : Void
    {
        var type : String 						= "type";
        var target : AsyncCommand 				= new AsyncCommand();
        var e : AsyncCommandEvent 				= new AsyncCommandEvent( type, target );
        var clonedEvent : AsyncCommandEvent 	= cast e.clone();

        Assert.assertEquals( type, clonedEvent.type, "'clone' method should return cloned event with same 'type' property" );
        Assert.assertEquals( target, clonedEvent.target, "'clone' method should return cloned event with same 'target' property" );
    }
}