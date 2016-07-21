package hex.config;

import hex.config.stateful.MVCStatefulConfigSuite;
import hex.config.stateless.MVCStatelessConfigSuite;

/**
 * ...
 * @author Francis Bourre
 */
class MVCConfigSuite
{
		@Suite("Config")
    public var list : Array<Class<Dynamic>> = [ MVCStatefulConfigSuite, MVCStatelessConfigSuite ];
}
