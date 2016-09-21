package hex.event;

import haxe.Timer;
import hex.control.Request;
import hex.control.async.AsyncCommand;
import hex.control.async.IAsyncCommand;
import hex.control.macro.MacroExecutor;
import hex.control.payload.ExecutionPayload;
import hex.di.Injector;
import hex.unittest.assertion.Assert;
import hex.unittest.runner.MethodRunner;

/**
 * ...
 * @author Francis
 */
class MacroAdapterStrategyTest
{
	var _classAdapter 	: ClassAdapter;
	var _result 		: Array<String>;
	
	@Async( "Test execution" )
	public function testExecution() : Void
	{
		this._classAdapter = new ClassAdapter();
		this._classAdapter.setCallBackMethod( this, this.macroCallbackTest );
		this._classAdapter.setAdapterClass( MockAdapterStrategyMacro );
		this._classAdapter.setFactoryMethod( this, this.factoryForMacroClass );
		
		var params : Array<Dynamic> = [ new MockRequest(), "test" ];
		this._classAdapter.getCallbackAdapter()( params );
		
		Timer.delay( MethodRunner.asyncHandler( this._onTestEnd ), 100 );
	}
	
	function factoryForMacroClass( adapterClass : Class<IAdapterStrategy> ) : IAdapterStrategy
	{
		var m : MacroAdapterStrategy = cast Type.createInstance( adapterClass, [] );
		var me = new MacroExecutor();
		me.injector = new Injector();
		m.macroExecutor = me;
		return m;
	}
	
	function macroCallbackTest( result : Array<String> ) : Void
	{
		this._result = result;
	}
	
	function _onTestEnd() : Void
	{
		Assert.equals( "testMessage", this._result[ 0 ], "macro result should return expected value" );
	}
	
}

private class MockRequest extends Request
{
	public var message : String;
	
	public function new()
	{
		super();
		this.message = "Message";
	}
}

private class MockAdapterStrategyMacro extends MacroAdapterStrategy
{
	var _message : String;

	public function new()
	{
		super( this, this.onAdapt );
	}

	public function onAdapt( request : MockRequest, message : String ) : Void
	{
		this._request = request;
		this._message = message;
	}

	override function _prepare() : Void
	{
		this.add( MockAdapterStrategyCommand ).withPayload( new ExecutionPayload( this._message, String ) ).withCompleteHandler( this._end );
	}

	function _end( async : IAsyncCommand ) : Void
	{
		this._result = async.getResult();
	}
}

private class MockAdapterStrategyCommand extends AsyncCommand
{
	public function new() 
	{
		super();
	}

	@Inject
	public var message : String;

	public function execute( request : MockRequest ) : Void
	{
		this.message += request.message;
		Timer.delay( this.testAsyncCallback, 50 );
	}
	
	override public function getResult() : Array<Dynamic> 
	{
		return [ message ];
	}

	function testAsyncCallback() : Void
	{
		this._handleComplete();
	}
}