package;

import control.ControlSuite;
import module.ModuleSuite;
import service.ServiceSuite;
import viewhelper.ViewHelperSuite;

/**
 * ...
 * @author Francis Bourre
 */
class HexMVCSuite
{
	@suite( "HexMVC suite" )
    public var list : Array<Class<Dynamic>> = [ControlSuite, ModuleSuite, ServiceSuite, ViewHelperSuite];
}