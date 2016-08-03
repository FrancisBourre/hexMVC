package hex.config.stateless;

/**
 * ...
 * @author Tamas Kinsztler
 */
class MVCStatelessConfigSuite
{
	@Suite( "Stateless" )
    public var list : Array<Class<Dynamic>> = [ StatelessCommandConfigTest, StatelessModelConfigTest ];
}
