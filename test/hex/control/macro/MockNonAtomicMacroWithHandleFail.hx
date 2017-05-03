package hex.control.macro;

import hex.control.async.AsyncCommand;
import hex.control.async.IAsyncCommand;

/**
 * ...
 * @author Francis Bourre
 */
class MockNonAtomicMacroWithHandleFail extends Macro
{
	public var requestPassedDuringExecution	: Request;
	
	override function _prepare() : Void
	{
		this.isAtomic = false;
		this.add(TestAsyncCommand1);
		this.add(TestAsyncCommandThatShouldBeBeExecuted).withCompleteHandler( this.onComplete );
	}
	
	function onComplete( command:IAsyncCommand ) 
	{
		this._handleFail();
	}
}

class TestAsyncCommand1 extends AsyncCommand
{
	override public function execute():Void 
	{
		this._handleComplete();
	}
}


class TestAsyncCommandThatShouldBeBeExecuted extends AsyncCommand
{
	public static var EXECUTED:Bool = false;
	
	override public function execute():Void 
	{
		EXECUTED = true;
		this._handleComplete();
	}
}