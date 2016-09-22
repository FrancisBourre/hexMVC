package hex.control.macro;

/**
 * ...
 * @author Francis Bourre
 */
class MockMacro extends Macro
{
	override function _prepare() : Void
	{
		this.add( MockAsyncCommand );
		this.add( MockCommand );
	}
}