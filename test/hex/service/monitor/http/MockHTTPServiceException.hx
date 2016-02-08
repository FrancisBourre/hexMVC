package hex.service.monitor.http;

import haxe.PosInfos;
import hex.error.Exception;

/**
 * ...
 * @author Francis Bourre
 */
class MockHTTPServiceException extends Exception
{
	public function new ( message : String, ?posInfos : PosInfos )
    {
        super( message, posInfos );
    }
}