package hex.control.async;

/**
 * ...
 * @author Francis Bourre
 */
class MVCAsyncSuite
{
	@suite("Async")
    public var list : Array<Class<Dynamic>> = [AsyncCommandTest, AsyncCommandUtilTest ];
	
}