package hex.service.stateful;

/**
 * @author Francis Bourre
 */
interface IStatefulService<EventClass:ServiceEvent, ConfigurationClass:ServiceConfiguration> extends IService<EventClass, ConfigurationClass>
{
	
}