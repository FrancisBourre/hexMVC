package hex.view.viewhelper;

import hex.event.MessageType;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Tamas Kinsztler
 */
class MainViewHelperManagerMessageTest
{
	@Test( "Test 'VIEW_HELPER_MANAGER_CREATION' property" )
	public function testOnViewHelperManagerCreationProperty() : Void
	{
		var message = MainViewHelperManagerMessage.VIEW_HELPER_MANAGER_CREATION;
		Assert.isInstanceOf( message, MessageType, "'MainViewHelperManagerMessage.VIEW_HELPER_MANAGER_CREATION' should be an instance of 'MessageType'" );
		Assert.equals( "onViewHelperManagerCreation", message.name, "'name' property should be the same" );
	}
	
	@Test( "Test 'VIEW_HELPER_MANAGER_RELEASE' property" )
	public function testViewHelperManagerReleaseProperty() : Void
	{
		var message = MainViewHelperManagerMessage.VIEW_HELPER_MANAGER_RELEASE;
		Assert.isInstanceOf( message, MessageType, "'MainViewHelperManagerMessage.VIEW_HELPER_MANAGER_RELEASE' should be an instance of 'MessageType'" );
		Assert.equals( "onViewHelperManagerRelease", message.name, "'name' property should be the same" );
	}
}
