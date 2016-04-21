package hex.control;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class ControllerTest
{
	var _controller 		: MockController;

    @Before
    public function setUp() : Void
    {
        this._controller = new MockController();
    }

    @After
    public function tearDown() : Void
    {
        this._controller = null;
    }
	
	@Test( "test controller call with mapping" )
	public function testControllerCallWithMapping() : Void
	{
		this._controller.print( "hola mundo" );
		Assert.equals( "hola mundo", MockCommandClass.lastExecuteParam, "" );
	}
	
	@Test( "test controller call without mapping" )
	public function testControllerCallWithoutMapping() : Void
	{
		Assert.equals( 5, this._controller.sum( 2, 3 ), "" );
	}
}

private class MockController extends Controller implements IMockController
{
	@CommandClass( "hex.control.MockCommandClass" )
	//@FireOnce( true )
	//@MethodName( "doSomething" )
	public function print( text : String ) : Void { }

	public function sum( a : Int, b : Int ) : Int 
	{ 
		return a + b;
	}
}

private interface IMockController extends IController
{
	function print( text : String ) : Void;
	function sum( a : Int, b : Int ) : Int ;
}