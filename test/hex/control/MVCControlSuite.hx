package hex.control;

import hex.control.async.MVCAsyncSuite;
import hex.control.command.MVCCommandSuite;
import hex.control.guard.GuardUtilTest;
import hex.control.macro.MVCMacroSuite;
import hex.control.payload.MVCPayloadSuite;

/**
 * ...
 * @author Francis Bourre
 */
class MVCControlSuite
{
	@Suite("Control")
    public var list : Array<Class<Dynamic>> = [ FrontControllerTest, GuardUtilTest, MVCAsyncSuite, MVCCommandSuite, MVCMacroSuite, MVCPayloadSuite ];
}