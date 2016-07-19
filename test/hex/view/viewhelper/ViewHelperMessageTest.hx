package hex.view.viewhelper;

import hex.event.MessageType;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Tamas Kinsztler
 */
class ViewHelperMessageTest
{
		@Test( "Test 'onInit'" )
	  public function testOnInit() : Void
	  {
	    	var staticVariable = ViewHelperMessage.INIT;
        var message = new MessageType( "onInit" );
	      Assert.equals( message.name, staticVariable.name, "onInit should exist" );
	  }

    @Test( "Test 'onRelease'" )
	  public function testOnRelease() : Void
	  {
	    	var staticVariable = ViewHelperMessage.RELEASE;
        var message = new MessageType( "onRelease" );
	      Assert.equals( message.name, staticVariable.name, "onRelease should exist" );
	  }

    @Test( "Test 'onAttachView'" )
	  public function testOnAttachView() : Void
	  {
	    	var staticVariable = ViewHelperMessage.ATTACH_VIEW;
        var message = new MessageType( "onAttachView" );
	      Assert.equals( message.name, staticVariable.name, "onAttachView should exist" );
	  }

    @Test( "Test 'onRemoveView'" )
	  public function testOnRemoveView() : Void
	  {
	    	var staticVariable = ViewHelperMessage.REMOVE_VIEW;
        var message = new MessageType( "onRemoveView" );
	      Assert.equals( message.name, staticVariable.name, "onRemoveView should exist" );
	  }
}
