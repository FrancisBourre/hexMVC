package hex.control;

import hex.control.async.AsyncSuite;
import hex.control.command.CommandSuite;
import hex.control.guard.GuardUtilTest;
import hex.control.macro.MacroSuite;
import hex.control.payload.PayloadSuite;

/**
 * ...
 * @author Francis Bourre
 */
class ControlSuite
{
	@suite("Control suite")
    public var list : Array<Class<Dynamic>> = [ AsyncSuite, CommandSuite, GuardUtilTest, FrontControllerTest, MacroSuite, PayloadSuite ];
}