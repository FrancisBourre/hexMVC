package hex.view.viewhelper;

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
		Assert.equals( "onViewHelperManagerCreation", message, "'name' property should be the same" );
	}
	
	@Test( "Test 'VIEW_HELPER_MANAGER_RELEASE' property" )
	public function testViewHelperManagerReleaseProperty() : Void
	{
		var message = MainViewHelperManagerMessage.VIEW_HELPER_MANAGER_RELEASE;
		Assert.equals( "onViewHelperManagerRelease", message, "'name' property should be the same" );
	}
}
