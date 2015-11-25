package hex.control.async;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncSuite
{
	@suite("Async suite")
    public var list : Array<Class<Dynamic>> = [AsyncCommandEventTest, AsyncCommandTest, AsyncCommandUtilTest ];
	
}