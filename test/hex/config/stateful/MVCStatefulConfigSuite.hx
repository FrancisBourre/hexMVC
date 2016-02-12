package hex.config.stateful;

/**
 * ...
 * @author Francis Bourre
 */
class MVCStatefulConfigSuite
{
	@Suite( "Stateful" )
    public var list : Array<Class<Dynamic>> = [ StatefulCommandConfigTest ];
}