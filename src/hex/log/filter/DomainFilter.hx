package hex.log.filter;

import haxe.PosInfos;
import hex.domain.Domain;
import hex.log.ILogger;
import hex.log.LogLevel;
import hex.log.filter.AbstractFilter;
import hex.log.filter.IFilter.FilterResult;
import hex.log.message.IDomainMessage;
import hex.log.message.IMessage;

class DomainFilter extends AbstractFilter 
{
	var domain:Domain;

	public function new(domain:Domain, onMatch:FilterResult, onMismatch:FilterResult) 
	{
		super(onMatch, onMismatch);
		this.domain = domain;
	}
	
	function filterDomain(message:IMessage):FilterResult
	{
		if (Std.is(message, IDomainMessage))
		{
			return (cast(message, IDomainMessage).getDomain() == domain) ?  onMatch : onMismatch;
		}
		else
		{
			return onMismatch;
		}
	}
	
	override public function filter(logger:ILogger, level:LogLevel, message:Dynamic, params:Array<Dynamic>, ?posInfos:PosInfos):FilterResult 
	{
		return onMismatch;
	}
	
	override public function filterEvent(event:LogEvent):FilterResult 
	{
		return filterDomain(event.message);
	}
	
	override public function filterMessage(logger:ILogger, level:LogLevel, message:IMessage, ?posInfos:PosInfos):FilterResult 
	{
		return filterDomain(message);
	}
	
	override public function filterLoggerMessage(logger:ILogger, message:IMessage):FilterResult 
	{
		return filterDomain(message);
	}
	
}