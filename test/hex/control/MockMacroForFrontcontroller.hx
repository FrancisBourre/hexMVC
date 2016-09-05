package hex.control;

import hex.control.macro.Macro;
import hex.control.macro.MacroExecutor;

/**
 * ...
 * @author Francis Bourre
 */
class MockMacroForFrontcontroller extends Macro
{
	public static var executeCallCount 				: Int = 0;
	public static var requestParameter 				: Request;
	
	public function new()
	{
		super();
		this.macroExecutor = new MacroExecutor();
	}
	
	override function _prepare() : Void 
	{
		MockMacroForFrontcontroller.executeCallCount++;
		MockMacroForFrontcontroller.requestParameter = this._request;
	}
}