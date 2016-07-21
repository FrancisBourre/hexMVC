package hex.view.viewhelper;

import hex.event.MessageType;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Tamas Kinsztler
 */
class ViewHelperManagerMessageTest
{
		@Test( "Test 'onViewHelperCreation'" )
	  public function testOnViewHelperCreation() : Void
	  {
	    	var staticVariable = ViewHelperManagerMessage.VIEW_HELPER_CREATION;
        var message = new MessageType( "onViewHelperCreation" );
	      Assert.equals( message.name, staticVariable.name, "onViewHelperCreation should exist" );
	  }

    @Test( "Test 'onViewHelperRelease'" )
	  public function testOnViewHelperRelease() : Void
	  {
	    	var staticVariable = ViewHelperManagerMessage.VIEW_HELPER_RELEASE;
        var message = new MessageType( "onViewHelperRelease" );
	      Assert.equals( message.name, staticVariable.name, "onViewHelperRelease should exist" );
	  }
}
