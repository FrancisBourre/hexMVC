package hex.control.macro;

/**
 * ...
 * @author Francis Bourre
 */
class MockEmptyMacroWithPrepareOverriden extends Macro
{
	public var requestPassedDuringExecution	: Request;
	
	override function _prepare() : Void
	{
		this.requestPassedDuringExecution = this._request;
	}
}
