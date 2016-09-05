package hex.model;

import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class BasicModelTest
{
    @Test( 'test constructor' )
	function testConstructor() : Void
    {
        //var model = new MockModel();
		//Assert.isInstanceOf( model, Model, "model should be an instance of 'Model'" );
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