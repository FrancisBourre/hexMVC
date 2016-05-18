package hex.control.controller;

import haxe.Timer;
import hex.control.action.Order;

/**
 * ...
 * @author Francis Bourre
 */
class MockOrderClassWithParameters extends Order<String>
{
	var _message : String;
	
	public static var callCount 	: UInt = 0;
	public static var sender 		: ControllerTest = null;
	
	public function new() 
	{
		super();
	}
	
	public function execute( text : String, sender : ControllerTest ) : Void
	{
		MockOrderClassWithParameters.callCount++;
		MockOrderClassWithParameters.sender = sender;
		
		this._message = text;
		Timer.delay( this._end, 50 );
	}
	
	function _end() : Void
	{
		this._complete( this._message );
	}
}