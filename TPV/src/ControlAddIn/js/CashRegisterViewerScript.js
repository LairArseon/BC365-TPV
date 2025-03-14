Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ViewerReady', '');

LoadedLines = [];
SourceElement = null;

class Line {
    elementSource = null;
    fields = [];
    constructor(ElementSource, FieldArray) {
        this.elementSource = ElementSource;
        FieldArray.forEach(Field => {
            this.fields.push(Field)
        });
    }
}

function LoadElement(ElementSource, CashRegister) {
    alert(JSON.stringify(CashRegister))
}

function GetSourceElement() {
    if (SourceElement != null) {
        return (SourceElement);
    }

    // Select the ControlAddIn element and attach a container to it to use as reference to display further elements
    ControlAddinElement = $("#controlAddIn");
    ExternalDivElement = $('<div></div>').attr('id', 'TPVSourceContainer').attr('class', 'container');
    SourceElement = ExternalDivElement;
    return (SourceElement);
}

function FindElementBySource(ElementSource) {
    return (array.find(item => item.elementSource === ElementSource));
}

function DisplayElement(ElementSource) {
    DisplayElement = FindElementBySource(ElementSource);
    BaseBuildingBlock = GetSourceElement();


}