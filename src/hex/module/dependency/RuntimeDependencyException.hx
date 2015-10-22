package hex.module.dependency;

import haxe.PosInfos;
import hex.error.Exception;

class RuntimeDependencyException  extends Exception
{
    public function new ( message : String, ?posInfos : PosInfos )
    {
        super( message, posInfos );
    }
}