package control.macro;

/**
 * ...
 * @author Francis Bourre
 */
class MacroSuite
{
	@suite("Macro suite")
    public var list : Array<Class<Dynamic>> = [MacroExecutorTest, MacroTest];
}