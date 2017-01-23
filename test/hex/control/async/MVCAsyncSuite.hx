package hex.control.async;

/**
 * ...
 * @author Francis Bourre
 */
class MVCAsyncSuite
{
	@Suite("Async")
    public var list : Array<Class<Dynamic>> = [ AsyncCommandMessageTest, 
	#if (!neko || haxe_ver >= "3.3")
	AsyncCommandTest, 
	AsyncCommandUtilTest
	#end
	];

}
