package hex.config;

import hex.config.stateful.MVCStatefulConfigSuite;

/**
 * ...
 * @author Francis Bourre
 */
class MVCConfigSuite
{
	@Suite("Config")
    public var list : Array<Class<Dynamic>> = [MVCStatefulConfigSuite];
}