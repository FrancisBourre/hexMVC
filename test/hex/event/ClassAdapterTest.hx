package hex.event;

import hex.control.async.AsyncCommand;
import hex.control.macro.MacroExecutor;
import hex.control.payload.ExecutionPayload;
import hex.control.Request;
import hex.inject.Injector;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class ClassAdapterTest
{
	private var _classAdapter 	: ClassAdapter;
	private var _scopeValue 	: Int;
	
	@Test( "Test simple call to getCallbackAdapter" )
    public function testSimpleCallToGetCallbackAdapter() : Void
    {
		this._classAdapter = new ClassAdapter();
		this._classAdapter.setCallBackMethod( this, this.simpleCallbackTest );
		this._classAdapter.setAdapterClass( MockAdapterClass );
		
		this.triggerCallbackAdapter( this._classAdapter.getCallbackAdapter() );
    }
	
	private function triggerCallbackAdapter( callbackAdapter : Dynamic ) : Void
	{
		callbackAdapter( "hello", 4 );
	}
	
	private function simpleCallbackTest( s1 : String, i1 : Int, s : String, i : Int ) : Void
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
		this.triggerCallbackAdapterWithFactory( this._classAdapter.getCallbackAdapter() );
	}
	
	private function factoryForAdapterClass( adapterClass : Class<IAdapterStrategy> ) : IAdapterStrategy
	{
		return cast Type.createInstance( adapterClass, [this._scopeValue] );
	}
	
	private function triggerCallbackAdapterWithFactory( callbackAdapter : Dynamic ) : Void
	{
		callbackAdapter( "mundo", 6 );
	}
	
	private function factoryCallbackTest( s1 : String, i1 : Int, s : String, i : Int ) : Void
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
		this.triggerCallbackAdapterWithMacro( this._classAdapter.getCallbackAdapter() );
	}
	
	private function triggerCallbackAdapterWithMacro( callbackAdapter : Dynamic ) : Void
	{
		var data0 : MockValueObject = new MockValueObject( "hola" );
		var data1 : MockValueObject = new MockValueObject( "mundo" );
		callbackAdapter( [ data0, data1 ] );
	}
	
	private function factoryForMacroClass( adapterClass : Class<IAdapterStrategy> ) : IAdapterStrategy
	{
		var m : MacroAdapterStrategy = cast Type.createInstance( adapterClass, [] );
		var me : MacroExecutor = new MacroExecutor();
		me.injector = new Injector();
		m.macroExecutor = me;
		return m;
	}
	
	private function macroCallbackTest( args : Array<MockValueObject> ) : Void
	{
		Assert.equals( "hola!", args[ 0 ].value, "'getCallbackAdapter' should return 'hola'" );
		Assert.equals( "mundo!", args[ 1 ].value, "'getCallbackAdapter' should return 'mundo'" );
	}
	
}

private class MockAdapterClass implements IAdapterStrategy
{
	public function new()
	{
		
	}

	public function adapt( args : Array<Dynamic> ) : Array<Dynamic> 
	{
		return ["test", 1, args[0], args[1] ];
	}
}

private class MockAdapterClassForFactory implements IAdapterStrategy
{
	private var _value : Int;
	
	public function new( value : Int )
	{
		this._value = value;
	}

	public function adapt( args : Array<Dynamic> ) : Array<Dynamic> 
	{
		return ["test" +this._value, 1 +this._value, args[0] +this._value, args[1] +this._value ];
	}
}

private class MockMacroAdapterStrategy extends MacroAdapterStrategy
{
	private var data0 : MockValueObject;
	private var data1 : MockValueObject;
	
	public function new()
	{
		super( this, this.onAdapt );
	}
	
	override private function _prepare() : Void
	{
		this.add( MockAsyncCommand ).withPayloads( [new ExecutionPayload( data0, MockValueObject )] );
		this.add( MockAsyncCommand ).withPayloads( [new ExecutionPayload( data1, MockValueObject )] );
	}

	public function onAdapt( data0 : MockValueObject, data1 : MockValueObject ) : Void
	{
		this.data0 = data0;
		this.data1 = data1;
	}
	
	override public function getPayload() : Array<Dynamic> 
	{
		return [ this.data0, this.data1 ];
	}
}

private class MockValueObject
{
	public var value : String;
	
	public function new( value :  String )
	{
		this.value = value;
	}
}

@:rtti
private class MockAsyncCommand extends AsyncCommand
{
	@Inject
	public var data : MockValueObject;
	
	override public function execute( ?request : Request ) : Void
    {
		this.data.value += "!";
		this._handleComplete();
	}
}