package hex.module.dependency;

import haxe.PosInfos;
import hex.error.Exception;

/**
 * ...
 * @author Francis Bourre
 */
class RuntimeDependencyException  extends Exception
{
    public function new ( message : String, ?posInfos : PosInfos )
    {
        super( message, posInfos );
    }
}