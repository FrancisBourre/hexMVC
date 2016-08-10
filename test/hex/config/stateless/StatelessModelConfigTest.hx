package hex.config.stateless;

import hex.error.VirtualMethodException;
import hex.unittest.assertion.Assert;
import hex.util.MacroUtil;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessModelConfigTest
{
	@Test( "Test 'configure' throws 'VirtualMethodException'" )
	public function testConfigureThrowsVirtualMethodException() : Void
	{
		var config = new StatelessModelConfig();
		Assert.methodCallThrows( VirtualMethodException, config, config.configure, [], "configure should throw 'VirtualMethodException'" );
	}
	
	@Test( "Test 'map' behavior" )
    public function testMapBehavior() : Void
    {
		var injector = new MockInjectorForMapToValueTest();
		var config = new StatelessModelConfig();
		config.injector = injector;
		
		config.map( IMockModel, MockModel, 'name' );
		
        Assert.equals( IMockModel, injector.clazz[ 0 ], "parameters should be the same" );
        Assert.isInstanceOf( injector.value[ 0 ], MockModel, "parameters should be the same" );
		Assert.equals( 'name', injector.name[ 0 ], "parameters should be the same" );
		
		Assert.equals( IMockModelRO, injector.clazz[ 1 ], "parameters should be the same" );
        Assert.isInstanceOf( injector.value[ 1 ], MockModel, "parameters should be the same" );
		Assert.equals( 'name', injector.name[ 1 ], "parameters should be the same" );
    }
	
	@Test( "Test class is designed for injection" )
    public function testClassIsDesignedForInjection() : Void
    {
		var b = MacroUtil.classImplementsInterface( hex.config.stateless.StatelessModelConfig, hex.di.IInjectorContainer );
        Assert.isTrue( b, "'StatelessModelConfig' class should implement 'IInjectorContainer' interface" );
    }
	
	@Test( "Test class implements IStatelessConfig" )
    public function testClassImplementsIStatelessConfig() : Void
    {
		var b = MacroUtil.classImplementsInterface( hex.config.stateless.StatelessModelConfig, hex.config.stateless.IStatelessConfig );
        Assert.isTrue( b, "'StatelessModelConfig' class should implement 'IStatelessConfig' interface" );
    }
}

private interface IMockModelRO
{
	
}

private interface IMockModel extends IMockModelRO
{
	
}

private class MockModel implements IMockModel
{
	
}

private class MockInjectorForMapToValueTest extends MockDependencyInjector
{
	public var clazz	: Array<Class<Dynamic>>		= [];
	public var value	: Array<Dynamic>			= [];
	public var name		: Array<String>				= [];
	
	override public function mapToValue( clazz : Class<Dynamic>, value : Dynamic, ?name : String = '' ) : Void 
	{
		this.clazz.push( clazz );
		this.value.push( value );
		this.name.push( name );
	}
}