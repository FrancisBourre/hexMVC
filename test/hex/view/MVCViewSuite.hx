package hex.view;

import hex.view.viewhelper.MVCViewHelperSuite;

/**
 * ...
 * @author Tamas Kinsztler
 */
class MVCViewSuite
{
  	@Suite("View")
    public var list : Array<Class<Dynamic>> = [ BasicViewTest, MVCViewHelperSuite ];
}
