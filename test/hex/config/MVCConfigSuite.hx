package hex.config;

import hex.config.stateful.MVCStatefulConfigSuite;

/**
 * ...
 * @author Francis Bourre
 */
class MVCConfigSuite
{
	@suite("MVC Config")
    public var list : Array<Class<Dynamic>> = [MVCStatefulConfigSuite];
}