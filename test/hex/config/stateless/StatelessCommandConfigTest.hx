package hex.config.stateless;

import hex.control.IFrontController;
import hex.control.command.BasicCommand;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.error.VirtualMethodException;
import hex.event.MessageType;
import hex.unittest.assertion.Assert;
import hex.util.MacroUtil;

/**
 * ...
 * @author Tamas Kinsztler
 */
class StatelessCommandConfigTest
{
	@Test( "Test 'configure' throws 'VirtualMethodException'" )
	public function testConfigureThrowsVirtualMethodException() : Void
	{
		var config = new StatelessCommandConfig();
		Assert.methodCallThrows( VirtualMethodException, config, config.configure, [], "configure should throw 'VirtualMethodException'" );
	}

	@Test( "Test 'map' behavior" )
    public function testMapBehavior() : Void
    {
		var controller = new MockFrontController();
		var config = new StatelessCommandConfig();
		config.frontController = controller;
		
		var messageType = new MessageType( "test" );
		config.map( messageType, BasicCommand );
		
        Assert.deepEquals( [ messageType, BasicCommand ], controller.mapParameters, "parameters should be the same" );
    }

	@Test( "Test class is designed for injection" )
    public function testClassIsDesignedForInjection() : Void
    {
		var b = MacroUtil.classImplementsInterface( hex.config.stateless.StatelessCommandConfig, hex.di.IInjectorContainer );
        Assert.isTrue( b, "'StatelessCommandConfig' class should implement 'IInjectorContainer' interface" );
    }
	
	@Test( "Test class implements IStatelessConfig" )
    public function testClassImplementsIStatelessConfig() : Void
    {
		var b = MacroUtil.classImplementsInterface( hex.config.stateless.StatelessCommandConfig, hex.config.stateless.IStatelessConfig );
        Assert.isTrue( b, "'StatelessCommandConfig' class should implement 'IStatelessConfig' interface" );
    }
}

private class MockFrontController implements IFrontController
{
	public var mapParameters : Array<Dynamic>;
	
	public function new()
	{
		
	}
	
	public function map( messageType : MessageType, commandClass : Class<ICommand> ) : ICommandMapping 
	{
		this.mapParameters = [ messageType, commandClass ];
		return null;
	}
	
	public function unmap( messageType : MessageType ) : ICommandMapping
	{
		return null;
	}
}