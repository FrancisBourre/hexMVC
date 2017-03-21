package hex.module;

/**
 * ...
 * @author Francis Bourre
 */
class MVCModuleSuite
{
	@Suite( "Module" )
    public var list : Array<Class<Dynamic>> = [ ContextModuleTest, ModuleTest ];
}