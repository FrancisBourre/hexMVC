package hex.control.macro;

/**
 * ...
 * @author Francis Bourre
 */
class MVCMacroSuite
{
	@Suite("Macro")
    public var list : Array<Class<Dynamic>> = [MacroExecutorTest, MacroTest];
}