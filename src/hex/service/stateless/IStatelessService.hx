package hex.service.stateless;

import hex.control.ICancellable;
import hex.data.IParser;
import hex.service.IService;

/**
 * @author Francis Bourre
 */

interface IStatelessService<EventClass:ServiceEvent> extends IService<EventClass> extends ICancellable
{
	function getResult() : Dynamic;

	function getRawResult() : Dynamic;
	
	function setParser( parser : IParser ) : Void;
	
	function handleComplete() : Void;
	
	function handleFail() : Void;
	
	function handleCancel() : Void;
	
	function release() : Void;
	
	function addStatelessServiceListener( listener : IStatelessServiceListener<EventClass> ) : Void;
	
	function removeStatelessServiceListener( listener : IStatelessServiceListener<EventClass> ) : Void;
	
	function removeAllListeners() : Void;
	
	function addHandler( eventType : String, handler : EventClass->Void ) : Void;
	
	function removeHandler( eventType : String, handler : EventClass->Void ) : Void;
	
	var wasUsed( get, null ) : Bool;
	
	var isRunning( get, null ) : Bool;
	
	var hasCompleted( get, null ) : Bool;
	
	var hasFailed( get, null ) : Bool;
	
	var isCancelled( get, null ) : Bool;
}