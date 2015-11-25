package hex.control.payload;

import hex.control.payload.ExecutionPayload;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class ExecutionPayloadTest
{

	private var _data 				: MockData;
	private var _executionPayload 	: ExecutionPayload;

    @setUp
    public function setUp() : Void
    {
        this._data 				= new MockData();
        this._executionPayload 	= new ExecutionPayload( this._data, IMockData, "name" );
    }

    @tearDown
    public function tearDown() : Void
    {
        this._data 				= null;
        this._executionPayload 	= null;
    }
	
	@test( "Test constructor" )
    public function testConstructor() : Void
    {
        Assert.assertEquals( this._data, this._executionPayload.getData(), "data should be the same" );
        Assert.assertEquals( IMockData, this._executionPayload.getType(), "type should be the same" );
        Assert.assertEquals( "name", this._executionPayload.getName(), "name should be the same" );
    }
	
	@test( "Test overwriting type property" )
    public function testOverwritingType() : Void
    {
		this._executionPayload.withClass( IMockType );
        Assert.failEquals( IMockData, this._executionPayload.getType(), "type should not be the same" );
        Assert.assertEquals( IMockType, this._executionPayload.getType(), "type should be the same" );
    }
	
	@test( "Test overwriting name property" )
    public function testOverwritingName() : Void
    {
		this._executionPayload.withName( "anotherName" );
        Assert.failEquals( "name", this._executionPayload.getName(), "name should not be the same" );
        Assert.assertEquals( "anotherName", this._executionPayload.getName(), "name should be the same" );
    }
	
	@test( "Test passing no name parameter to constructor" )
    public function testNoNameParameterToConstructor() : Void
    {
		var executionPayload : ExecutionPayload = new ExecutionPayload( this._data, IMockData );
        Assert.assertEquals( "", executionPayload.getName(), "name should be empty String" );
    }
}

private class MockData implements IMockData
{
	public function new()
	{
		
	}
}

private interface IMockData
{
	
}

private interface IMockType
{
	
}