package hex;

import hex.config.MVCConfigSuite;
import hex.control.MVCControlSuite;
import hex.event.MVCEventSuite;
import hex.metadata.MVCMetadataSuite;
import hex.model.MVCModelSuite;
import hex.module.MVCModuleSuite;
import hex.view.MVCViewSuite;

/**
 * ...
 * @author Francis Bourre
 */
class HexMVCSuite
{
	@Suite( "HexMVC" )
    public var list : Array<Class<Dynamic>> = [ MVCConfigSuite, MVCControlSuite, MVCEventSuite, MVCMetadataSuite, MVCModelSuite, MVCModuleSuite, MVCViewSuite ];
}
