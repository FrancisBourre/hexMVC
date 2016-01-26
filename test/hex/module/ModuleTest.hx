package hex.module;

import hex.config.stateful.IStatefulConfig;
import hex.di.IDependencyInjector;
import hex.event.IDispatcher;

/**
 * ...
 * @author Francis Bourre
 */
class ModuleTest
{
	var _module : MockModuleForTest;

    @Before
    public function setUp() : Void
    {
        this._module = new MockModuleForTest();
    }

    @After
    public function tearDown() : Void
    {
        this._module = null;
    }
	
	@Test( "Test _addStatefulConfigs protected method" )
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
	
	public function configure( injector : IDependencyInjector, dispatcher : IDispatcher<{}>, module : IModule ) : Void
	{
		this.injector = injector;
	}
}