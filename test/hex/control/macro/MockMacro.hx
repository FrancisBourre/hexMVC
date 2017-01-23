package hex.control.macro;

/**
 * ...
 * @author Francis Bourre
 */
class MockMacro extends Macro
{
	override function _prepare() : Void
	{
		#if (!neko || haxe_ver >= "3.3")
		this.add( MockAsyncCommand );
		#end
		this.add( MockCommand );
	}
}