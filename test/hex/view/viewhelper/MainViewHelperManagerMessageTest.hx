package hex.view.viewhelper;

import hex.event.MessageType;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Tamas Kinsztler
 */
class MainViewHelperManagerMessageTest
{
		@Test( "Test 'onViewHelperManagerCreation'" )
	  public function testOnViewHelperManagerCreation() : Void
	  {
	    	var staticVariable = MainViewHelperManagerMessage.VIEW_HELPER_MANAGER_CREATION;
        var message = new MessageType( "onViewHelperManagerCreation" );
	      Assert.equals( message.name, staticVariable.name, "onViewHelperManagerCreation should exist" );
	  }

    @Test( "Test 'onViewHelperManagerRelease'" )
	  public function testOnViewHelperManagerRelease() : Void
	  {
	    	var staticVariable = MainViewHelperManagerMessage.VIEW_HELPER_MANAGER_RELEASE;
        var message = new MessageType( "onViewHelperManagerRelease" );
	      Assert.equals( message.name, staticVariable.name, "onViewHelperManagerRelease should exist" );
	  }
}
