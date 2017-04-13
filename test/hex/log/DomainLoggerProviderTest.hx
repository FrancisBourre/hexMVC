package hex.log;
import hex.di.Injector;
import hex.di.provider.DomainLoggerProvider;
import hex.domain.TopLevelDomain;
import hex.log.message.DomainMessageFactory;
import hex.log.mock.MockLoggerInjectee;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author ...
 */
class DomainLoggerProviderTest 
{

	public function new() 
	{
	}
	
	@Test("Test dependency provider")
	public function testDependencyProvider()
	{
		var provider = new DomainLoggerProvider(null, null);
		
		var resultLogger = provider.getResult(null, MockLoggerInjectee);
		
		Assert.equals("hex.log.mock.MockLoggerInjectee", resultLogger.getName(), "Logger name must be same as the injectee class name");
	}
	
	@Test("Test dependency provider in injector")
	public function testDependencyProviderInInjector()
	{
		var injector = new Injector();
		
		injector.map(ILogger).toProvider(new DomainLoggerProvider(null, null));
		var injectee = injector.instantiateUnmapped(MockLoggerInjectee);
		
		Assert.equals("hex.log.mock.MockLoggerInjectee", injectee.logger.getName(), "Logger name must be same as the injectee class name");
	}
	
	@Test("Test dependency provider fallback")
	public function testFallbackLogger()
	{
		var logger = LogManager.getLogger("fallback");
		
		var provider = new DomainLoggerProvider(null, logger);
		
		var resultLogger = provider.getResult(null, null);
		
		Assert.equals(logger, resultLogger, "Loggers must be the same");
	}
	
	@Test("Test dependency provider fallback in injector")
	public function testFallbackLoggerInInjector()
	{
		var injector = new Injector();
		
		var logger = LogManager.getLogger("fallback");
		
		injector.map(ILogger).toProvider(new DomainLoggerProvider(null, logger));
		var resultLogger = injector.getInstance(ILogger);
		
		Assert.equals(logger, resultLogger, "Loggers must be the same");
	}
	
	
}