package hex.model;

import hex.di.IInjectorContainer;
import hex.unittest.assertion.Assert;
import hex.util.MacroUtil;

/**
 * ...
 * @author Francis Bourre
 */
class BasicModelTest
{
    @Test( 'test constructor' )
	function testConstructor() : Void
    {
        var model = new MockModel();

		//Assert.isTrue( MacroUtil.classImplementsInterface( MockModel, IInjectorContainer ), "'BasicModel' should be injectable" );
    }
}

private class MockModel extends BasicModel<MockModelDispatcher, IMockModelListener>
{
    public function new() 
	{
		super();
	}
}

private interface IMockModelListener
{
    function onModelChange( data : MockData ) : Void;
}

private class MockModelDispatcher extends ModelDispatcher<IMockModelListener> implements IMockModelListener
{
	public function new() 
	{
		super();
	}
	
	public function onModelChange( data : MockData ) : Void
	{
		//Method will be implemented @compile time by macro
	}
}

typedef MockData =
{

}