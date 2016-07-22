package hex.view.viewhelper;

import hex.event.MessageType;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Tamas Kinsztler
 */
class ViewHelperMessageTest
{
	@Test( "Test 'INIT' property" )
	public function testInitProperty() : Void
	{
		var message = ViewHelperMessage.INIT;
		Assert.isInstanceOf( message, MessageType, "'ViewHelperMessage.INIT' should be an instance of 'MessageType'" );
		Assert.equals( "onInit", message.name, "'name' property should be the same" );
	}

	@Test( "Test 'RELEASE' property" )
	public function testReleaseProperty() : Void
	{
		var message = ViewHelperMessage.RELEASE;
		Assert.isInstanceOf( message, MessageType, "'ViewHelperMessage.RELEASE' should be an instance of 'MessageType'" );
		Assert.equals( "onRelease", message.name, "'name' property should be the same" );
	}

	@Test( "Test 'ATTACH_VIEW' property" )
	public function testAttachViewProperty() : Void
	{
		var message = ViewHelperMessage.ATTACH_VIEW;
		Assert.isInstanceOf( message, MessageType, "'ViewHelperMessage.ATTACH_VIEW' should be an instance of 'MessageType'" );
		Assert.equals( "onAttachView", message.name, "'name' property should be the same" );
	}

	@Test( "Test 'REMOVE_VIEW' property" )
	public function testRemoveViewProperty() : Void
	{
		var message = ViewHelperMessage.REMOVE_VIEW;
		Assert.isInstanceOf( message, MessageType, "'ViewHelperMessage.REMOVE_VIEW' should be an instance of 'MessageType'" );
		Assert.equals( "onRemoveView", message.name, "'name' property should be the same" );
	}
}
