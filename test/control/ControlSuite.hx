package control;

import control.async.AsyncSuite;
import control.command.CommandSuite;
import control.guard.GuardUtilTest;
import control.macro.MacroSuite;
import control.payload.PayloadSuite;

/**
 * ...
 * @author Francis Bourre
 */
class ControlSuite
{
	@suite("Control suite")
    public var list : Array<Class<Dynamic>> = [ AsyncSuite, CommandSuite, GuardUtilTest, FrontControllerTest, MacroSuite, PayloadSuite ];
}