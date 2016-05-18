package hex.control.controller;

import hex.control.action.Order;

/**
 * ...
 * @author Francis Bourre
 */
class MockOrderClassWithoutParameters extends Order<Void>
{
	public static var callCount : UInt = 0;
	
	public function new() 
	{
		super();
	}
	
	public function execute() : Void
	{
		MockOrderClassWithoutParameters.callCount++;
	}
}