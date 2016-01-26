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
	
	@Before
    public function setUp() : Void
    {
        this.factory = new DefaultHTTPServiceParameterFactory();
    }

    @After
    public function tearDown() : Void
    {
        this.factory = null;
    }
	
	@Test("Test normal parameter passing")
	public function testSetParameters( ):Void
	{
		var request= new MockHttp( "http://google.com" );
		var params= new MockHttpParameters();
		this.factory.setParameters(request, params);
		
		Assert.equals( "green", request.paramMap.get("apple"), "the request should contain the apple param" );
		Assert.equals( "mundo", request.paramMap.get("hola"), "the request should contain the hola param" );
	}
	
	@Test("Test mapping with excluded params")
	public function testSetParameters_withExludedParams( ):Void
	{
		var request= new MockHttp( "http://google.com" );
		var params= new MockHttpParameters();
		this.factory.setParameters(request, params, ["apple"]);
		
		Assert.equals( null, request.paramMap.get("apple"), "the request should NOT contain the apple param" );
		Assert.equals( "mundo", request.paramMap.get("hola"), "the request should contain the hola param" );
	}
	
	@Test("Test if a null parameter converted to emty string")
	public function testSetParameters_withNullParam( ):Void
	{
		var request= new MockHttp( "http://google.com" );
		var params= new MockHttpParameters();
		params.hola = null;
		this.factory.setParameters(request, params);
		
		Assert.equals( "green", request.paramMap.get("apple"), "the request should contain the apple param" );
		Assert.equals( "", request.paramMap.get("hola"), "the request should contain nullProp as empty string" );
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
	public var paramMap= new StringMap();
	
	override public function addParameter(param:String, value:String):Http 
	{
		var result = super.setParameter(param, value);
		this.paramMap.set(param, value);
		return result;
	}
}