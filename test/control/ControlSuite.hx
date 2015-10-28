package control;

import control.async.AsyncSuite;
import control.command.CommandSuite;
import control.payload.ExecutionPayloadTest;
import control.payload.PayloadEventTest;
import control.payload.PayloadSuite;

/**
 * ...
 * @author Francis Bourre
 */
class ControlSuite
{
	@suite("Control suite")
    public var list : Array<Class<Dynamic>> = [AsyncSuite, CommandSuite, FrontControllerTest, PayloadSuite ];
}