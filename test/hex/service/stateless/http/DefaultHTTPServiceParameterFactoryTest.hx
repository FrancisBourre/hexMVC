package hex.service.stateless.http;
import haxe.ds.HashMap;
import haxe.ds.StringMap;
import haxe.Http;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author duke
 */
class DefaultHTTPServiceParameterFactoryTest
{

	public var factory : DefaultHTTPServiceParameterFactory;
	
	@setUp
    public function setUp() : Void
    {
        this.factory = new DefaultHTTPServiceParameterFactory();
    }

    @tearDown
    public function tearDown() : Void
    {
        this.factory = null;
    }
	
	@test
	public function testSetParameters( ):Void
	{
		var request:MockHttp = new MockHttp( "http://google.com" );
		var params:MockHttpParameters = new MockHttpParameters();
		this.factory.setParameters(request, params);
		
		Assert.equals( "green", request.paramMap.get("apple"), "the request should contain the apple param" );
		Assert.equals( "mundo", request.paramMap.get("hola"), "the request should contain the hola param" );
	}
	
	@test
	public function testSetParameters_withExludedParams( ):Void
	{
		var request:MockHttp = new MockHttp( "http://google.com" );
		var params:MockHttpParameters = new MockHttpParameters();
		this.factory.setParameters(request, params, ["apple"]);
		
		Assert.equals( null, request.paramMap.get("apple"), "the request should NOT contain the apple param" );
		Assert.equals( "mundo", request.paramMap.get("hola"), "the request should contain the hola param" );
	}
}

private class MockHttpParameters extends HTTPServiceParameters
{
	public var apple:String = "green";
	public var hola:String = "mundo";
	
	public function new()
	{
		super();
	}
}

private class MockHttp extends Http
{
	public var paramMap:StringMap<Dynamic> = new StringMap();
	
	override public function addParameter(param:String, value:String):Http 
	{
		var result = super.setParameter(param, value);
		this.paramMap.set(param, value);
		return result;
	}
}