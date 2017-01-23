package hex.control.macro;

/**
 * ...
 * @author Francis Bourre
 */
class MVCMacroSuite
{
	@Suite("Macro")
    public var list : Array<Class<Dynamic>> = [
	#if (!neko || haxe_ver >= "3.3")
	MacroExecutorTest, 
	MacroTest
	#end
	];
}