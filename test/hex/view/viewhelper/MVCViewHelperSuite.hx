package hex.view.viewhelper;

/**
 * ...
 * @author Francis Bourre
 */
class MVCViewHelperSuite
{
	@Suite("ViewHelper")
    public var list : Array<Class<Dynamic>> = [ MainViewHelperManagerMessageTest, ViewHelperManagerMessageTest, ViewHelperManagerTest, ViewHelperMessageTest, ViewHelperTest ];
}
