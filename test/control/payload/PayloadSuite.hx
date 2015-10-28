package control.payload;

/**
 * ...
 * @author Francis Bourre
 */
class PayloadSuite
{
	@suite("Payload suite")
    public var list : Array<Class<Dynamic>> = [ ExecutionPayloadTest, PayloadEventTest ];
	
}