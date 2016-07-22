package hex.view.viewhelper;

import hex.event.MessageType;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Tamas Kinsztler
 */
class ViewHelperManagerMessageTest
{
	@Test( "Test 'VIEW_HELPER_CREATION' property" )
	public function testViewHelperCreationProperty() : Void
	{
		var message = ViewHelperManagerMessage.VIEW_HELPER_CREATION;
		Assert.isInstanceOf( message, MessageType, "'ViewHelperManagerMessage.VIEW_HELPER_CREATION' should be an instance of 'MessageType'" );
		Assert.equals( "onViewHelperCreation", message.name, "'name' property should be the same" );
	}

	@Test( "Test 'VIEW_HELPER_RELEASE' property" )
	public function testViewHelperReleaseProperty() : Void
	{
		var message = ViewHelperManagerMessage.VIEW_HELPER_RELEASE;
		Assert.isInstanceOf( message, MessageType, "'ViewHelperManagerMessage.VIEW_HELPER_RELEASE' should be an instance of 'MessageType'" );
		Assert.equals( "onViewHelperRelease", message.name, "'name' property should be the same" );
	}
}
