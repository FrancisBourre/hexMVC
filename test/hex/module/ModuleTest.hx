package hex.module;
import hex.config.stateful.IStatefulConfig;
import hex.di.IDependencyInjector;

/**
 * ...
 * @author Francis Bourre
 */
class ModuleTest
{
	private var _module : MockModuleForTest;

    @setUp
    public function setUp() : Void
    {
        this._module = new MockModuleForTest();
    }

    @tearDown
    public function tearDown() : Void
    {
        this._module = null;
    }
	
	@test( "Test _addStatefulConfigs protected method" )
	public function testAddStatefulConfig() : Void
	{
		
	}
}

private class MockModuleForTest extends Module
{
	public function new( ?statefulConfig : IStatefulConfig )
	{
		super();
		if ( statefulConfig != null )
		{
			this._addStatefulConfigs( [statefulConfig] );
		}
		
	}
}

private class MockStatefulConfig implements IStatefulConfig
{
	public var injector : IDependencyInjector;
	
	public function new()
	{
		
	}
	
	public function configure( injector : IDependencyInjector ) : Void 
	{
		this.injector = injector;
	}
}