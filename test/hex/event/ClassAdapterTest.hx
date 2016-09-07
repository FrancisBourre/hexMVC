package hex.event;

import hex.control.macro.MacroExecutor;
import hex.control.payload.ExecutionPayload;
import hex.di.Injector;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class ClassAdapterTest
{
	var _classAdapter 	: ClassAdapter;
	var _scopeValue 	: Int;
	
	@Test( "Test simple call to getCallbackAdapter" )
    public function testSimpleCallToGetCallbackAdapter() : Void
    {
		this._classAdapter = new ClassAdapter();
		this._classAdapter.setCallBackMethod( this, this.simpleCallbackTest );
		this._classAdapter.setAdapterClass( MockAdapterClass );
		this._classAdapter.getCallbackAdapter()( "hello", 4 );
    }
	
	@Test( "Test simple call to getCallbackAdapter with custom method name" )
    public function testSimpleCallToGetCallbackAdapterWithCustomMethodName() : Void
    {
		this._classAdapter = new ClassAdapter();
		this._classAdapter.setCallBackMethod( this, this.simpleCallbackTest );
		this._classAdapter.setAdapterClass( MockAdapterClassWithCustomMethodName, "adaptThis" );
		this._classAdapter.getCallbackAdapter()( "hello", 4 );
    }
	
	function simpleCallbackTest( s1 : String, i1 : Int, s : String, i : Int ) : Void
	{
		Assert.equals( "test", s1, "'getCallbackAdapter' should return 'test'" );
		Assert.equals( 1, i1, "'getCallbackAdapter' should return 1" );
		Assert.equals( "hello", s, "'getCallbackAdapter' should return 'hello'" );
		Assert.equals( 4, i, "'getCallbackAdapter' should return 4" );
	}
	
	@Test( "Test call to getCallbackAdapter with factory" )
    public function testCallToGetCallbackAdapterWithFactory() : Void
    {
		this._classAdapter = new ClassAdapter();
		this._classAdapter.setCallBackMethod( this, this.factoryCallbackTest );
		this._classAdapter.setAdapterClass( MockAdapterClassForFactory );
		this._classAdapter.setFactoryMethod( this, this.factoryForAdapterClass );
		this._scopeValue = 3;
		this._classAdapter.getCallbackAdapter()( "mundo", 6 );
	}
	
	function factoryForAdapterClass( adapterClass : Class<Dynamic> ) : Dynamic
	{
		return cast Type.createInstance( adapterClass, [this._scopeValue] );
	}
	
	function factoryCallbackTest( s1 : String, i1 : Int, s : String, i : Int ) : Void
	{
		Assert.equals( "test3", s1, "'getCallbackAdapter' should return 'test3'" );
		Assert.equals( 4, i1, "'getCallbackAdapter' should return 4" );
		Assert.equals( "mundo3", s, "'getCallbackAdapter' should return 'mundo'" );
		Assert.equals( 9, i, "'getCallbackAdapter' should return 9" );
	}
	
	@Test( "Test call to getCallbackAdapter with MacroAdapterStrategy" )
    public function testCallToGetCallbackAdapterWithAdapterMacro() : Void
    {
		this._classAdapter = new ClassAdapter();
		this._classAdapter.setCallBackMethod( this, this.macroCallbackTest );
		this._classAdapter.setAdapterClass( MockMacroAdapterStrategy );
		this._classAdapter.setFactoryMethod( this, this.factoryForMacroClass );
		this._classAdapter.getCallbackAdapter()( [ new MockValueObject( "hola" ), new MockValueObject( "mundo" ) ] );
	}
	
	function factoryForMacroClass( adapterClass : Class<IAdapterStrategy> ) : IAdapterStrategy
	{
		var m : MacroAdapterStrategy = cast Type.createInstance( adapterClass, [] );
		var me = new MacroExecutor();
		me.injector = new Injector();
		m.macroExecutor = me;
		return m;
	}
	
	function macroCallbackTest( args : Array<MockValueObject> ) : Void
	{
		Assert.equals( "hola!", args[ 0 ].value, "'getCallbackAdapter' should return 'hola'" );
		Assert.equals( "mundo!", args[ 1 ].value, "'getCallbackAdapter' should return 'mundo'" );
	}
}

private class MockAdapterClass
{
	public function new()
	{
		
	}

	public function adapt( s : String, i : Int ) : Array<Dynamic> 
	{
		return [ "test", 1, s, i ];
	}
}

private class MockAdapterClassWithCustomMethodName
{
	public function new()
	{
		
	}

	public function adaptThis( s : String, i : Int ) : Array<Dynamic> 
	{
		return [ "test", 1, s, i ];
	}
}

private class MockAdapterClassForFactory
{
	var _value : Int;
	
	public function new( value : Int )
	{
		this._value = value;
	}

	public function adapt( s : String, i : Int ) : Array<Dynamic> 
	{
		return ["test" +this._value, 1 +this._value, s + this._value, i + this._value ];
	}
}

private class MockMacroAdapterStrategy extends MacroAdapterStrategy
{
	var data0 : MockValueObject;
	var data1 : MockValueObject;
	
	public function new()
	{
		super( this, this.onAdapt );
	}
	
	override function _prepare() : Void
	{
		this.add( MockAsyncCommand ).withPayload( new ExecutionPayload( data0, MockValueObject ) );
		this.add( MockAsyncCommand ).withPayload( new ExecutionPayload( data1, MockValueObject ) );
	}

	public function onAdapt( data0 : MockValueObject, data1 : MockValueObject ) : Void
	{
		this.data0 = data0;
		this.data1 = data1;
	}
	
	override public function getResult() : Array<Dynamic> 
	{
		return [ this.data0, this.data1 ];
	}
}