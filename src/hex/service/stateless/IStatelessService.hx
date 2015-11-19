package hex.service.stateless;

import hex.control.ICancellable;
import hex.data.IParser;
import hex.service.IService;

/**
 * @author Francis Bourre
 */

interface IStatelessService extends IService extends ICancellable
{
	//var result( get, set ) : Dynamic;
	function getResult() : Dynamic;
	
	//var rawResult( get, null ) : Dynamic;
	function getRawResult() : Dynamic;
	
	function setParser( parser : IParser ) : Void;
	
	function handleComplete() : Void;
	
	function handleFail() : Void;
	
	function handleCancel() : Void;
	
	function release() : Void;
	
	function addStatelessServiceListener( listener : IStatelessServiceListener ) : Void;
	
	function removeStatelessServiceListener( listener : IStatelessServiceListener ) : Void;
	
	function removeAllListeners() : Void;
	
	function addHandler( eventType : String, handler : ServiceEvent->Void ) : Void;
	
	function removeHandler( eventType : String, handler : ServiceEvent->Void ) : Void;
	
	var wasUsed( get, null ) : Bool;
	
	var isRunning( get, null ) : Bool;
	
	var hasCompleted( get, null ) : Bool;
	
	var hasFailed( get, null ) : Bool;
	
	var isCancelled( get, null ) : Bool;
}