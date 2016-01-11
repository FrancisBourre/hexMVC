package hex.control.payload;

/**
 * ...
 * @author Francis Bourre
 */
class MVCPayloadSuite
{
	@suite("Payload")
    public var list : Array<Class<Dynamic>> = [ ExecutionPayloadTest, PayloadUtilTest ];
	
}