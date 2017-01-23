package hex.control.macro;

#if (!neko || haxe_ver >= "3.3")
import hex.control.async.IAsyncCommand;

/**
 * ...
 * @author Francis Bourre
 */
class MockMacroWithHandler extends Macro
{
	override function _prepare() : Void 
	{
		this.add( MockAsyncCommand ).withCompleteHandler( this.onCommandComplete );
	}
	
	function onCommandComplete( command: IAsyncCommand ) : Void
	{
		this.add( MockCommand );
	}
}
#end