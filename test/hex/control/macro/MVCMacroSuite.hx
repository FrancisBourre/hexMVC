package hex.control.macro;

/**
 * ...
 * @author Francis Bourre
 */
class MVCMacroSuite
{
	@suite("Macro")
    public var list : Array<Class<Dynamic>> = [MacroExecutorTest, MacroTest];
}