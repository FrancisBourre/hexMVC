package control;

/**
 * ...
 * @author Francis Bourre
 */
class ControlSuite
{
	@suite("Control suite")
    public var list : Array<Class<Dynamic>> = [AsyncCommandEventTest, AsyncCommandTest, CommandExecutorTest, CommandMappingTest, ExecutionPayloadTest, FrontControllerTest, PayloadEventTest];
}