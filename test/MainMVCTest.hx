package;

import hex.HexMVCSuite;
import hex.unittest.runner.ExMachinaUnitCore;
import hex.unittest.notifier.TraceNotifier;
#if js
import hex.unittest.notifier.ConsoleNotifier;
#elseif flash
import flash.Lib;
#end

/**
 * ...
 * @author Francis Bourre
 */
class MainMVCTest
{
	static public function main() : Void
	{
		var emu = new ExMachinaUnitCore();
        
		#if flash
		emu.addListener( new TraceNotifier( Lib.current.loaderInfo ) );
		#elseif js
		emu.addListener( new ConsoleNotifier( false ) );
		#else
		emu.addListener( new TraceNotifier( false ) );
		#end
		
        emu.addTest( HexMVCSuite );
        emu.run();
	}
}