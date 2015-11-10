package service.stateless;

import hex.data.IParser;
import hex.unittest.assertion.Assert;
import service.AbstractServiceTest;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessServiceTest extends AbstractServiceTest
{
	@test( "test result accessors" )
	public function testResult() : Void
	{
		var service : MockStatelessService = new MockStatelessService();
		service.result = "result";
		Assert.assertEquals( "result", service.result, "result getter should provide result setted value" );
	}
	
	@test( "test result accessors with parser" )
	public function testResultWithParser() : Void
	{
		var service : MockStatelessService = new MockStatelessService();
		service.setParser( new MockParser() );
		service.result = 5;
		Assert.assertEquals( 6, service.result, "result getter should provide result parsed value" );
	}
}

private class MockParser implements IParser
{
	public function new()
	{
		
	}

	public function parse( serializedContent : Dynamic, target : Dynamic = null) : Dynamic 
	{
		return serializedContent + 1;
	}
}