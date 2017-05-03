package hex.control.macro;

import hex.control.async.AsyncCommand;
import hex.control.async.IAsyncCommand;

/**
 * ...
 * @author Francis Bourre
 */
class MockAtomicMacroWithHandleFail extends Macro
{
	public var requestPassedDuringExecution	: Request;
	
	override function _prepare() : Void
	{
		this.add(TestAsyncCommandToRun).withCompleteHandler( this.onComplete );
		this.add(TestAsyncCommandToNotRun);
	}
	
	function onComplete( command:IAsyncCommand ) 
	{
		this._handleFail();
	}
}

class TestAsyncCommandToRun extends AsyncCommand
{
	override public function execute():Void 
	{
		this._handleComplete();
	}
}


class TestAsyncCommandToNotRun extends AsyncCommand
{
	public static var EXECUTED:Bool = false;
	
	override public function execute():Void 
	{
		EXECUTED = true;
		this._handleComplete();
	}
}