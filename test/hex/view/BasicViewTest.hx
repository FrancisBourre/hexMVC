package hex.view;

import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Tamas Kinsztler
 */
class BasicViewTest
{
		@Test( "Test 'visible' property" )
	  public function testVisibleProperty() : Void
	  {
	    	var view = new BasicView();
	      Assert.isTrue( view.visible, "view should be visible by default" );

				view.visible = false;
				Assert.isFalse( view.visible, "view should not be visible when 'visible' property is set to false" );

				view.visible = true;
				Assert.isTrue( view.visible, "view should be visible when 'visible' property is set to true" );
	  }
}
