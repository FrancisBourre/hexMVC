package hex.view.viewhelper;

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
		Assert.equals( "onViewHelperCreation", message, "'name' property should be the same" );
	}

	@Test( "Test 'VIEW_HELPER_RELEASE' property" )
	public function testViewHelperReleaseProperty() : Void
	{
		var message = ViewHelperManagerMessage.VIEW_HELPER_RELEASE;
		Assert.equals( "onViewHelperRelease", message, "'name' property should be the same" );
	}
}
