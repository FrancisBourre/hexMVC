package hex.view;

import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Tamas Kinsztler
 */
class BasicViewTest
{
		@Test( "Test constructor" )
	  public function testConstructor() : Void
	  {
	    	var basicView = new BasicView();
	      Assert.equals( "hex.view.BasicView", Type.getClassName( Type.getClass( basicView ) ), "BasicView constructor should create an object with correct type" );
	  }
}
