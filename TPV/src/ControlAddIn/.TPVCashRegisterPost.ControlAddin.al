controladdin "TPV Cash Register Post"
{
    RequestedHeight = 1500;
    MinimumHeight = 1500;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;

    Scripts =
        './src/ControlAddIn/js/jquery-3.7.1.min.js',
        './src/ControlAddIn/js/bootstrap.bundle.min.js',
        './src/ControlAddIn/js/CashRegisterViewerScript.js';
    StyleSheets =
        './src/ControlAddIn/css/bootstrap.min.css',
        './src/ControlAddIn/css/CustomStyles.css';

    #region Events

    event ViewerReady()

    #endregion

    #region Procedures

    procedure LoadElement(ElementID: Text; CashRegister: JsonObject)

    procedure DisplayElement(ElementID: Text)

    #endregion
}