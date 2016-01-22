package hex.control.payload;

/**
 * ...
 * @author Francis Bourre
 */
class MVCPayloadSuite
{
	@Suite("Payload")
    public var list : Array<Class<Dynamic>> = [ ExecutionPayloadTest, PayloadUtilTest ];
	
}