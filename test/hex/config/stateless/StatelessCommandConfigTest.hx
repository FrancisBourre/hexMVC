package hex.config.stateless;

import hex.error.VirtualMethodException;
import hex.di.InjectionEvent;
import hex.control.command.BasicCommand;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.control.IFrontController;
import hex.di.IDependencyInjector;
import hex.event.Dispatcher;
import hex.event.MessageType;
import hex.module.MockModule;
import hex.unittest.assertion.Assert;

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
	      Assert.methodCallThrows( VirtualMethodException, config, config.configure, [], "configure should throw VirtualMethodException" );
	  }
}
