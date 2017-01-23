package hex.event;

/**
 * ...
 * @author Francis Bourre
 */
class MVCEventSuite
{
	@Suite("event")
    public var list : Array<Class<Dynamic>> = [CallbackAdapterTest, ClassAdapterTest, EventProxyTest
	#if (!neko || haxe_ver >= "3.3")
	, MacroAdapterStrategyTest
	#end
	];
}