package hex.view.viewhelper;

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
		Assert.equals( "onInit", message, "'name' property should be the same" );
	}

	@Test( "Test 'RELEASE' property" )
	public function testReleaseProperty() : Void
	{
		var message = ViewHelperMessage.RELEASE;
		Assert.equals( "onRelease", message, "'name' property should be the same" );
	}

	@Test( "Test 'ATTACH_VIEW' property" )
	public function testAttachViewProperty() : Void
	{
		var message = ViewHelperMessage.ATTACH_VIEW;
		Assert.equals( "onAttachView", message, "'name' property should be the same" );
	}

	@Test( "Test 'REMOVE_VIEW' property" )
	public function testRemoveViewProperty() : Void
	{
		var message = ViewHelperMessage.REMOVE_VIEW;
		Assert.equals( "onRemoveView", message, "'name' property should be the same" );
	}
}
