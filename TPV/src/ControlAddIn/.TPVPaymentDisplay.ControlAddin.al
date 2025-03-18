controladdin "TPV Payment Display"
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
        './src/ControlAddIn/js/LineDisplayViewerScript.js';
    StyleSheets =
        './src/ControlAddIn/css/bootstrap.min.css',
        './src/ControlAddIn/css/CustomStyles.css';

    #region Events

    event ViewerReady()

    event TriggerSelector(ElementID: Text; FieldNo: Integer)

    event UpdateFieldValue(ElementID: Text; FieldNo: Integer; NewValue: Text)

    event Submit()

    #endregion

    #region Procedures

    procedure LoadElement(ElementID: Text; PaymentLine: JsonObject)

    procedure DisplayElement(ElementID: Text)

    procedure UpdateFieldDisplayValue(ElementID: Text; FieldNo: Integer; NewValue: Text)

    procedure ThrowError(ElementID: Text; FieldNo: Integer; ErrorText: Text)

    #endregion
}