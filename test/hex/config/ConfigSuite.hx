package hex.config;

import hex.config.stateful.StatefulSuite;

/**
 * ...
 * @author Francis Bourre
 */
class ConfigSuite
{
	@suite("Config suite")
    public var list : Array<Class<Dynamic>> = [StatefulSuite];
}