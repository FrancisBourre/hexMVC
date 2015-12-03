package hex.control.async;

import hex.control.async.AsyncCommand;
import hex.control.async.AsyncCommandEvent;
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
        Assert.equals( type, e.type, "'type' property should be the same passed to constructor" );
    }

    @test( "Test 'target' parameter passed to constructor" )
    public function testTarget() : Void
    {
        var target : AsyncCommand 	= new AsyncCommand();
        var e : AsyncCommandEvent 	= new AsyncCommandEvent( "", target );

        Assert.equals( target, e.target, "'target' property should be the same passed to constructor" );
    }

    @test( "Test clone method" )
    public function testClone() : Void
    {
        var type : String 						= "type";
        var target : AsyncCommand 				= new AsyncCommand();
        var e : AsyncCommandEvent 				= new AsyncCommandEvent( type, target );
        var clonedEvent : AsyncCommandEvent 	= cast e.clone();

        Assert.equals( type, clonedEvent.type, "'clone' method should return cloned event with same 'type' property" );
        Assert.equals( target, clonedEvent.target, "'clone' method should return cloned event with same 'target' property" );
    }
}