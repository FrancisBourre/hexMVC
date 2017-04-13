package hex.log;
import hex.domain.Domain;
import hex.domain.TopLevelDomain;
import hex.log.filter.DomainFilter;
import hex.log.filter.IFilter.FilterResult;
import hex.log.message.DomainMessage;
import hex.log.message.ObjectMessage;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author ...
 */
class DomainFilterTest 
{

	public function new() 
	{
	}
	
	
	@Test("Test domain filter match")
	public function testDomainFilterMatch()
	{
		var d = Domain.getDomain("testDomain");
		var filter = new DomainFilter(d, FilterResult.ACCEPT, FilterResult.DENY);
		
		Assert.equals(FilterResult.ACCEPT, filter.filterEvent(new LogEvent(null, new DomainMessage(d, "", []), LogLevel.DEBUG)));
		Assert.equals(FilterResult.ACCEPT, filter.filterLoggerMessage(null, new DomainMessage(d, "", [])));
		Assert.equals(FilterResult.ACCEPT, filter.filterMessage(null, LogLevel.DEBUG, new DomainMessage(d, "", [])));
	}
	
	@Test("Test domain filter mismatch")
	public function testDomainFilterMismatch()
	{
		var d = Domain.getDomain("testDomain");
		var filter = new DomainFilter(TopLevelDomain.DOMAIN, FilterResult.ACCEPT, FilterResult.DENY);
		
		Assert.equals(FilterResult.DENY, filter.filter(null, LogLevel.DEBUG, "", []));
		Assert.equals(FilterResult.DENY, filter.filterEvent(new LogEvent(null, new DomainMessage(d, "", []), LogLevel.DEBUG)));
		Assert.equals(FilterResult.DENY, filter.filterLoggerMessage(null, new DomainMessage(d, "", [])));
		Assert.equals(FilterResult.DENY, filter.filterMessage(null, LogLevel.DEBUG, new DomainMessage(d, "", [])));
	}
	
}