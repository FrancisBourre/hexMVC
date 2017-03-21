package hex.control.async;

/**
 * ...
 * @author Francis Bourre
 */
class MVCAsyncSuite
{
	@Suite("Async")
    public var list : Array<Class<Dynamic>> = [
		AsyncCommandMessageTest,
		AsyncCommandTest,
		AsyncCommandUtilTest
	];

}
