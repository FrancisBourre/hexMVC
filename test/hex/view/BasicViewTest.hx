package hex.view;

import hex.di.IInjectorContainer;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Tamas Kinsztler
 */
class BasicViewTest
{
	@Test( "Test BasicView is injectable" )
	public function testIsInjectable() : Void
	{
		var view = new BasicView();
		Assert.isTrue( hex.util.MacroUtil.classImplementsInterface( BasicView, IInjectorContainer ), "'BasicView' should implement 'IInjectorContainer'" );
	}
}
