package hex.config.stateless;

import hex.config.stateless.StatelessConfig;
import hex.error.VirtualMethodException;
import hex.unittest.assertion.Assert;
import hex.util.MacroUtil;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessConfigTest
{
	@Test( "Test 'configure' throws 'VirtualMethodException'" )
	public function testConfigureThrowsVirtualMethodException() : Void
	{
		var config = new StatelessConfig();
		Assert.methodCallThrows( VirtualMethodException, config, config.configure, [], "configure should throw 'VirtualMethodException'" );
	}
	
	@Test( "Test 'map' behavior" )
    public function testMapBehavior() : Void
    {
		var injector = new MockInjectorForMapToValueTest();
		var config = new StatelessConfig();
		config.injector = injector;
		
		config.map( IMockInterface, MockClass, 'name' );
		
        Assert.equals( IMockInterface, injector.clazz, "parameters should be the same" );
        Assert.isInstanceOf( injector.value, MockClass, "parameters should be the same" );
		Assert.equals( 'name', injector.name, "parameters should be the same" );
    }
	
	@Test( "Test 'mapToSingleton' behavior" )
    public function testMapToSingleton() : Void
    {
		var injector = new MockInjectorForMapAsSingletonTest();
		var config = new StatelessConfig();
		config.injector = injector;
		
		config.mapToSingleton( IMockInterface, MockClass, 'name' );
		
        Assert.equals( IMockInterface, injector.clazz, "parameters should be the same" );
        Assert.equals( MockClass, injector.type, "parameters should be the same" );
		Assert.equals( 'name', injector.name, "parameters should be the same" );
    }
	
	@Test( "Test class is designed for injection" )
    public function testClassIsDesignedForInjection() : Void
    {
		var b = MacroUtil.classImplementsInterface( hex.config.stateless.StatelessConfig, hex.di.IInjectorContainer );
        Assert.isTrue( b, "'StatelessConfig' class should implement 'IInjectorContainer' interface" );
    }
	
	@Test( "Test class implements IStatelessConfig" )
    public function testClassImplementsIStatelessConfig() : Void
    {
		var b = MacroUtil.classImplementsInterface( hex.config.stateless.StatelessConfig, hex.config.stateless.IStatelessConfig );
        Assert.isTrue( b, "'StatelessConfig' class should implement 'IStatelessConfig' interface" );
    }
}

private interface IMockInterface
{
	
}

private class MockClass implements IMockInterface
{
	
}

private class MockInjectorForMapAsSingletonTest extends MockDependencyInjector
{
	public var clazz	: Class<Dynamic>;
	public var type		: Class<Dynamic>;
	public var name		: String;
	
	override public function mapToSingleton( clazz : Class<Dynamic>, type : Class<Dynamic>, name : String = '' ) : Void 
	{
		this.clazz 	= clazz;
		this.type 	= type;
		this.name 	= name;
	}
}

private class MockInjectorForMapToValueTest extends MockDependencyInjector
{
	public var clazz	: Class<Dynamic>;
	public var value	: Dynamic;
	public var name		: String;
	
	override public function mapToValue( clazz : Class<Dynamic>, value : Dynamic, ?name : String = '' ) : Void 
	{
		this.clazz 	= clazz;
		this.value 	= value;
		this.name 	= name;
	}
}