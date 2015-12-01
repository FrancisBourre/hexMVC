package;

import hex.HexMVCSuite;
import hex.unittest.runner.ExMachinaUnitCore;
import hex.unittest.runner.TestRunner;

#if flash
import hex.unittest.notifier.TraceNotifier;
#else
import hex.unittest.notifier.ConsoleNotifier;
#end

/**
 * ...
 * @author Francis Bourre
 */
class MainMVCTest
{
	static public function main() : Void
	{
		var emu : ExMachinaUnitCore = new ExMachinaUnitCore();
        
		#if flash
		TestRunner.RENDER_DELAY = 0;
		emu.addListener( new TraceNotifier( false ) );
		#else
		emu.addListener( new ConsoleNotifier( false ) );
		#end
		
        emu.addTest( HexMVCSuite );
        emu.run();
	}
}