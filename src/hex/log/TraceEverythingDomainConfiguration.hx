package hex.log;

import hex.log.configuration.BasicConfiguration;
import hex.log.layout.DomainLayout;
import hex.log.target.TraceLogTarget;

/**
 * ...
 * @author ...
 */
class TraceEverythingDomainConfiguration extends BasicConfiguration 
{

	public function new() 
	{
		super();
		
		var lc = getRootLogger();
		var traceTarget = new TraceLogTarget("Trace", null, new DomainLayout());
		root.level = LogLevel.ALL;
		lc.addLogTarget(traceTarget, LogLevel.ALL, null);
		addLogger(lc.name, lc);
	}
	
}