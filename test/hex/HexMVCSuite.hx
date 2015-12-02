package hex;

import hex.config.ConfigSuite;
import hex.control.ControlSuite;
import hex.module.ModuleSuite;
import hex.service.ServiceSuite;
import hex.viewhelper.ViewHelperSuite;

/**
 * ...
 * @author Francis Bourre
 */
class HexMVCSuite
{
	@suite( "HexMVC suite" )
    public var list : Array<Class<Dynamic>> = [ConfigSuite, ControlSuite, ModuleSuite, ServiceSuite, ViewHelperSuite];
}